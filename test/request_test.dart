import 'package:frost/frost.dart';
import "package:test/test.dart";

import "./http_mock.dart";

import 'dart:io';

void main() {
  group("Basic creation", () {
    test("Create request from HttpRequest.", () {
      var mock = new MockHttpRequest(Uri.parse("http://test.frost.io/"));
      var req = new Request(mock);
      expect(req, isNotNull);
    });
    
  });
  // req.protocol
  group("Parsing protocol", () {
    test("http", () {
      var mock = new MockHttpRequest(Uri.parse("http://test.frost.io/"));
      var req = new Request(mock);
      expect(req.protocol, equals("http"));
    });
    test("https", () {
      var mock = new MockHttpRequest(Uri.parse("https://test.frost.io/"));
      var req = new Request(mock);
      expect(req.protocol, equals("https"));
    });
    test("ws", () {
      var mock = new MockHttpRequest(Uri.parse("ws://test.frost.io/"));
      var req = new Request(mock);
      expect(req.protocol, equals("ws"));
    });
    test("wss", () {
      var mock = new MockHttpRequest(Uri.parse("wss://test.frost.io/"));
      var req = new Request(mock);
      expect(req.protocol, equals("wss"));
    });
  });
  // req.host
  group("Parsing host", () {
    test("in simple case", () {
      var mock = new MockHttpRequest(Uri.parse("http://frost.io/"));
      var req = new Request(mock);
      expect(req.host, equals("frost.io"));
    });
    test("with sub domains", () {
      var mock = new MockHttpRequest(Uri.parse("https://test.frost.io/"));
      var req = new Request(mock);
      expect(req.host, equals("test.frost.io"));
    });
    test("without extension (localhost)", () {
      var mock = new MockHttpRequest(Uri.parse("https://localhost/"));
      var req = new Request(mock);
      expect(req.host, equals("localhost"));
    });
    test("as IP", () {
      var mock = new MockHttpRequest(Uri.parse("https://127.0.0.1/"));
      var req = new Request(mock);
      expect(req.host, equals("127.0.0.1"));
    });
  });
  // req.port
  group("Parsing port", () {
    test("specified in url", () {
      var mock = new MockHttpRequest(Uri.parse("http://frost.io:8080/"));
      var req = new Request(mock);
      expect(req.port, equals(8080));
    });
    test("in https request", () {
      var mock = new MockHttpRequest(Uri.parse("https://test.frost.io/"));
      var req = new Request(mock);
      expect(req.port, equals(443));
    });
    test("in http request", () {
      var mock = new MockHttpRequest(Uri.parse("http://localhost/"));
      var req = new Request(mock);
      expect(req.port, equals(80));
    });
  });
  // req.method
  group("Retrieve method from request", () {
    test("GET method", () {
      var mock = new MockHttpRequest(Uri.parse("http://localhost/"));
      mock.method = HttpMethod.get.value;
      var req = new Request(mock);
      expect(req.method, equals(HttpMethod.get));
    });
    test("POST method", () {
      var mock = new MockHttpRequest(Uri.parse("http://localhost/"));
      mock.method = HttpMethod.post.value;
      var req = new Request(mock);
      expect(req.method, equals(HttpMethod.post));
    });
    test("unknown method", () {
      var mock = new MockHttpRequest(Uri.parse("http://localhost/"));
      mock.method = "unknown";
      var req = new Request(mock);
      expect(req.method, equals(new HttpMethod.parse("unknown")));
    });
  });
  // req.body
  group("Retrieve body from request:", () {
    test("get simple body", () async {
      var mock = new MockHttpRequest(Uri.parse("http://localhost/"), body: "test".runes.toList(), method: HttpMethod.post.value);
      var req = new Request(mock);
      expect(await req.body, equals("test"));
    });
    test("emtpy body", () async {
      var mock = new MockHttpRequest(Uri.parse("http://localhost/"), body: "".runes.toList(), method: HttpMethod.post.value);
      var req = new Request(mock);
      expect(await req.body, equals(""));
    });
  });
  // req.contentLength
  group("Retrieve content length from request:", () {
    test("get from simple body", () async {
      var mock = new MockHttpRequest(Uri.parse("http://localhost/"), body: "test".runes.toList(), method: HttpMethod.post.value);
      var req = new Request(mock);
      expect(req.contentLength, equals(4));
    });
    test("emtpy body", () async {
      var mock = new MockHttpRequest(Uri.parse("http://localhost/"), body: "".runes.toList(), method: HttpMethod.post.value);
      var req = new Request(mock);
      expect(req.contentLength, equals(0));
    });
  });
}
