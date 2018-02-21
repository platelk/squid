part of sting;

class Routes extends Route {
  String path;
  List<Route> _routes = [];

  Routes(String this.path) : super("/", (req, res) => "") {
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
        return;
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

  void add(Route r) {
    this._routes.add(r);
  }

  Routes group(String path) {
    var grp = new Routes(this.path + path);
    this.add(grp);
    return grp;
  }

  void before(HandlerFunc handler) {
    this.use((HandlerFunc h) {
      return (req, res) {
        handler(req, res);
        h(req, res);
      };
    });
  }

  void after(HandlerFunc handler) {
    this.use((HandlerFunc h) {
      return (req, res) {
        h(req, res);
        handler(req, res);
      };
    });
  }

  void use(Handler middleware) {
    for (int i = 0; i < this._routes.length; i++) {
      this._routes[i].handler = middleware(this._routes[i].handler);
    }
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
