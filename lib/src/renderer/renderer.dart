library renderer;

import 'dart:convert';
import 'dart:io';

typedef String Renderer(dynamic data);

String jsonRenderer(dynamic data) {
	return json.encode(data);
}

String stringRenderer(dynamic data) {
	return data.toString();
}

String htmlRenderer(dynamic data) {
	return data.toString();
}

String formRenderer(dynamic data) {
	return Uri.encodeQueryComponent(data.toString());
}

String fileRenderer(dynamic data) {
	var filePath = data as String;
	return new File(filePath).readAsStringSync();
}
