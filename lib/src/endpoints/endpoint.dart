import 'dart:async';

import 'package:shelf/shelf.dart';

// ignore: one_member_abstracts
abstract class Endpoint {
  FutureOr<Response> handler(Request request);
}
