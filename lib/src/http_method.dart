part of frost;

class HttpMethod {
  static const HttpMethod GET = const HttpMethod._("GET");
  static const HttpMethod POST = const HttpMethod._("POST");
  static const HttpMethod PUT = const HttpMethod._("PUT");
  static const HttpMethod DELETE = const HttpMethod._("DELETE");
  static const HttpMethod OPTIONS = const HttpMethod._("OPTIONS");
  
  final String value;
  
  const HttpMethod._(this.value);
}