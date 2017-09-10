part of frost;

class FrostServer {
  Routes _routeGroup;

  FrostServer() {
    this._routeGroup = new Routes();
  }

  void start() {

  }

  void before({String path, Handler handler, String acceptType: "*/*"}) {
    this._routeGroup.add(new RouteEntry(HttpMethod.before, path, acceptType, handler));
  }

  void after({String path, Handler handler, String acceptType: "*/*"}) {
    this._routeGroup.add(new RouteEntry(HttpMethod.after, path, acceptType, handler));
  }

  void afterAfter({String path, Handler handler, String acceptType: "*/*"}) {
    this._routeGroup.add(new RouteEntry(HttpMethod.afterAfter, path, acceptType, handler));
  }

  void get({String path, Handler handler, String acceptType: "*/*"}) {
    this._routeGroup.add(new RouteEntry(HttpMethod.get, path, acceptType, handler));
  }

  void post({String path, Handler handler, String acceptType: "*/*"}) {
    this._routeGroup.add(new RouteEntry(HttpMethod.post, path, acceptType, handler));
  }

  void put({String path, Handler handler, String acceptType: "*/*"}) {
    this._routeGroup.add(new RouteEntry(HttpMethod.put, path, acceptType, handler));
  }

  void delete({String path, Handler handler, String acceptType: "*/*"}) {
    this._routeGroup.add(new RouteEntry(HttpMethod.delete, path, acceptType, handler));
  }

  void options({String path, Handler handler, String acceptType: "*/*"}) {
    this._routeGroup.add(new RouteEntry(HttpMethod.options, path, acceptType, handler));
  }

  void path(String path, GroupHandler groupHandler) {

  }
}