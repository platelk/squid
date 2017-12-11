part of frost;

var DefaultServer = new FrostServer();

void start() {
  DefaultServer.start();
}

void before({String path, HandlerFunc handler, String acceptType: "*/*"}) {
  DefaultServer.before(path: path, handler: handler, acceptType: acceptType);
}

void after({String path, HandlerFunc handler, String acceptType: "*/*"}) {
  DefaultServer.after(path: path, handler: handler, acceptType: acceptType);
}

void afterAfter({String path, HandlerFunc handler, String acceptType: "*/*"}) {
  DefaultServer.afterAfter(
      path: path, handler: handler, acceptType: acceptType);
}

void get({String path, HandlerFunc handler, String acceptType: "*/*"}) {
  DefaultServer.get(path: path, handler: handler, acceptType: acceptType);
}

void post({String path, HandlerFunc handler, String acceptType: "*/*"}) {
  DefaultServer.post(path: path, handler: handler, acceptType: acceptType);
}

void put({String path, HandlerFunc handler, String acceptType: "*/*"}) {
  DefaultServer.put(path: path, handler: handler, acceptType: acceptType);
}

void delete({String path, HandlerFunc handler, String acceptType: "*/*"}) {
  DefaultServer.delete(path: path, handler: handler, acceptType: acceptType);
}

void options({String path, HandlerFunc handler, String acceptType: "*/*"}) {
  DefaultServer.options(path: path, handler: handler, acceptType: acceptType);
}

void path(String path, GroupHandler groupHandler) {
  DefaultServer.path(path, groupHandler);
}
