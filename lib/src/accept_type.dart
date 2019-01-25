part of squid;

class AcceptType {
  AcceptType.parse(String this.value) {
    var acceptedTypes = value.split(",");
    for (var acceptedType in acceptedTypes) {
      var res = acceptedType.split(";");
      this._acceptTypes[ContentType.parse(res.first)] = double.tryParse(res.last) ?? 1.0;
    }
  }
  
  final Map<ContentType, double> _acceptTypes = const {};
  final String value;

  bool match(ContentType contentType) {
    if (contentType == null) {
      return true;
    }
    for (var key in this._acceptTypes.keys) {
      if (key.primaryType == "*" || key.primaryType == contentType.primaryType) {
        return true;
      }
      if (key.subType == "*" || key.subType == contentType.subType) {
        return true;
      }
    }
    return false;
  }
}
