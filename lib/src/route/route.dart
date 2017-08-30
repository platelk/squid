part of frost;

class Route {
  HttpMethod method;
  RoutePath path;
  Handler handler;

  Route(HttpMethod this.method, RoutePath this.path, Handler this.handler);
}