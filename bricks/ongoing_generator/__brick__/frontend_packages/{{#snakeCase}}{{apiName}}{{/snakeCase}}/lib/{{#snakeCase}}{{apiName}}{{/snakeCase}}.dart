library {{#snakeCase}}{{apiName}}{{/snakeCase}};

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:{{#snakeCase}}{{apiName}}{{/snakeCase}}_functions_objects/{{#snakeCase}}{{apiName}}{{/snakeCase}}_functions_objects.dart';


class {{#pascalCase}}{{apiName}}{{/pascalCase}} {
  const {{#pascalCase}}{{apiName}}{{/pascalCase}}({
    required this.baseUrl,
    required this.client,
  });

  final String baseUrl;
  final Dio client;

  {{#endpoints}}
  Future<{{#pascalCase}}{{responseType}}{{/pascalCase}}> {{name}}({{#hasParams}}{{#hasRequest}}{{#pascalCase}}{{requestType}}{{/pascalCase}} request, {{#pascalCase}}{{paramsType}}{{/pascalCase}} params,{{/hasRequest}}{{^hasRequest}}{{#pascalCase}}{{paramsType}}{{/pascalCase}} params{{/hasRequest}}{{/hasParams}}{{^hasParams}}{{#hasRequest}}{{#pascalCase}}{{requestType}}{{/pascalCase}} request{{/hasRequest}}{{/hasParams}}) async {
   final response = await client.request(
      '{{{pathWithParams}}}',
      {{#hasRequest}}data: request.toJson(),{{/hasRequest}}
      queryParameters: {
          {{#queryParameters}}'{{name}}': params.{{name}},
          {{/queryParameters}}
        },
      options: Options(
        method: {{#upperCase}}'{{method}}',{{/upperCase}}
        headers: {
          {{#headerParameters}}'{{name}}': params.{{name}},
          {{/headerParameters}}
        },
      ),
    );

    final body = jsonDecode(response.data);

    return {{#pascalCase}}{{responseType}}{{/pascalCase}}.fromJson(body);
  }
  {{/endpoints}}
}