import 'dart:async';

import 'package:shelf/shelf.dart';

abstract class Endpoint {
  FutureOr<Response> handler(Request request);
}
