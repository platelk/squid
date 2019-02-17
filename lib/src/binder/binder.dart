library binder;

import 'dart:convert';

typedef T Binder<T>(String data, T receiver);

T jsonBinder<T>(String data, T receiver) {
	return json.decode(data) as T;
}

String stringBinder<T>(String data, T receiver) {
	return data;
}

T formBinder<T>(String data, T receiver) {
	return Uri.parse(data).queryParameters as T;
}
