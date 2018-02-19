import "package:test/test.dart";

import 'package:frost/frost.dart' as frost;

void main() {
  test("Create simple route hierachy", () {
    frost.get("/plop", (req, res) => "hello");
    frost.start();
  });
}