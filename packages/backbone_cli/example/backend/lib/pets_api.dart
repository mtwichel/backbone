library pets_api;

import 'package:backbone/backbone.dart';
import 'package:shelf/shelf.dart';
import 'package:pets_api_functions_objects/pets_api_functions_objects.dart';

Future<String> verifyToken(String token, RequestContext context) async {
  // TODO: implement verifyToken
  throw UnimplementedError('API is not set up for verifing auth tokens yet.');
}

final middlewares = <Middleware>[];
