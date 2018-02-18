part of frost;

class Routes {
  String path;
  List<Route> _routes = [];

  Routes(this.path);

  void serve(Request req, Response res) {
    for (var route in this._routes) {
      if (route.match(req.method, req.path, req.contentType)) {
        route.serve(req, res);
      }
    }
  }

  void add(Route r) {
    this._routes.add(r);
  }

  void before({String path, HandlerFunc handler, String acceptType: "*/*"}) {
    this.add(
        new Route(this.path + path, handler, method: HttpMethod.before, acceptType: acceptType));
  }

  void after({String path, HandlerFunc handler, String acceptType: "*/*"}) {
    this.add(
        new Route(this.path + path, handler, method: HttpMethod.after, acceptType: acceptType));
  }

  void afterAfter(
      {String path, HandlerFunc handler, String acceptType: "*/*"}) {
    this.add(
        new Route(this.path + path, handler, method: HttpMethod.afterAfter, acceptType: acceptType));
  }

  void get({String path, HandlerFunc handler, String acceptType: "*/*"}) {
    this.add(
        new Route(this.path + path, handler, method: HttpMethod.get, acceptType: acceptType));
  }

  void post({String path, HandlerFunc handler, String acceptType: "*/*"}) {
    this.add(
        new Route(this.path + path, handler, method: HttpMethod.post, acceptType: acceptType));
  }

  void put({String path, HandlerFunc handler, String acceptType: "*/*"}) {
    this.add(
        new Route(this.path + path, handler, method: HttpMethod.put, acceptType: acceptType));
  }

  void delete({String path, HandlerFunc handler, String acceptType: "*/*"}) {
    this.add(
        new Route(this.path + path, handler, method: HttpMethod.delete, acceptType: acceptType));
  }

  void options({String path, HandlerFunc handler, String acceptType: "*/*"}) {
    this.add(
        new Route(this.path + path, handler, method: HttpMethod.options, acceptType: acceptType));
  }

  void patch({String path, HandlerFunc handler, String acceptType: "*/*"}) {
    this.add(
        new Route(this.path + path, handler, method: HttpMethod.patch, acceptType: acceptType));
  }
}
