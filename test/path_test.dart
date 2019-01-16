import 'package:squid/squid.dart';
import "package:test/test.dart";

import "./http_mock.dart";

void main() {
  group("Path match", () {
    test("with simple match", () {
      var p = new Path("/test");
      expect(p.match("/test"), isTrue);
    });
    test("with simple wrong match", () {
      var p = new Path("/test");
      expect(p.match("/user"), isFalse);
    });
    test("with simple params", () {
      var p = new Path("/test/:id");
      expect(p.match("/test/9"), isTrue);
    });
    test("with multiple params", () {
      var p = new Path("/user/:id/info/:date");
      expect(p.match("/user/9/info/now"), isTrue);
    });
    test("with wrong match and multiple params", () {
      var p = new Path("/user/:id/info/:date");
      expect(p.match("/user/9/test/info/now"), isFalse);
    });
  });
  group("Path extract params", () {
    test("with no params", () {
      var p = new Path("/test");
      expect(p.extractParams("/test"), isMap);
      expect(p.extractParams("/test"), equals(<String, String>{}));
    });
    test("with simple params", () {
      var p = new Path("/user/:id");
      expect(p.extractParams("/user/9"), isMap);
      expect(p.extractParams("/user/9"), equals(<String, String>{"id": "9"}));
    });
    test("with multiple params", () {
      var p = new Path("/user/:id/:date");
      expect(p.extractParams("/user/9/now"), isMap);
      expect(p.extractParams("/user/9/now"), equals(<String, String>{"id": "9", "date": "now"}));
    });
  });
}
