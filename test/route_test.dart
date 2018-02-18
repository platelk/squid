import 'package:frost/frost.dart';
import "package:test/test.dart";

void main() {
  group("Route creation", () {
    test("with default params", () {
      var r = new Route("/", (req, res) => "");
      expect(r.acceptType, equals("*/*"));
      expect(r.method, equals(HttpMethod.get));
      expect(r.path, equals("/"));
    });
  });
  group("Route equality", () {
    test("with different object but same value", () {
      var r1 = new Route("/", (req, res) => "");
      var r2 = new Route("/", (req, res) => "");
      expect(r1 == r2, isTrue);
    });
    test("with different path", () {
      var r1 = new Route("/test", (req, res) => "");
      var r2 = new Route("/", (req, res) => "");
      expect(r1 == r2, isFalse);
    });
  });
  group("Route match", () {
    test("with basic value", () {
      var r1 = new Route("/", (req, res) => "");
      expect(r1.match(HttpMethod.get, "/", null), isTrue);
    });
    test("with params", () {
      var r1 = new Route("/:id", (req, res) => "");
      expect(r1.match(HttpMethod.get, "/9", null), isTrue);
    });
  });
}
