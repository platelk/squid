library http_mock;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

class MockHttpHeaders implements HttpHeaders {
  final Map<String, List<String>> _headers =
      new HashMap<String, List<String>>();

  @override
  List<String> operator [](key) => _headers[key];

  @override
  int get contentLength => int.parse(_headers[HttpHeaders.CONTENT_LENGTH][0]);

  @override
  DateTime get ifModifiedSince {
    List<String> values = _headers[HttpHeaders.IF_MODIFIED_SINCE];
    if (values != null) {
      try {
        return HttpDate.parse(values[0]);
      } on Exception {
        return null;
      }
    }
    return null;
  }

  @override
  void set ifModifiedSince(DateTime ifModifiedSince) {
    // Format "ifModifiedSince" header with date in Greenwich Mean Time (GMT).
    String formatted = HttpDate.format(ifModifiedSince.toUtc());
    _set(HttpHeaders.IF_MODIFIED_SINCE, formatted);
  }

  @override
  ContentType get contentType {
    var values = _headers[HttpHeaders.CONTENT_TYPE];
    if (values != null) {
      return ContentType.parse(values.first);
    }
    return null;
  }

  @override
  void set(String name, Object value) {
    name = name.toLowerCase();
    _headers.remove(name);
    _addAll(name, value);
  }

  @override
  String value(String name) {
    name = name.toLowerCase();
    List<String> values = _headers[name];
    if (values == null) return null;
    if (values.length > 1) {
      throw new HttpException("More than one value for header $name");
    }
    return values[0];
  }

  @override
  String toString() => '$runtimeType : $_headers';

  // [name] must be a lower-case version of the name.
  void _add(String name, dynamic value) {
    if (name == HttpHeaders.IF_MODIFIED_SINCE) {
      if (value is DateTime) {
        ifModifiedSince = value;
      } else if (value is String) {
        _set(HttpHeaders.IF_MODIFIED_SINCE, value);
      } else {
        throw new HttpException("Unexpected type for header named $name");
      }
    } else {
      _addValue(name, value);
    }
  }

  void _addAll(String name, dynamic value) {
    if (value is List) {
      for (int i = 0; i < value.length; i++) {
        _add(name, value[i]);
      }
    } else {
      _add(name, value);
    }
  }

  void _addValue(String name, Object value) {
    List<String> values = _headers[name];
    if (values == null) {
      values = new List<String>();
      _headers[name] = values;
    }
    if (value is DateTime) {
      values.add(HttpDate.format(value));
    } else {
      values.add(value.toString());
    }
  }

  void _set(String name, String value) {
    assert(name == name.toLowerCase());
    List<String> values = new List<String>();
    _headers[name] = values;
    values.add(value);
  }

  @override
  void forEach(void f(String name, List<String> values)) {
    this._headers.forEach(f);
  }

  /*
   * Implemented to remove editor warnings
   */
  @override
  dynamic noSuchMethod(Invocation invocation) {
    print([
      invocation.memberName,
      invocation.isGetter,
      invocation.isSetter,
      invocation.isMethod,
      invocation.isAccessor
    ]);
    return super.noSuchMethod(invocation);
  }
}

class MockHttpRequest implements HttpRequest {
  @override
  final Uri uri;
  @override
  final MockHttpResponse response = new MockHttpResponse();
  @override
  final HttpHeaders headers = new MockHttpHeaders();
  @override
  String method = 'GET';
  final bool followRedirects;
  List<int> body = [];

  @override
  int contentLength;

  MockHttpRequest(this.uri,
      {this.followRedirects: true, DateTime ifModifiedSince, this.body: const[], this.method: 'GET'}) {
    if (ifModifiedSince != null) {
      headers.ifModifiedSince = ifModifiedSince;
    }
    contentLength = body.length;
  }

  @override
  String get protocolVersion => "1.1";

  @override
  Stream<S> transform<S>(StreamTransformer<List<int>, S> streamTransformer) {
    return streamTransformer.bind(new Stream.fromIterable([body]));
  }

  @override
  StreamSubscription<List<int>> listen(void onData(List<int> onData),
      {Function onError, void onDone(), bool cancelOnError}) {
    var ss = new Stream<List<int>>.fromIterable([body]);
    return ss.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  /*
   * Implemented to remove editor warnings
   */
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockHttpResponse implements HttpResponse {
  @override
  final HttpHeaders headers = new MockHttpHeaders();
  final Completer _completer = new Completer<Null>();
  final List<int> _buffer = new List<int>();
  String _reasonPhrase;
  Future _doneFuture;

  MockHttpResponse() {
    _doneFuture = _completer.future.whenComplete(() {
      assert(!_isDone);
      _isDone = true;
    });
  }

  bool _isDone = false;

  @override
  int statusCode = HttpStatus.OK;

  @override
  String get reasonPhrase => _findReasonPhrase(statusCode);

  @override
  void set reasonPhrase(String value) {
    _reasonPhrase = value;
  }

  @override
  Future get done => _doneFuture;

  @override
  Future close() {
    _completer.complete();
    return _doneFuture;
  }

  @override
  void add(List<int> data) {
    _buffer.addAll(data);
  }

  @override
  void addError(error, [StackTrace stackTrace]) {
    // doesn't seem to be hit...hmm...
  }

  @override
  Future redirect(Uri location, {int status: HttpStatus.MOVED_TEMPORARILY}) {
    this.statusCode = status;
    headers.set(HttpHeaders.LOCATION, location.toString());
    return close();
  }

  @override
  void write(Object obj) {
    var str = obj.toString();
    add(UTF8.encode(str));
  }

  /*
   * Implemented to remove editor warnings
   */
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  String get mockContent => UTF8.decode(_buffer);

  List<int> get mockContentBinary => _buffer;

  bool get mockDone => _isDone;

  String _findReasonPhrase(int statusCode) {
    if (_reasonPhrase != null) {
      return _reasonPhrase;
    }

    switch (statusCode) {
      case HttpStatus.NOT_FOUND:
        return "Not Found";
      default:
        return "Status $statusCode";
    }
  }
}
