part of frost;

class QueryParamsMap {
  final RegExp keyPattern = new RegExp("\\A[\\[\\]]*([^\\[\\]]+)\\]*");

  Map<String, QueryParamsMap> _queryMap = {};
  List<String> _values = [];

  QueryParamsMap();

  QueryParamsMap.fromParamsList(Map<String, List<String>> params) {
    this._loadQueryString(params);
  }

  void _loadQueryString(Map<String, List<String>> params) {
    params.forEach((k, v) => this.loadKeys(k, v));
  }

  void loadKeys(String key, List<String> values) {
    var parsed = parseKey(key);
    if (parsed == null) {
      return;
    }

    if (!this._queryMap.containsKey(parsed.first)) {
      this._queryMap[parsed.first] = new QueryParamsMap();
    }
    if (parsed[1].isNotEmpty) {
      this._queryMap[parsed.first].loadKeys(parsed[1], values);
    } else {
      this._queryMap[parsed.first]._values = values;
    }
  }

  List<String> parseKey(String key) {
    var match = keyPattern.firstMatch(key);

    if (match != null) {
      return [cleanKey(match.group(0)), key.substring(match.end)];
    }
    return null;
  }

  String cleanKey(String group) {
    if (group.startsWith("[")) {
      return group.substring(1, group.length - 1);
    }
    return group;
  }

  QueryParamsMap get(String key) {
    if (this._queryMap.containsKey(key)) {
      return this._queryMap[key];
    }
    return null;
  }

  String get value => this._values?.first;

  List<String> get values => this._values;

  bool get hasKeys => this._queryMap.isNotEmpty;

  bool hasKey(String key) => this._queryMap.containsKey(key);

  bool get hasValue => this._values?.isNotEmpty ?? false;

  QueryParamsMap operator [](String key) => this.get(key);
}
