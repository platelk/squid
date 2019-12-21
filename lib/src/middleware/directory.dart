part of squid;

HandlerFunc directoryHandler(String basePath) {
	return (Request req, Response res) async {
		await filePathHandler(p.join(basePath, req.param("path")))(req, res);
	};
}
