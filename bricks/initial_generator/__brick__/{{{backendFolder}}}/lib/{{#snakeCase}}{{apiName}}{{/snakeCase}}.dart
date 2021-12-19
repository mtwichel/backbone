library {{#snakeCase}}{{apiName}}{{/snakeCase}};

import 'package:backbone/backbone.dart';
import 'package:shelf/shelf.dart';
import 'package:{{#snakeCase}}{{apiName}}{{/snakeCase}}_functions_objects/{{#snakeCase}}{{apiName}}{{/snakeCase}}_functions_objects.dart';

Future<String> verifyToken(String token) async {
  // TODO: implement verifyToken
  return 'fake-user-id';
}

final middlewares = <Middleware> [];