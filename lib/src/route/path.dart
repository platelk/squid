part of frost;

const String pathParamsSep = ':';
const String uriPathSep = '/';
const String jokerPath = '*';

class Path {
  String contextPath;
  Path(String this.contextPath);

  bool match(String path) {
    var j = 0;
    for (var i = 0; i < this.contextPath.length; i++, j++) {
      if (this.contextPath[i] == pathParamsSep) {
        for (i += 1; i < this.contextPath.length && this.contextPath[i] != uriPathSep; i++);
        for (; j < path.length && path[j] != uriPathSep; j++);
      }
      if (i < this.contextPath.length && this.contextPath[i] == jokerPath) {
        return true;
      }
      if (j >= path.length && i >= this.contextPath.length) {
        return true;
      }
      if (j >= path.length || this.contextPath[i] != path[j]) {
        return false;
      }
    }
    return true;
  }

  Map<String, String> extractParams(String path) {
    var params = <String, String>{};
    if (this.contextPath == null) {
      return params;
    }
    var j = 0;
    for (var i = 0; i < this.contextPath.length; i++, j++) {
      if (this.contextPath[i] == pathParamsSep) {
        var n = "";
        for (i += 1; i < this.contextPath.length && this.contextPath[i] != uriPathSep; i++) {
          n += this.contextPath[i];
        }
        var val = "";
        for (; j < path.length && path[j] != uriPathSep; j++) {
          val += path[j];
        }
        params[n] = val;
      }
    }
    return params;
  }

  @override
  bool operator==(Object o) {
    if (o is Path) {
      return o.contextPath == this.contextPath;
    }
    return false;
  }
}