library {{#snakeCase}}{{apiName}}{{/snakeCase}};

import 'package:dio/dio.dart';
import 'package:{{#snakeCase}}{{apiName}}{{/snakeCase}}/{{#snakeCase}}{{apiName}}{{/snakeCase}}.dart';

export 'package:{{#snakeCase}}{{apiName}}{{/snakeCase}}_functions_objects/{{#snakeCase}}{{apiName}}{{/snakeCase}}_functions_objects.dart';


class {{#pascalCase}}{{apiName}}{{/pascalCase}} {
  const {{#pascalCase}}{{apiName}}{{/pascalCase}}({
    required this.baseUrl,
    required this.client,
    this.authToken,
  });

  final String baseUrl;
  final Dio client;
  final String? authToken;

  {{#endpoints}}
  Future<{{#pascalCase}}{{responseType}}{{/pascalCase}}> {{name}}({{#hasParams}}{{#hasRequest}}{{#pascalCase}}{{requestType}}{{/pascalCase}} request, {{#pascalCase}}{{paramsType}}{{/pascalCase}} params,{{/hasRequest}}{{^hasRequest}}{{#pascalCase}}{{paramsType}}{{/pascalCase}} params{{/hasRequest}}{{/hasParams}}{{^hasParams}}{{#hasRequest}}{{#pascalCase}}{{requestType}}{{/pascalCase}} request{{/hasRequest}}{{/hasParams}}) async {
   final response = await client.request(
      '{{{pathWithParams}}}',
      {{#hasRequest}}data: request.toJson(),{{/hasRequest}}
      queryParameters: {
          {{#queryParameters}}'{{name}}': params.{{#camelCase}}{{name}}{{/camelCase}},
          {{/queryParameters}}
        },
      options: Options(
        method: {{#upperCase}}'{{method}}',{{/upperCase}}
        headers: {
          {{#headerParameters}}'{{name}}': params.{{#camelCase}}{{name}}{{/camelCase}},
          {{/headerParameters}}
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      ),
    );

    {{#isInFunctionsObjects}}return {{#pascalCase}}{{responseType}}{{/pascalCase}}.fromJson(response.data);{{/isInFunctionsObjects}}{{^isInFunctionsObjects}}return response;{{/isInFunctionsObjects}}
  }
  {{/endpoints}}
}