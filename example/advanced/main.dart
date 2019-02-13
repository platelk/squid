import 'package:squid/squid.dart';

void main() {
  var users = <String, dynamic>{
    "1": {"name": "fred", 3: 42},
    "2": {"name": "joe", "age": 36}
  };
  use((HandlerFunc h) {
    return (req, res) {
      print(
          "[${new DateTime.now().toIso8601String()}] -> ${req.method.toString()} (${req.contextPath}) ${req.path} ${req.headers}");
      h(req, res);
      print("[${new DateTime.now().toIso8601String()}] <- ${res.status} ${res.headers}");
    };
  });

  path("/v1", () {
    path("/user", () {
      get("", (req, res) => res.json(users));
      path("/:id", () {
        get("", (req, res) => res.json(users[req.param("id")]));
        get("/name", (req, res) => res.json(users[req.param("id")]["name"]));
      });
    });
    path("/product", () {
      get("/list", (req, res) => print("* /v1/product/list"));
    });
  });

  print("Starting server on 8080.");
  start("0.0.0.0", 8080).then((s) => print(s.routes));
}
