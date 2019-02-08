part of squid;

void notFoundHandlerFunc(Request req, Response res) {
	res.status = HttpStatus.notFound;
}
