part of frost;


class FrostServer {
  Routes _routeGroup;

  FrostServer() {
    this._routeGroup = new Routes();
  }

  void before(String path, Handler handler) {

  }

  void after(String path, Handler handler) {

  }

  void afterAfter(String path, Handler handler) {

  }

  void get(String path, Handler handler) {

  }

  void post(String path, Handler handler) {

  }

  void put(String path, Handler handler) {

  }

  void delete(String path, Handler handler) {

  }

  void options(String path, Handler handler) {

  }

  void path(String path, GroupHandler groupHandler) {

  }

  void route(HttpMethod method, String path, Handler handler) {

  }
}