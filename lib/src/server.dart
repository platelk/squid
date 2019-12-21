part of squid;

const int defaultPort = 8080;
const String defaultHost = "0.0.0.0";

class Server extends Routes {
  Server() : super("");

  HttpServer _server;
  
  HandlerFunc notFoundHandler = notFoundHandlerFunc;
  ErrorHandlerFunc internalErrorHandler = errorHandlerFunc;
  ExceptionHandlerFunc internalExceptionHandler = exceptionHandlerFunc;

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
    await for (HttpRequest request in this._server) {
      var req = new Request(request);
      var res = new Response(request.response);
      try {
        var found = await this.serve(req, res);
        if (!found) {
          notFoundHandler(req, res);
        }
      } on Exception catch (e) {
        internalExceptionHandler(e, req, res);
      } on Error catch (e) {
        internalErrorHandler(e, req, res);
      } finally {
        res.close();
      }
    }
  }
}
