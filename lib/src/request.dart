part of frost;

const String pathParamsSep = ':';
const String uriPathSep = '/';

/// [Request] is the representation of an incoming HTTP request
///
/// [Request] will provide simple functions to interact with an http incoming request
/// but will still expose the underlying request for compatibility reasons.
class Request {
  /// _shelf is the Shelf representation of an incoming HTTP request.
  /// It will be created based on [HttpRequest].
  shelf.Request _shelf;

  /// _request is the real underlying incoming http request
  HttpRequest _request;

  /// _params hold the parsed query parameters based on the [contextPath]
  Map<String, String> _params;

  /// encoding is the encoding information which will be used for decode the request's body.
  /// It will be discover by default using HTTP header if not specified.
  Encoding encoding;

  /// contextPath is the original path which triggered the handler. e.g "/hello/:param"
  String contextPath;

  Request(HttpRequest this._request, {String this.contextPath}) {
    var headers = new Map<String, String>();
    this
        ._request
        ?.headers
        ?.forEach((key, values) => headers[key] = values.join(","));
    this._shelf = new shelf.Request(this._request.method, this._request.uri,
        protocolVersion: this._request.protocolVersion,
        headers: headers,
        body: this._request,
        onHijack: this._onHijack);
  }

  Future<String> readAsString([Encoding encoding]) =>
      this._shelf?.readAsString(encoding);

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
    this._params = <String, String>{};
    if (this.contextPath == null) {
      return this._params;
    }
    var j = 0;
    for (var i = 0; i < this.contextPath.length; i++, j++) {
      if (this.contextPath[i] == pathParamsSep) {
        var n = "";
        for (i += 1; i < this.contextPath.length && this.contextPath[i] != uriPathSep; i++) {
          n += this.contextPath[i];
        }
        var val = "";
        for (; j < this.path.length && this.path[j] != uriPathSep; j++) {
          val += this.path[j];
        }
        this._params[n] = val;
      }
    }
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
  Map<String, List<String>> get queryParamsList =>
      this._shelf?.url?.queryParametersAll;

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
  String get userAgent => this.headers.value(HttpHeaders.USER_AGENT);

  String get path => this._shelf?.requestedUri?.path;

  shelf.Request get shelfRequest => this._shelf;

  HttpRequest get request => this._request;

  void _onHijack(void callback(StreamChannel<List<int>> channel)) {
    request.response
        .detachSocket(writeHeaders: false)
        .then((socket) => callback(new StreamChannel(socket, socket)));
  }
}
