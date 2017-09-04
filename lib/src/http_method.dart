part of frost;

class HttpMethod {
  static const HttpMethod get = const HttpMethod._("GET");
  static const HttpMethod post = const HttpMethod._("POST");
  static const HttpMethod put = const HttpMethod._("PUT");
  static const HttpMethod delete = const HttpMethod._("DELETE");
  static const HttpMethod options = const HttpMethod._("OPTIONS");

  static const HttpMethod before = const HttpMethod._("BEFORE");
  static const HttpMethod after = const HttpMethod._("AFTER");
  static const HttpMethod afterAfter = const HttpMethod._("AFTERAFTER");

  final String value;
  
  const HttpMethod._(this.value);
}