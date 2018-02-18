part of frost;

typedef HandlerFunc = void Function(Request req, Response res);
typedef GroupHandler = void Function(Server group);

class Route {
  HttpMethod method;
  String path;
  String acceptType;
  AcceptType _acceptTypes;
  HandlerFunc handler;

  Route(String this.path, HandlerFunc this.handler, {HttpMethod this.method = HttpMethod.get, String this.acceptType = "*/*"}) {
    this._acceptTypes = new AcceptType.parse(this.acceptType);
  }

  void serve(Request req, Response res) {
    if (this.handler != null) {
      this.handler(req, res);
    }
  }

  bool match(HttpMethod httpMethod, String path, ContentType contentType) {
    return this.method == httpMethod && this._acceptTypes.match(contentType) && _matchPath(path);
  }

  @override
  bool operator ==(Object o) {
    if (o is Route) {
      return this.method == o.method && this.path == o.path && this.acceptType == o.acceptType;
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
