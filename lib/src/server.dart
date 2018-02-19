part of frost;

const int defaultPort = 8080;
const String defaultHost = "0.0.0.0";

class Server extends Routes {
  int port;
  String host;
  HttpServer _server;
  Server({String this.host : defaultHost, int this.port: defaultPort}) : super("");

  Future<Server> start() async {
    this._server = await HttpServer.bind(this.host, this.port);
    this._loop();
    return this;
  }

  Future _loop() async {
    await for (HttpRequest req in this._server) {
      this.serve(new Request(req), new Response(req.response));
    }
  }
}
