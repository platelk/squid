part of squid;

const int defaultPort = 8080;
const String defaultHost = "0.0.0.0";

class Server extends Routes {
  Server() : super("");

  HttpServer _server;

  Future<Server> start(String host, int port) async {
    this._server = await HttpServer.bind(host, port, shared: true);
    this._loop();
    return this;
  }

  Future<Server> startSecure(String host, int port, SecurityContext context) async {
    this._server = await HttpServer.bindSecure(host, port, context, shared: true);
    this._loop();
    return this;
  }

  Future _loop() async {
    await for (HttpRequest req in this._server) {
      this.serve(new Request(req), new Response(req.response));
      req.response.close();
    }
  }
}
