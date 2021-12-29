library {{#snakeCase}}{{apiName}}{{/snakeCase}}_functions_objects;

import 'package:json_annotation/json_annotation.dart';

part '{{#snakeCase}}{{apiName}}{{/snakeCase}}_functions_objects.g.dart';

{{#objects}}
{{> object.dart }}
{{/objects}}

{{#parameters}}@JsonSerializable()
class {{#pascalCase}}{{name}}{{/pascalCase}} {
  const {{#pascalCase}}{{name}}{{/pascalCase}}({
    {{#parameters}}{{#required}}required {{/required}}this.{{name}},
    {{/parameters}}
  });
  factory {{#pascalCase}}{{name}}{{/pascalCase}}.fromJson(Map<String, dynamic> json) => _${{#pascalCase}}{{name}}{{/pascalCase}}FromJson(json);

  Map<String, dynamic> toJson() => _${{#pascalCase}}{{name}}{{/pascalCase}}ToJson(this);
  
  {{#parameters}}final String{{^required}}?{{/required}} {{name}};
  {{/parameters}}
}
{{/parameters}}