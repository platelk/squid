import "package:test/test.dart";

import 'package:sting/sting.dart' as sting;

void main() {
  test("Create simple route hierachy", () {
    sting.get("/plop", (req, res) => "hello");
    sting.start();
  });
}