part of squid;

class Response {
  HttpResponse _response;

  Response(this._response);

  /// get response content
  dynamic get body => this._response;

  HttpHeaders get headers => this._response.headers;

  HttpResponse get raw => this._response;

  void redirect(String content, [int code]) {
    this.status = code;
    this._response.write(content);
  }

  int get status => this._response.statusCode;

  void set status(int statusCode) => this._response.statusCode = statusCode;

  ContentType get type => this.headers?.contentType;

  void set type(ContentType type) => this.headers.contentType = type;
}
