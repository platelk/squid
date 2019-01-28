part of squid;

final allContentType = ContentType.parse("*/*");

class AcceptType {
  AcceptType(List<ContentType> contentTypes) {
    for (var v in contentTypes) {
      this._acceptTypes[v] = 1.0;
    }
  }
  
  AcceptType.parse(String value) {
    var acceptedTypes = value.split(",");
    for (var acceptedType in acceptedTypes) {
      var res = acceptedType.split(";");
      this._acceptTypes[ContentType.parse(res.first)] = double.tryParse(res.last) ?? 1.0;
    }
  }
  
  final Map<ContentType, double> _acceptTypes = {};

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
