part of squid;

class HttpMethod {
  const HttpMethod.parse(this.value);
  
  static const HttpMethod get = const HttpMethod.parse("GET");
  static const HttpMethod post = const HttpMethod.parse("POST");
  static const HttpMethod put = const HttpMethod.parse("PUT");
  static const HttpMethod patch = const HttpMethod.parse("PATCH");
  static const HttpMethod delete = const HttpMethod.parse("DELETE");
  static const HttpMethod options = const HttpMethod.parse("OPTIONS");

  final String value;

  @override
  bool operator ==(Object object) {
    if (object is HttpMethod) {
      return object.value == this.value;
    }
    return false;
  }
}
