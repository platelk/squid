part of frost;

typedef HandlerFunc = void Function(Request req, Response res);
typedef GroupHandler = void Function(Server group);

abstract class RouteMatcher {
  bool match(HttpMethod httpMethod, String path, ContentType contentType);

  void serve(Request req, Response res);
}

class Route implements RouteMatcher {
  HttpMethod method;
  String path;
  String acceptType;
  AcceptType _acceptTypes;
  HandlerFunc handler;

  Route(String this.path, HandlerFunc this.handler,
      {HttpMethod this.method = HttpMethod.get,
      String this.acceptType = "*/*"}) {
    if (!this.path.startsWith("/")) {
      throw new FormatException("path in route must start with '/'", this.path, 0);
    }
    if (this.path.length > 1 && this.path.endsWith("/")) {
      throw new FormatException("path in route must not end with '/'", this.path, this.path.length);
    }
    this._acceptTypes = new AcceptType.parse(this.acceptType);
  }

  @override
  void serve(Request req, Response res) {
    if (this.handler != null) {
      this.handler(req, res);
    }
  }

  @override
  bool match(HttpMethod httpMethod, String path, ContentType contentType) {
    return this.method == httpMethod &&
        this._acceptTypes.match(contentType) &&
        _matchPath(path);
  }

  @override
  bool operator ==(Object o) {
    if (o is Route) {
      return this.method == o.method &&
          this.path == o.path &&
          this.acceptType == o.acceptType;
    }
    return false;
  }

  bool _matchPath(String path) {
    var j = 0;
    for (var i = 0; i < this.path.length; i++, j++) {
      if (this.path[i] == pathParamsSep) {
        for (i += 1; i < this.path.length && this.path[i] != uriPathSep; i++);
        for (; j < path.length && path[j] != uriPathSep; j++);
      }
      if (j >= path.length && i >= this.path.length) {
        return true;
      }
      if (j >= path.length || this.path[i] != path[j]) {
        return false;
      }
    }
    return true;
  }
}
