part of frost;

const String userAgent = "user-agent";

class Request {
  shelf.Request _shelf;
  Encoding encoding;

  Request.fromShelf(shelf.Request this._shelf);

  Request();

  Future<String> readAsString([Encoding encoding]) =>
      this._shelf.readAsString(encoding);

  Stream<List<int>> read() => this._shelf.read();

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
  int get contentLength => this._shelf.contentLength;

  /// content type of request.body
  String get contentType => this._shelf.mimeType;

  /// // the context path, e.g. "/hello"
  String get contextPath => this._shelf.url.path;

  /// request cookies sent by the client
  List<String> get cookies => [];

  /// the HTTP header list
  Map<String, String> get headers => this._shelf.headers;

  /// the host, e.g. "example.com"
  String get host => this._shelf.url.host;

  /// client IP address
  String get ip => "";

  /// value of foo path parameter
  Map<String, String> get params => {};

  /// the path info
  String get pathInfo => "";

  /// the server port
  int get port => this._shelf.url.port;

  /// the protocol
  String get protocol => this._shelf.url.scheme;

  /// the query map
  QueryParamsMap get queryMap => new QueryParamsMap.fromParamsList(this.queryParamsList);

  /// the query param
  Map<String, String> get queryParams => this._shelf.url.queryParameters;

  /// all values of FOO query param
  Map<String, List<String>> get queryParamsList =>
      this._shelf.url.queryParametersAll;

  /// The HTTP method (GET, ..etc)
  HttpMethod get method => new HttpMethod._(this._shelf.method);

  /// "http"
  String get scheme => this._shelf.url.scheme;

  /// session management
  dynamic get session => null;

  /// the uri, e.g. "http://example.com/foo"
  Uri get uri => this._shelf.url;

  /// user agent
  String get userAgent => this._shelf.headers[userAgent];

  String get path => this._shelf.requestedUri.path;

  shelf.Request get shelfRequest => this._shelf;
}
