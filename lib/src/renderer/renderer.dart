library renderer;

import 'dart:convert';

typedef String Renderer(dynamic data);

String jsonRenderer(dynamic data) {
	return json.encode(data);
}

String stringRenderer(dynamic data) {
	return data.toString();
}

String formRenderer(dynamic data) {
	return Uri.encodeQueryComponent(data.toString());
}
