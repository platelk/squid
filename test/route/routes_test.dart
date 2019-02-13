import 'package:squid/squid.dart';
import "package:test/test.dart";

void main() {
  group("Routes creation", () {
    test("with default params", () {
      var routes = new Routes("/v1");
    });
    test("with error in path", () {
      try {
        new Route("/v1/", (req, res) => "");
      } on FormatException catch (e) {
        expect(e.message, startsWith("path in route must not end with"));
      }
    });
  });

  group("Routes match", () {
    test("with a successfull basic case", () {
      var routes = new Routes("/v1");
      routes.post("/user", (req, res) => "");
      expect(routes.match(HttpMethod.post, "/v1/user", null), isTrue);
    });
    test("with a error basic case", () {
      var routes = new Routes("/v1");
      routes.post("/user", (req, res) => "");
      expect(routes.match(HttpMethod.get, "/v1/user", null), isFalse);
    });
    test("with a successfull param in url", () {
      var routes = new Routes("/v1");
      routes.post("/:id/user", (req, res) => "");
      expect(routes.match(HttpMethod.post, "/v1/9/user", null), isTrue);
    });
    test("with a successfull param in route path and routes path", () {
      var routes = new Routes("/v1/:id");
      routes.post("/user/:name", (req, res) => "");
      expect(routes.match(HttpMethod.post, "/v1/9/user/test", null), isTrue);
    });
  });

  group("Multiples routes match", () {
    test("with 2 routes", () {
      var v1 = new Routes("/v1");
      var users = v1.group("/user");
      users.get("/:id", (req, res) => "");
      expect(v1.match(HttpMethod.get, "/v1/user/9", null), isTrue);
    });
  });
}
