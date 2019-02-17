import 'dart:io';

import 'package:squid/squid.dart';

class User {
  User(this.name, this.age);
  
  String name;
  int age;
  
  @override
  String toString() => "[name:${this.name};age:${this.age}]";
}

var users = <String, dynamic>{
  "1": User("john", 42),
  "2": User("joe", 36)
};

void main() {
  use((HandlerFunc h) {
    return (req, res) {
      print(
          "[${new DateTime.now().toIso8601String()}] -> ${req.method.toString()} (${req.contextPath}) ${req.path} ${req.headers}");
      h(req, res);
      print("[${new DateTime.now().toIso8601String()}] <- ${res.status} ${res.headers}");
    };
  });

  path("/v1", () {
    path("/user", () {
      get("", (req, res) => res.json(users));
      post("", addUser);
      path("/:id", () {
        get("", (req, res) => res.json(users[req.param("id")]));
        get("/name", (req, res) => res.json(users[req.param("id")]["name"]));
      });
    });
    path("/product", () {
      get("/list", (req, res) => print("* /v1/product/list"));
    });
  });

  print("Starting server on 8080.");
  start("0.0.0.0", 8080).then((s) => print(s.routes));
}

void addUser(Request req, Response res) {
  print(req.contentType);
  print(req.contentType == ContentType.json);
  var user = req.bind<User>();
  print(user);
  res.json(users);
}
