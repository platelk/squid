part of frost;

class AcceptType {
  Map<ContentType, double> _acceptTypes = {};

  AcceptType();

  AcceptType.parse(String acceptType) {
    var acceptedTypes = acceptType.split(",");
    for (var acceptedType in acceptedTypes) {
      var res = acceptedType.split(";");
      this._acceptTypes[ContentType.parse(res.first)] =
          double.parse(res.last, (_) => 1.0);
    }
  }

  bool match(ContentType contentType) {
    if (contentType == null) {
      return true;
    }
    for (var key in this._acceptTypes.keys) {
      if (key.primaryType == "*" ||
          key.primaryType == contentType.primaryType) {
        return true;
      }
      if (key.subType == "*" || key.subType == contentType.subType) {
        return true;
      }
    }
    return false;
  }
}
