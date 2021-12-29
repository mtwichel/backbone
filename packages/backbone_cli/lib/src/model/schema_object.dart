import 'package:json_annotation/json_annotation.dart';
import 'package:open_api_forked/v3.dart';
import 'package:recase/recase.dart';

part 'schema_object.g.dart';

@JsonSerializable()
class SchemaObject {
  const SchemaObject({
    required this.name,
    required this.isArray,
    required this.isObject,
    required this.typeName,
    required this.required,
    this.fields,
    this.description,
  });

  factory SchemaObject.fromOpenApi({
    required APISchemaObject object,
    required String name,
    bool required = false,
  }) {
    return SchemaObject(
      name: name,
      required: required,
      typeName: getTypeNameFromSchemaObject(object, name),
      fields: object.properties?.entries
          .map(
            (property) => SchemaObject.fromOpenApi(
              name: property.key,
              object: property.value!,
              required: object.required?.contains(property.key) ?? false,
            ),
          )
          .toList(),
      isArray: object.type == APIType.array,
      isObject: object.type == APIType.object,
      description: object.description,
    );
  }

  Map<String, dynamic> toJson() => _$SchemaObjectToJson(this);

  final String name;
  final List<SchemaObject>? fields;
  final bool isObject;
  final bool isArray;
  final String? description;
  final String typeName;
  final bool required;
}

String getTypeNameFromSchemaObject(
  APISchemaObject object,
  String? name,
) {
  switch (object.type!) {
    case APIType.string:
      return 'String';
    case APIType.number:
      return 'double';
    case APIType.integer:
      return 'int';
    case APIType.boolean:
      return 'bool';
    case APIType.array:
      return 'List<${getTypeNameFromSchemaObject(object.items!, null)}>';
    case APIType.object:
      return (object.referenceURI?.pathSegments[2] ?? object.title ?? name!)
          .pascalCase;
  }
}
