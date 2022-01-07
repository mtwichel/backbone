import 'package:backbone_cli/backbone_cli.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:open_api_forked/v3.dart';

part 'parameter.g.dart';

@JsonSerializable()
class Parameter extends SchemaObject {
  const Parameter({
    required String name,
    required bool required,
    required String typeName,
    required this.location,
  }) : super(
          name: name,
          required: required,
          typeName: typeName,
          isArray: false,
          isObject: false,
          description: null,
          fields: null,
          isRoot: true,
        );

  factory Parameter.fromOpenApi({
    required APIParameter parameter,
  }) {
    return Parameter(
      name: parameter.name!,
      required: parameter.isRequired,
      typeName: getTypeNameFromSchemaObject(parameter.schema!, null),
      location: parameterLocationFromOpenApi(parameter.location!),
    );
  }

  @override
  Map<String, dynamic> toJson() => _$ParameterToJson(this);

  final ParameterLocation location;

  bool get isHeader => location == ParameterLocation.header;
  bool get isQuery => location == ParameterLocation.query;
  bool get isPath => location == ParameterLocation.path;
}

enum ParameterLocation {
  @JsonValue('header')
  header,
  @JsonValue('query')
  query,
  @JsonValue('path')
  path,
}

ParameterLocation parameterLocationFromOpenApi(APIParameterLocation location) {
  switch (location) {
    case APIParameterLocation.header:
      return ParameterLocation.header;
    case APIParameterLocation.query:
      return ParameterLocation.query;
    case APIParameterLocation.path:
      return ParameterLocation.path;
    case APIParameterLocation.cookie:
      throw UnimplementedError('Cookie parameters are not supported');
  }
}
