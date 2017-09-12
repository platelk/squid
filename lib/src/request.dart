part of frost;

const String userAgent = "user-agent";

class Request {
  HttpRequest _req;
  shelf.Request _shelfReq;
  Encoding encoding;

  Request.fromHttpRequest(HttpRequest this._req);
  Request();

  Map<String, String> get attribute {
    return {};
  }

  Stream<List<int>> get body {
    return this._body.read();
  }

  Future<String> readAsString([Encoding encoding]) {
    if (encoding == null) encoding = this.encoding;
    if (encoding == null) encoding = UTF8;
    return encoding.decodeStream(this.body);
  }

  Stream<List<int>> read() {
    return this.body;
  }

  int get contentLength {
    return this._req.contentLength;
  }

  String get contentType {
    return this._req.mimeType;
  }

  String get mimeType {
    var contentType = _contentType;
    if (contentType == null) return null;
    return contentType.mimeType;
  }

  String get scheme {
    return this._req.url.scheme;
  }

  String get host {
    return this._req.url.host;
  }

  String get userAgent {
    return this._req.headers[UserAgent];
  }

  int get port {
    return this._req.url.port;
  }

  String get ip {
  }

  String get path {
    return this._req.requestedUri.path;
  }

  List<String> get cookies {
    return [];
  }

  HttpMethod get method {
    return new HttpMethod._(this._req.method);
  }

  shelf.Request toShelfRequest() {
    var headers = <String, String>{};
    this._req.headers.forEach((k, v) {
      // Multiple header values are joined with commas.
      // See http://tools.ietf.org/html/draft-ietf-httpbis-p1-messaging-21#page-22
      headers[k] = v.join(',');
    });

    // Remove the Transfer-Encoding header per the adapter requirements.
    headers.remove(HttpHeaders.TRANSFER_ENCODING);

    void onHijack(void callback(StreamChannel<List<int>> channel)) {
      this._req.response
          .detachSocket(writeHeaders: false)
          .then((socket) => callback(new StreamChannel(socket, socket)));
    }

    return new shelf.Request(this._req.method, this._req.requestedUri,
        protocolVersion: this._req.protocolVersion,
        headers: headers,
        body: this._req,
        onHijack: onHijack);
  }
}