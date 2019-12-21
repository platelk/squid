part of squid;


typedef HandlerFunc = FutureOr Function(Request req, Response res);

typedef HandlerFunc Handler(HandlerFunc h);

typedef ErrorHandlerFunc = void Function(Error e, Request req, Response res);


typedef ExceptionHandlerFunc = void Function(Exception e, Request req, Response res);


void notFoundHandlerFunc(Request req, Response res) {
	res.status = HttpStatus.notFound;
}

void errorHandlerFunc(Error e, Request req, Response res) {
	res.status = HttpStatus.internalServerError;
}


void exceptionHandlerFunc(Exception e, Request req, Response res) {
	res.status = HttpStatus.internalServerError;
}
