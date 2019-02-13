part of squid;

abstract class RouteMatcher {
  bool match(HttpMethod httpMethod, String path, ContentType contentType);

  bool serve(Request req, Response res);
}

class Route implements RouteMatcher, Comparable<Route> {
  Route(String contextPath, HandlerFunc this.handler,
      {HttpMethod this.method = HttpMethod.get,
      ContentType this.acceptType}) {
    if (!contextPath.startsWith("/")) {
      throw new FormatException("path in route must start with '/'", contextPath, 0);
    }
    if (contextPath.length > 1 && contextPath.endsWith("/")) {
      throw new FormatException("path in route must not end with '/'", contextPath, contextPath.length);
    }
    this.acceptType ??= allContentType;
    this._acceptTypes = new AcceptType([this.acceptType]);
    this.contextPath = new Path(contextPath);
  }

  HttpMethod method;
  Path contextPath;
  ContentType acceptType;
  AcceptType _acceptTypes;
  HandlerFunc handler;

  @override
  bool serve(Request req, Response res) {
    if (this.handler != null) {
      // Provide which context trigger the handler
      req.contextPath = this.contextPath;
      this.handler(req, res);
      return true;
    }
    return false;
  }

  @override
  bool match(HttpMethod httpMethod, String path, ContentType contentType) {
    return this.method == httpMethod &&
        this._acceptTypes.match(contentType) &&
        this.contextPath.match(path);
  }
  
  bool matchType(ContentType type) {
    return this._acceptTypes.match(type);
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
    return "[${this.method.value} ${this.contextPath} ${this._acceptTypes}]";
  }

  @override
  int compareTo(Route other) {
    return -this.contextPath.compareTo(other.contextPath) + this._acceptTypes.compareTo(other._acceptTypes);
  }
}
