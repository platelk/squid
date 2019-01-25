part of squid;

typedef HandlerFunc = void Function(Request req, Response res);

typedef HandlerFunc Handler(HandlerFunc h);

abstract class RouteMatcher {
  bool match(HttpMethod httpMethod, String path, ContentType contentType);

  void serve(Request req, Response res);
}

class Route implements RouteMatcher {
  Route(String contextPath, HandlerFunc this.handler,
      {HttpMethod this.method = HttpMethod.get,
      String this.acceptType = "*/*"}) {
    if (!contextPath.startsWith("/")) {
      throw new FormatException("path in route must start with '/'", contextPath, 0);
    }
    if (contextPath.length > 1 && contextPath.endsWith("/")) {
      throw new FormatException("path in route must not end with '/'", contextPath, contextPath.length);
    }
    this._acceptTypes = new AcceptType.parse(this.acceptType);
    this.contextPath = new Path(contextPath);
  }

  HttpMethod method;
  Path contextPath;
  String acceptType;
  AcceptType _acceptTypes;
  HandlerFunc handler;

  @override
  void serve(Request req, Response res) {
    if (this.handler != null) {
      // Provide which context trigger the handler
      req.contextPath = this.contextPath;
      this.handler(req, res);
    }
  }

  @override
  bool match(HttpMethod httpMethod, String path, ContentType contentType) {
    return this.method == httpMethod &&
        this._acceptTypes.match(contentType) &&
        this.contextPath.match(path);
  }

  @override
  bool operator ==(Object o) {
    if (o is Route) {
      return this.method == o.method &&
          this.contextPath == o.contextPath &&
          this.acceptType == o.acceptType;
    }
    return false;
  }
  
  @override
  String toString() {
    return "[${this.method.value} ${this.contextPath}]";
  }
}
