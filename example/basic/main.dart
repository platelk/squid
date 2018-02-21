import 'package:sting/sting.dart';

void main() {
  get("/info", (req, res) => print("* /info"));
  path("/v1", () {
    get("/user", (req, res) => print("* /v1/user"));
    path("/product", () {
      get("/list", (req, res) => print("* /v1/product/list"));
    });
  });

  start("0.0.0.0", 8080);
}