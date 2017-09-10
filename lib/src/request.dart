part of frost;

class Request {
  shelf.Request _req;

  Request.fromShelf(shelf.Request this._req);
  Request();

  Map<String, String> get attribute {
    return {};
  }

  Stream<List<int>> get bodyAsByte {
    return this._req.read();
  }

  Future<String> get body {
    return this._req.readAsString();
  }

  int get contentLength {
    return this._req.contentLength;
  }

  String get contentType {
    return this._req.mimeType;
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
}