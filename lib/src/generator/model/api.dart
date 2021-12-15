import 'package:backbone/cli.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:open_api_forked/v3.dart';

part 'api.g.dart';

@JsonSerializable()
class Api {
  const Api({
    required this.apiName,
    required this.endpoints,
    required this.objects,
    required this.parameterObjects,
    required this.backendFolder,
  });

  factory Api.fromOpenApi(
    APIDocument api, {
    required String backendName,
  }) {
    final endpoints = <Endpoint>[];
    final objects = <SchemaObject>[];
    final parameterObjects = <ParameterObject>[];

    for (final pathEntry in api.paths!.entries) {
      final pathParamers = pathEntry.value!.parameters;
      for (final operationEntry in pathEntry.value!.operations.entries) {
        final operation = operationEntry.value;
        if (operation != null) {
          final operationId = operation.id;
          if (operationId == null) {
            throw Exception(
              'Operation id missing: ${operationEntry.key}: ${pathEntry.key}',
            );
          }

          final operationParameters = operation.parameters;
          final combinedParameters = [...?pathParamers, ...?operationParameters]
              .where((p) => p != null && p.name != null)
              .map(
                (parameter) => Parameter(
                  name: parameter!.name!,
                  required: parameter.isRequired,
                  type: parameterTypeFromOpenApi(parameter.location!),
                ),
              )
              .toList();
          String? paramsType;
          if (combinedParameters.isNotEmpty) {
            paramsType = '${operationId}Parameters';
            parameterObjects.add(
              ParameterObject(
                name: paramsType,
                parameters: combinedParameters,
              ),
            );
          }

          final successfulResponse = operation.responses!['200'];

          if (successfulResponse == null) {
            throw Exception('No 200 response found for ${operationEntry.key}');
          }
          final responseName = successfulResponse.referenceURI?.pathSegments[2];

          final responseSchema =
              successfulResponse.content?['application/json']?.schema;
          if (responseSchema == null) {
            throw Exception(
              'Response schema missing ${operationEntry.key}: ${pathEntry.key}',
            );
          }
          objects.add(
            SchemaObject.fromOpenApi(
              object: responseSchema,
              name: responseName ?? '${operationId}Response',
            ),
          );

          String? requestName;
          final requestSchema =
              operation.requestBody?.content?['application/json']?.schema;

          if (requestSchema != null) {
            requestName = requestSchema.referenceURI?.pathSegments[2] ??
                '${operationId}Request';

            objects.add(
              SchemaObject.fromOpenApi(
                object: requestSchema,
                name: requestName,
              ),
            );
          }

          endpoints.add(
            Endpoint(
              name: operationId,
              path: pathEntry.key.replaceAll('{', '<').replaceAll('}', '>'),
              method: operationEntry.key,
              requestType: requestName,
              paramsType: paramsType,
              responseType: responseName ?? '${operationId}Response',
              parameters: combinedParameters,
            ),
          );
        }
      }
    }

    for (final schemaEntry in api.components!.schemas!.entries) {
      objects.add(
        SchemaObject.fromOpenApi(
          object: schemaEntry.value!,
          name: schemaEntry.key,
        ),
      );
    }

    return Api(
      apiName: api.info!.title!,
      endpoints: endpoints,
      objects: objects,
      parameterObjects: parameterObjects,
      backendFolder: backendName,
    );
  }

  Map<String, dynamic> toJson() => _$ApiToJson(this);

  final String apiName;
  final List<Endpoint> endpoints;
  final List<SchemaObject> objects;
  final List<ParameterObject> parameterObjects;
  final String backendFolder;
}
