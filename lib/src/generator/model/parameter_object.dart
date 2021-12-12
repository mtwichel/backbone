import 'package:backbone/cli.dart';
import 'package:json_annotation/json_annotation.dart';

part 'parameter_object.g.dart';

@JsonSerializable()
class ParameterObject {
  const ParameterObject({
    required this.name,
    required this.parameters,
  });

  Map<String, dynamic> toJson() => _$ParameterObjectToJson(this);

  final String name;
  final List<Parameter> parameters;
}
