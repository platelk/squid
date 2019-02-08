part of squid;

class Routes extends Route {
  Routes(String this.path) : super("/", (req, res) => "") {
    if (this.path.length >= 1 && this.path[this.path.length - 1] == '/') {
      throw new FormatException("path in group shouldn't end with '/'",
          this.path, this.path.length - 1);
    }
  }
  
  String path;
  List<Route> _routes = [];

  Handler middleware = (h) => h;
  
  List<Route> get routes => new List.from(this._routes, growable: false);

  @override
  bool serve(Request req, Response res) {
    for (var route in this._routes) {
      if (route.match(req.method, req.path, req.contentType)) {
        return route.serve(req, res);
      }
    }
    return false;
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
    r.handler = this.middleware(r.handler);
    this._routes.add(r);
    this._routes.sort((r1, r2) => r1.compareTo(r2));
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
    var prevMiddleware = this.middleware;
    this.middleware = (h) => prevMiddleware(middleware(h));
    for (int i = 0; i < this._routes.length; i++) {
      this._routes[i].handler = middleware(this._routes[i].handler);
    }
  }

  void get(String path, HandlerFunc handler, {ContentType acceptType}) {
    this.add(new Route(this.path + path, handler,
        method: HttpMethod.get, acceptType: acceptType));
  }

  void post(String path, HandlerFunc handler, {ContentType acceptType}) {
    this.add(new Route(this.path + path, handler,
        method: HttpMethod.post, acceptType: acceptType));
  }

  void put(String path, HandlerFunc handler, {ContentType acceptType}) {
    this.add(new Route(this.path + path, handler,
        method: HttpMethod.put, acceptType: acceptType));
  }

  void delete(String path, HandlerFunc handler, {ContentType acceptType}) {
    this.add(new Route(this.path + path, handler,
        method: HttpMethod.delete, acceptType: acceptType));
  }

  void options(String path, HandlerFunc handler, {ContentType acceptType}) {
    this.add(new Route(this.path + path, handler,
        method: HttpMethod.options, acceptType: acceptType));
  }

  void patch(String path, HandlerFunc handler, {ContentType acceptType}) {
    this.add(new Route(this.path + path, handler,
        method: HttpMethod.patch, acceptType: acceptType));
  }
}
