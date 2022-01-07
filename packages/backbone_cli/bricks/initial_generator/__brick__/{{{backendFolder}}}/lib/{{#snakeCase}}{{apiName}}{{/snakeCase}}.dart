library {{#snakeCase}}{{apiName}}{{/snakeCase}};

import 'package:backbone/backbone.dart';
import 'package:shelf/shelf.dart';
import 'package:{{#snakeCase}}{{apiName}}{{/snakeCase}}_functions_objects/{{#snakeCase}}{{apiName}}{{/snakeCase}}_functions_objects.dart';

Future<String> verifyToken(String token, RequestContext context) async {
  // TODO: implement verifyToken
  throw UnimplementedError('API is not set up for verifing auth tokens yet.');
}

final middlewares = <Middleware> [];