import 'package:squid/squid.dart';
import "package:test/test.dart";

import 'package:mockito/mockito.dart';

import "./http_mock.dart";

void main() {
  group("Parsing request header", () {
    test("Check correct length", () {
      var m = MockHttpRequest();
      when(m.contentLength).thenReturn(10);
      var req = Request(m);
      expect(req.contentLength, equals(10));
    });
  });
}
