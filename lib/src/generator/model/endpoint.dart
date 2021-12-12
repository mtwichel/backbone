import 'package:backbone/cli.dart';
import 'package:json_annotation/json_annotation.dart';

part 'endpoint.g.dart';

@JsonSerializable()
class Endpoint {
  const Endpoint({
    required this.path,
    required this.method,
    required this.name,
    required this.responseType,
    required this.parameters,
    this.requestType,
    this.paramsType,
  });

  Map<String, dynamic> toJson() => _$EndpointToJson(this);

  final String path;
  final String method;
  final String name;
  final String responseType;
  final List<Parameter> parameters;
  final String? requestType;
  final String? paramsType;

  bool get hasParams => parameters.isNotEmpty;
  bool get hasRequest => requestType != null;

  List<Parameter> get queryParameters =>
      parameters.where((p) => p.isQuery).toList();
  List<Parameter> get headerParameters =>
      parameters.where((p) => p.isHeader).toList();
  List<Parameter> get pathParameters =>
      parameters.where((p) => p.isPath).toList();

  String get pathWithParams =>
      path.replaceAll('<', r'${params.').replaceAll('>', '}');
}
