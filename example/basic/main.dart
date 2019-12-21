import 'dart:io';
import 'package:squid/squid.dart';

void main() {
  use((HandlerFunc h) {
    return (req, res) async {
      print("1- before use");
      await h(req, res);
      print("1- after use");
    };
  });
  use((HandlerFunc h) {
    return (req, res) async {
      print("2- before use");
      await h(req, res);
      print("2- after use");
    };
  });
  post("/info", (req, res) => print("* /info"));
  post("/info", (req, res) => print("* /info in json"), acceptType: ContentType.json);
  post("/info", (req, res) => print("* /info in text"), acceptType: ContentType.text);

  path("/v1", () {
    get("/user", (req, res) => print("* /v1/user"));
    path("/product", () {
      get("/list", (req, res) => print("* /v1/product/list"));
    });
  });
  
  get("/:path", directoryHandler("."));

  print("Starting server on 8080.");
  start("0.0.0.0", 8080).then((s) => print(s.routes));
}
