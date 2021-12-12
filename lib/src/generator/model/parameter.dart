import 'package:json_annotation/json_annotation.dart';
import 'package:open_api_forked/v3.dart';

part 'parameter.g.dart';

@JsonSerializable()
class Parameter {
  const Parameter({
    required this.name,
    required this.required,
    required this.type,
  });

  Map<String, dynamic> toJson() => _$ParameterToJson(this);

  final String name;
  final bool required;
  final ParameterType type;

  bool get isHeader => type == ParameterType.header;
  bool get isQuery => type == ParameterType.query;
  bool get isPath => type == ParameterType.path;
}

enum ParameterType {
  @JsonValue('header')
  header,
  @JsonValue('query')
  query,
  @JsonValue('path')
  path,
}

ParameterType parameterTypeFromOpenApi(APIParameterLocation location) {
  switch (location) {
    case APIParameterLocation.header:
      return ParameterType.header;
    case APIParameterLocation.query:
      return ParameterType.query;
    case APIParameterLocation.path:
      return ParameterType.path;
    case APIParameterLocation.cookie:
      throw UnimplementedError('Cookie parameters are not supported');
  }
}
