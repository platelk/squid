import 'dart:io';

import 'package:squid/squid.dart';
import "package:test/test.dart";

void main() {
  group("Route creation", () {
    test("with default params", () {
      var r = new Route("/", (req, res) => "");
      expect(r.acceptType, equals(allContentType));
      expect(r.method, equals(HttpMethod.get));
      expect(r.contextPath.contextPath, equals("/"));
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
    test("with wrong path", () {
      var r1 = new Route("/test", (req, res) => "");
      expect(r1.match(HttpMethod.get, "/9", null), isFalse);
    });
    test("with wrong method", () {
      var r1 = new Route("/test", (req, res) => "");
      expect(r1.match(HttpMethod.post, "/9", null), isFalse);
    });
    test("with params", () {
      var r1 = new Route("/:id", (req, res) => "");
      expect(r1.match(HttpMethod.get, "/9", null), isTrue);
    });
    test("with params and path", () {
      var r1 = new Route("/test/:id/list", (req, res) => "");
      expect(r1.match(HttpMethod.get, "/test/9/list", null), isTrue);
    });
    test("with params and path", () {
      var r1 = new Route("/test/:id/list/:end_id", (req, res) => "");
      expect(r1.match(HttpMethod.get, "/test/9/list/10", null), isTrue);
    });
    test("with any content-type", () {
      var r1 = new Route("/test", (req, res) => "");
      expect(r1.match(HttpMethod.get, "/test", ContentType.json), isTrue);
    });
    test("with wrong content type and specific accept type", () {
      var r1 = new Route("/test", (req, res) => "", acceptType: ContentType.json);
      expect(r1.match(HttpMethod.get, "/test", ContentType.text), isFalse);
    });
    test("with right primary content type and specific accept type", () {
      var r1 = new Route("/test", (req, res) => "", acceptType: ContentType.parse("application/*"));
      expect(r1.match(HttpMethod.get, "/test", ContentType.json), isTrue);
    });
    test("with path trap", () {
      var r1 = new Route("/*", (req, res) => "");
      expect(r1.match(HttpMethod.get, "/test", null), isTrue);
    });
    test("with path trap at the end", () {
      var r1 = new Route("/user/*", (req, res) => "");
      expect(r1.match(HttpMethod.get, "/user/me/test", null), isTrue);
    });
    test("with path trap at the end and params", () {
      var r1 = new Route("/user/:id/*", (req, res) => "");
      expect(r1.match(HttpMethod.get, "/user/9/test", null), isTrue);
    });
  });
}
