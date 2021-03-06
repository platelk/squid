part of squid;

const String pathParamsSep = ':';
const String uriPathSep = '/';
const String jokerPath = '*';

class Path implements Comparable<Path> {
  Path(String this.contextPath);
  String contextPath;

  bool match(String path) {
    var j = 0;
    for (var i = 0; i < this.contextPath.length; i++, j++) {
      if (this.contextPath[i] == pathParamsSep) {
        for (i += 1; i < this.contextPath.length && this.contextPath[i] != uriPathSep && this.contextPath[i] != jokerPath; i++);
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
        for (i += 1; i < this.contextPath.length && this.contextPath[i] != uriPathSep && this.contextPath[i] != jokerPath; i++) {
          n += this.contextPath[i];
        }
        var val = "";
        for (; j < path.length && (path[j] != uriPathSep || this.contextPath[i] == jokerPath); j++) {
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
  
  @override
  String toString() => this.contextPath;

  @override
  int compareTo(Path other) {
    return this.contextPath.compareTo(other.contextPath);
  }
}
