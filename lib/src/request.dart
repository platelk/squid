part of frost;

const String userAgent = "user-agent";

class Request {
  shelf.Request _shelf;
  HttpRequest _request;
  Encoding encoding;

  Request(HttpRequest this._request) {
    var headers = new Map<String, String>();
    this
        ._request
        .headers
        .forEach((key, values) => headers[key] = values.join(","));
    this._shelf = new shelf.Request(this._request.method, this._request.uri,
        protocolVersion: this._request.protocolVersion,
        headers: headers,
        handlerPath: this._request.uri?.toString(),
        url: this._request.uri,
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
  ContentType get contentType => this._request.headers?.contentType;

  /// // the context path, e.g. "/hello"
  String get contextPath => this._request.uri?.path;

  /// request cookies sent by the client
  List<Cookie> get cookies => this._request.cookies;

  /// the HTTP header list
  HttpHeaders get headers => this._request.headers;

  /// the host, e.g. "example.com"
  String get host => this._request.uri?.host;

  /// client IP address
  InternetAddress get ip => this._request.connectionInfo?.remoteAddress;

  /// value of foo path parameter
  Map<String, String> get params => {};

  /// the path info
  String get pathInfo => "";

  /// the server port
  int get port => this._request.uri?.port;

  /// the protocol
  String get protocol => this._request.uri?.scheme;

  /// the query map
  QueryParamsMap get queryMap =>
      new QueryParamsMap.fromParamsList(this.queryParamsList);

  /// the query param
  Map<String, String> get queryParams => this._shelf?.url?.queryParameters;

  /// all values of FOO query param
  Map<String, List<String>> get queryParamsList =>
      this._shelf?.url?.queryParametersAll;

  /// The HTTP method (GET, ..etc)
  HttpMethod get method => new HttpMethod._(this._request.method);

  /// "http"
  String get scheme => this._request.uri?.scheme;

  /// session management
  HttpSession get session => this._request.session;

  /// the uri, e.g. "http://example.com/foo"
  Uri get uri => this._request.uri;

  // the url. e.g. "http://example.com/foo"
  Uri get url => this._shelf?.url;

  /// user agent
  String get userAgent => this.headers.value(userAgent);

  String get path => this._shelf?.requestedUri?.path;

  shelf.Request get shelfRequest => this._shelf;

  HttpRequest get request => this._request;

  void _onHijack(void callback(StreamChannel<List<int>> channel)) {
    request.response
        .detachSocket(writeHeaders: false)
        .then((socket) => callback(new StreamChannel(socket, socket)));
  }
}
