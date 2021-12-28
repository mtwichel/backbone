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
    required this.requiresAuthentication,
    this.requestType,
    this.paramsType,
    this.requestContentType,
  });

  Map<String, dynamic> toJson() => _$EndpointToJson(this);

  final String path;
  final String method;
  final String name;
  final String responseType;
  final List<Parameter> parameters;
  final String? requestType;
  final String? paramsType;
  final bool requiresAuthentication;
  final String? requestContentType;

  bool get hasParams => parameters.isNotEmpty;
  bool get hasRequest => requestType != null;
  bool get hasJsonRequest => requestContentType == 'application/json';
  bool get hasMultipartRequest => requestContentType == 'multipart/form-data';

  List<Parameter> get queryParameters =>
      parameters.where((p) => p.isQuery).toList();
  List<Parameter> get headerParameters =>
      parameters.where((p) => p.isHeader).toList();
  List<Parameter> get pathParameters =>
      parameters.where((p) => p.isPath).toList();

  String get pathWithParams =>
      path.replaceAll('<', r'${params.').replaceAll('>', '}');
}
