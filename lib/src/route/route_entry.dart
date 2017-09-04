part of frost;

typedef Handler = void Function(Request req, Response res);
typedef GroupHandler = void Function(Routes group);

class RouteEntry {
  HttpMethod method;
  String path;
  Handler handler;

  RouteEntry(HttpMethod this.method, String this.path, Handler this.handler);

  void execute(Request req, Response res) {
    if (this.handler != null) {
      this.handler(req, res);
    }
  }

  bool match(HttpMethod httpMethod, String path) {
    return false;
  }
}