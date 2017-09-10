import "package:test/test.dart";

import 'package:shelf/shelf.dart' as shelf;

import 'package:frost/frost.dart' as frost;

void main() {
  test("Create request from shelf.Request.", () {
    var r = new shelf.Request(frost.HttpMethod.get.value, new Uri.http("example.org", "/path", { "q" : "dart" }));
    var req = new frost.Request.fromShelf(r);

    expect(req.method, equals(frost.HttpMethod.get));
  });
}