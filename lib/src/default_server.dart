part of frost;

var DefaultServer = new Server();

void start() {
  DefaultServer.start();
}

void before(String path, HandlerFunc handler, {String acceptType: "*/*"}) {
  DefaultServer.before(path, handler, acceptType: acceptType);
}

void after(String path, HandlerFunc handler, {String acceptType: "*/*"}) {
  DefaultServer.after(path, handler, acceptType: acceptType);
}

void afterAfter(String path, HandlerFunc handler, {String acceptType: "*/*"}) {
  DefaultServer.afterAfter(
      path, handler, acceptType: acceptType);
}

void get(String path, HandlerFunc handler, {String acceptType: "*/*"}) {
  DefaultServer.get(path, handler, acceptType: acceptType);
}

void post(String path, HandlerFunc handler, {String acceptType: "*/*"}) {
  DefaultServer.post(path, handler, acceptType: acceptType);
}

void put(String path, HandlerFunc handler, {String acceptType: "*/*"}) {
  DefaultServer.put(path, handler, acceptType: acceptType);
}

void delete(String path, HandlerFunc handler, {String acceptType: "*/*"}) {
  DefaultServer.delete(path, handler, acceptType: acceptType);
}

void options(String path, HandlerFunc handler, {String acceptType: "*/*"}) {
  DefaultServer.options(path, handler, acceptType: acceptType);
}

void patch(String path, HandlerFunc handler, {String acceptType: "*/*"}) {
  DefaultServer.patch(path, handler, acceptType: acceptType);
}
