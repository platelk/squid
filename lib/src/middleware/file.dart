part of squid;

HandlerFunc filePathHandler(String path) {
  return fileHandler(new File(path));
}

HandlerFunc fileHandler(File file) {
  return (Request req, Response res) async {
    var inputStream = file.openRead();
    if (!file.existsSync()) {
      res.status = 404;
      return;
    }
    var mimeType = lookupMimeType(file.path) ?? "text/plain";
    res.type = ContentType.parse(mimeType);
    await for (var line in inputStream) {
      res.add(line);
    }
  };
}
