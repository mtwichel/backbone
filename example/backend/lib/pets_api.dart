library pets_api;

import 'package:backbone/backbone.dart';
import 'package:shelf/shelf.dart';
import 'package:pets_api_functions_objects/pets_api_functions_objects.dart';

Future<String> verifyToken(String token) async {
  // TODO: implement verifyToken
  return 'fake-user-id';
}

final middlewares = <Middleware>[];
