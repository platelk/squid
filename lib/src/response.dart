part of frost;

class Response {
  HttpResponse _response;

  Response() {}

  dynamic get body => null;
  HttpHeaders get headers => this._response.headers;

  int get status => this._response.statusCode;
  void set status(int statusCode) => this._response.statusCode = statusCode;
}