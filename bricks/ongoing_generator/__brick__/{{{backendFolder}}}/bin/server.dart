import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:{{#snakeCase}}{{apiName}}{{/snakeCase}}/{{#snakeCase}}{{apiName}}{{/snakeCase}}.dart' as api;
import 'package:{{#snakeCase}}{{apiName}}{{/snakeCase}}_functions_objects/{{#snakeCase}}{{apiName}}{{/snakeCase}}_functions_objects.dart' as function_objects;
import 'package:backbone/backbone.dart';

void main() async {
  final port = Platform.environment['PORT'] ?? '8080';

  final router = Router();
  {{#endpoints}}
  {{#hasRequest}}

  {{#hasParams}}
  router.add('{{#upperCase}}{{method}}{{/upperCase}}', '{{{path}}}', EndpointWithRequestAndParamsTarget<function_objects.{{#pascalCase}}{{requestType}}{{/pascalCase}}, function_objects.{{#pascalCase}}{{responseType}}{{/pascalCase}}, function_objects.{{#pascalCase}}{{paramsType}}{{/pascalCase}}>(api.{{#camelCase}}{{name}}{{/camelCase}},
    requestFromJson: (json) => function_objects.{{#pascalCase}}{{requestType}}{{/pascalCase}}.fromJson(json),
    fromParams: (params) => function_objects.{{#pascalCase}}{{paramsType}}{{/pascalCase}}.fromJson(params),
    tokenVerifier: api.tokenVerifier,
    requiresAuthentication: {{requiresAuthentication}},
  ).handler,);
  {{/hasParams}}

  {{^hasParams}}
  router.add('{{#upperCase}}{{method}}{{/upperCase}}', '{{{path}}}', EndpointWithRequestTarget<function_objects.{{#pascalCase}}{{requestType}}{{/pascalCase}}, function_objects.{{#pascalCase}}{{responseType}}{{/pascalCase}}>(api.{{#camelCase}}{{name}}{{/camelCase}},
    requestFromJson: (json) => function_objects.{{#pascalCase}}{{requestType}}{{/pascalCase}}.fromJson(json),
    tokenVerifier: api.tokenVerifier,
    requiresAuthentication: {{requiresAuthentication}},
  ).handler,);
  {{/hasParams}}

  {{/hasRequest}}

  {{^hasRequest}}

  {{#hasParams}}
  router.add('{{#upperCase}}{{method}}{{/upperCase}}', '{{{path}}}', EndpointWithoutRequestAndParamsTarget<function_objects.{{#pascalCase}}{{responseType}}{{/pascalCase}}, function_objects.{{#pascalCase}}{{paramsType}}{{/pascalCase}}>(api.{{#camelCase}}{{name}}{{/camelCase}},
    fromParams: (params) => function_objects.{{#pascalCase}}{{paramsType}}{{/pascalCase}}.fromJson(params),
    tokenVerifier: api.tokenVerifier,
    requiresAuthentication: {{requiresAuthentication}},
  ).handler,);
  {{/hasParams}}

  {{^hasParams}}
  router.add('{{#upperCase}}{{method}}{{/upperCase}}', '{{{path}}}', EndpointWithoutRequestTarget<function_objects.{{#pascalCase}}{{responseType}}{{/pascalCase}}>(api.{{#camelCase}}{{name}}{{/camelCase}},
    tokenVerifier: api.tokenVerifier,
    requiresAuthentication: {{requiresAuthentication}},
  ).handler,);
  {{/hasParams}}


  {{/hasRequest}}

  {{/endpoints}}

  final server = await shelf_io.serve(
    Pipeline()
      .addMiddleware(authenticationMiddleware())
      .addHandler(router),
    InternetAddress.anyIPv4,
    int.parse(port),
  );
  print('Listening on :${server.port}');
}