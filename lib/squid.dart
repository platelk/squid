library squid;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart' as shelf;
import 'package:stream_channel/stream_channel.dart';

import './src/binder/binder.dart';
import './src/renderer/renderer.dart';

part 'package:squid/src/server.dart';

part 'src/accept_type.dart';

part 'src/default_server.dart';

part 'src/http_method.dart';

part 'src/query_params_map.dart';

part 'src/request.dart';

part 'src/response.dart';

part 'src/route/path.dart';

part 'src/route/route.dart';

part 'src/route/routes.dart';

part 'src/handlers/not_found.dart';
