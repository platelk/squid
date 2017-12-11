part of frost;

typedef HandlerFunc = void Function(Request req, Response res);
typedef GroupHandler = void Function(Routes group);

class RouteEntry {
  HttpMethod method;
  String path;
  String acceptType;
  HandlerFunc handler;

  RouteEntry(HttpMethod this.method, String this.path, String acceptType,
      HandlerFunc this.handler);

  void execute(Request req, Response res) {
    if (this.handler != null) {
      this.handler(req, res);
    }
  }

  bool match(HttpMethod httpMethod, String path, String acceptType) {
    if (this.method != httpMethod) {
      return false;
    }

    return false;
  }

  @override
  bool operator ==(Object o) {
    if (o is RouteEntry) {
      return this.match(o.method, o.path, o.acceptType);
    }
    return false;
  }
}
