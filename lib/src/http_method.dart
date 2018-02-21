part of sting;

class HttpMethod {
  static const HttpMethod get = const HttpMethod.parse("GET");
  static const HttpMethod post = const HttpMethod.parse("POST");
  static const HttpMethod put = const HttpMethod.parse("PUT");
  static const HttpMethod patch = const HttpMethod.parse("PATCH");
  static const HttpMethod delete = const HttpMethod.parse("DELETE");
  static const HttpMethod options = const HttpMethod.parse("OPTIONS");

  final String value;

  const HttpMethod.parse(this.value);

  @override
  bool operator ==(Object object) {
    if (object is HttpMethod) {
      return object.value == this.value;
    }
    return false;
  }
}
