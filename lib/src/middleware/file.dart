part of squid;

HandlerFunc filePathHandler(String path, {String mType}) {
  return fileHandler(new File(path), mType: mType);
}

HandlerFunc fileHandler(File file, {String mType}) {
  return (Request req, Response res) async {
    if (!file.existsSync()) {
      res.status = 404;
      return;
    }
    var inputStream = file.openRead();
    var mimeType = mType ?? lookupMimeType(file.path) ?? "text/plain";
    res.type = ContentType.parse(mimeType);
    print('${res.type} ${file.path}');
    await res.addStream(inputStream).whenComplete(() {
      print('stream added for ${file.path}');
    });
    print('close ${file.path}');
    return;
  };
}
