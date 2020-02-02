part of squid;

var DefaultRequestBinder = <ContentType, Binder>{
  ContentType.json: jsonBinder,
  ContentType.parse('application/json'): jsonBinder,
  ContentType.text: stringBinder,
  ContentType.parse('application/x-www-form-urlencoded'): formBinder,
};

/// [Request] is the representation of an incoming HTTP request
///
/// [Request] will provide simple functions to interact with an http incoming request
/// but will still expose the underlying request for compatibility reasons.
class Request {
  Request(HttpRequest this._request, {String contextPath}) {
    this.contextPath = new Path(contextPath);
    var headers = new Map<String, String>();
    this._request?.headers?.forEach((key, values) => headers[key] = values.join(","));
    this._shelf = new shelf.Request(this._request?.method, this._request?.requestedUri,
        handlerPath: this._request?.requestedUri?.path ?? "/",
        protocolVersion: this._request?.protocolVersion,
        headers: headers,
        body: this._request,
        onHijack: this._onHijack);
  }

  /// _shelf is the Shelf representation of an incoming HTTP request.
  /// It will be created based on [HttpRequest].
  shelf.Request _shelf;

  /// _request is the real underlying incoming http request
  HttpRequest _request;

  /// _params hold the parsed query parameters based on the [contextPath]
  Map<String, String> _params;

  /// _binder will hold the mapping of which [Binder] to use based on the accepted types
  Map<ContentType, Binder> binders = Map.from(DefaultRequestBinder);
  
  /// encoding is the encoding information which will be used for decode the request's body.
  /// It will be discover by default using HTTP header if not specified.
  Encoding encoding;

  /// contextPath is the original path which triggered the handler. e.g "/hello/:param"
  Path contextPath;

  Future<String> readAsString([Encoding encoding]) => this._shelf?.readAsString(encoding);

  Stream<List<int>> read() => this._shelf?.read();

  /// the attributes map
  Map<String, String> get attributes => {};

  String attribute(String key, [String value]) {
    if (value == null) {
      return this.attributes[key];
    }
    this.attributes[key] = value;
    return value;
  }

  /// request body sent by the client
  Future<String> get body => this.readAsString();

  /// request body as bytes
  Stream<List<int>> get bodyAsBytes => this.read();

  /// length of request body
  ///
  /// If the size of the request body is not known in advance,
  /// this value is -1.
  int get contentLength => this._request.contentLength;

  /// content type of request.body
  ContentType get contentType => this._request.headers?.contentType ?? ContentType.TEXT;

  /// request cookies sent by the client
  List<Cookie> get cookies => this._request.cookies;

  Cookie getCookie(String name) {
    for (final cookie in cookies) {
      if (cookie.name == name) {
        return cookie;
      }
    }
    return null;
  }

  /// the HTTP header list
  HttpHeaders get headers => this._request.headers;

  /// the host, e.g. "example.com"
  String get host => this._request.uri?.host;

  /// client IP address
  InternetAddress get ip => this._request.connectionInfo?.remoteAddress;

  /// value of foo path parameter
  String param(String name) => this.params[name];

  /// params will return all the params
  Map<String, String> get params => this._params ?? this._parseParams();

  Map<String, String> _parseParams() {
    this._params ??= this.contextPath.extractParams(this.path);
    return this._params;
  }

  /// the server port
  int get port => this._request.uri?.port;

  /// the protocol
  String get protocol => this._request.uri?.scheme;

  /// the query map
  // Looks like incompatible with Uri.parse, need to look further on this.
  //  QueryParamsMap get queryMap =>
  //      new QueryParamsMap.fromParamsList(this.queryParamsList);

  /// the query param
  Map<String, String> get queryParams => this._shelf?.url?.queryParameters;

  /// all values of FOO query param
  Map<String, List<String>> get queryParamsList => this._shelf?.url?.queryParametersAll;

  /// The HTTP method (GET, ..etc)
  HttpMethod get method => new HttpMethod.parse(this._request.method);

  /// "http"
  String get scheme => this._request.uri?.scheme;

  /// session management
  HttpSession get session => this._request.session;

  /// the uri, e.g. "http://example.com/foo"
  Uri get uri => this._request.uri;

  /// the url. e.g. "http://example.com/foo"
  Uri get url => this._shelf?.url;

  /// user agent
  String get userAgent => this.headers.value(HttpHeaders.userAgentHeader);

  String get path => this._shelf?.requestedUri?.path;

  shelf.Request get shelfRequest => this._shelf;

  HttpRequest get request => this._request;
  
  /// bind will parse the incoming request, based on the content type to bind the body to the type T
  Future<T> bind<T>() async {
    T receiver;
    return bindOn<T>(receiver);
  }
  
  /// bindOn will parse the incoming request, based on the content type to bind the body to the receiver to reuse memory
  Future<T> bindOn<T>(T receiver) async {
    var body = await this.body;
    var found = false;
    for (var c in this.binders.keys) {
      var b = this.binders[c];
      if (c.primaryType == contentType.primaryType && c.subType == contentType.subType && (c.charset == "" || c.charset == contentType.charset)) {
        receiver = b(body, receiver) as T;
        found = true;
        break;
      }
    }
    if (!found) {
      return stringBinder(body, receiver) as T;
    }
    return receiver;
  }

  void _onHijack(void callback(StreamChannel<List<int>> channel)) {
    request.response.detachSocket(writeHeaders: false).then((socket) => callback(new StreamChannel(socket, socket)));
  }
  
  
}
