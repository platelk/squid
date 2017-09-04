part of frost;

class Routes {
  List<RouteEntry> routes;
  String path;

  Routes({this.path}) {
    this.path ??= "";

    this.routes = <RouteEntry>[];
  }

  void add(RouteEntry routeEntry) => routes.add(routeEntry);

  bool match(HttpMethod httpMethod, String acceptType, String path) {
    return this.find(httpMethod, acceptType, path) != null;
  }

  RouteEntry find(HttpMethod httpMethod, String acceptType, String path) {
    return null;
  }

  List<RouteEntry> findMultiple(HttpMethod httpMethod, String acceptType, String path) {
    return null;
  }

  void execute(Request req, Response res) {

  }

  void executeMultiple(Request req, Response res) {

  }
}