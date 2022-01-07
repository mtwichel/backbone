library {{#snakeCase}}{{apiName}}{{/snakeCase}}_functions_objects;

{{#objects}}
{{> object.dart }}
{{/objects}}

{{#parameters}}
{{> object.dart }}
{{/parameters}}

