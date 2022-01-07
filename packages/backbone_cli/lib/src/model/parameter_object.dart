import 'package:backbone_cli/backbone_cli.dart';
import 'package:json_annotation/json_annotation.dart';

part 'parameter_object.g.dart';

@JsonSerializable()
class ParameterObject {
  const ParameterObject({
    required this.name,
    required this.parameters,
    this.isObject = true,
  });

  Map<String, dynamic> toJson() => _$ParameterObjectToJson(this);

  List<SchemaObject> get fields => parameters;
  final bool isObject;

  final String name;
  final List<Parameter> parameters;
}
