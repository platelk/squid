part of frost;

class Routes implements RouteMatcher {
  String path;
  List<RouteMatcher> _routes = [];

  Routes(String this.path) {
    if (this.path.length >= 1 && this.path[this.path.length - 1] == '/') {
      throw new FormatException("path in group shouldn't end with '/'",
          this.path, this.path.length - 1);
    }
  }

  @override
  void serve(Request req, Response res) {
    for (var route in this._routes) {
      if (route.match(req.method, req.path, req.contentType)) {
        route.serve(req, res);
      }
    }
  }

  @override
  bool match(HttpMethod httpMethod, String path, ContentType contentType) {
    for (var route in this._routes) {
      if (route.match(httpMethod, path, contentType)) {
        return true;
      }
    }
    return false;
  }

  void add(RouteMatcher r) {
    this._routes.add(r);
  }

  Routes group(String path) {
    var grp = new Routes(this.path+path);
    this.add(grp);
    return grp;
  }

  void before(String path, HandlerFunc handler, {String acceptType: "*/*"}) {
    this.add(new Route(this.path + path, handler,
        method: HttpMethod.before, acceptType: acceptType));
  }

  void after(String path, HandlerFunc handler, {String acceptType: "*/*"}) {
    this.add(new Route(this.path + path, handler,
        method: HttpMethod.after, acceptType: acceptType));
  }

  void afterAfter(
      String path, HandlerFunc handler, {String acceptType: "*/*"}) {
    this.add(new Route(this.path + path, handler,
        method: HttpMethod.afterAfter, acceptType: acceptType));
  }

  void get(String path, HandlerFunc handler, {String acceptType: "*/*"}) {
    this.add(new Route(this.path + path, handler,
        method: HttpMethod.get, acceptType: acceptType));
  }

  void post(String path, HandlerFunc handler, {String acceptType: "*/*"}) {
    this.add(new Route(this.path + path, handler,
        method: HttpMethod.post, acceptType: acceptType));
  }

  void put(String path, HandlerFunc handler, {String acceptType: "*/*"}) {
    this.add(new Route(this.path + path, handler,
        method: HttpMethod.put, acceptType: acceptType));
  }

  void delete(String path, HandlerFunc handler, {String acceptType: "*/*"}) {
    this.add(new Route(this.path + path, handler,
        method: HttpMethod.delete, acceptType: acceptType));
  }

  void options(String path, HandlerFunc handler, {String acceptType: "*/*"}) {
    this.add(new Route(this.path + path, handler,
        method: HttpMethod.options, acceptType: acceptType));
  }

  void patch(String path, HandlerFunc handler, {String acceptType: "*/*"}) {
    this.add(new Route(this.path + path, handler,
        method: HttpMethod.patch, acceptType: acceptType));
  }
}
