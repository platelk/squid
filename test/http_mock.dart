library http_mock;

import 'dart:io';

import 'package:mockito/mockito.dart';

class MockHttpRequest extends Mock implements HttpRequest {
	MockHttpRequest() {
		when(this.contentLength).thenReturn(10);
		when(this.method).thenReturn("GET");
		when(this.requestedUri).thenReturn(Uri.parse("http://test.squid.io/"));
		when(this.protocolVersion).thenReturn("1.1");
	}
}
