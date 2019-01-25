part of squid;

var DefaultServer = new Server();

Future<Server> start(String host, int port) {
  return DefaultServer.start(host, port);
}

void before(HandlerFunc handler) {
  DefaultServer.before(handler);
}

void after(HandlerFunc handler) {
  DefaultServer.after(handler);
}

void use(Handler handler) {
  DefaultServer.use(handler);
}

void get(String path, HandlerFunc handler, {List<ContentType> acceptType: }) {
  DefaultServer.get(path, handler, acceptType: acceptType);
}

void post(String path, HandlerFunc handler, {String acceptType: allAcceptType}) {
  DefaultServer.post(path, handler, acceptType: acceptType);
}

void put(String path, HandlerFunc handler, {String acceptType: allAcceptType}) {
  DefaultServer.put(path, handler, acceptType: acceptType);
}

void delete(String path, HandlerFunc handler, {String acceptType: allAcceptType}) {
  DefaultServer.delete(path, handler, acceptType: acceptType);
}

void options(String path, HandlerFunc handler, {String acceptType: allAcceptType}) {
  DefaultServer.options(path, handler, acceptType: acceptType);
}

void patch(String path, HandlerFunc handler, {String acceptType: allAcceptType}) {
  DefaultServer.patch(path, handler, acceptType: acceptType);
}

void path(String path, Function group) {
  String previousPath = DefaultServer.path;
  DefaultServer.path = previousPath + path;
  group();
  DefaultServer.path = previousPath;
}
