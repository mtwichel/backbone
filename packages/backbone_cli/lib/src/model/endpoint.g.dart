// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'endpoint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$EndpointToJson(Endpoint instance) => <String, dynamic>{
      'path': instance.path,
      'method': instance.method,
      'name': instance.name,
      'responseType': instance.responseType,
      'parameters': instance.parameters.map((e) => e.toJson()).toList(),
      'requestType': instance.requestType,
      'paramsType': instance.paramsType,
      'requiresAuthentication': instance.requiresAuthentication,
      'hasParams': instance.hasParams,
      'hasRequest': instance.hasRequest,
      'queryParameters':
          instance.queryParameters.map((e) => e.toJson()).toList(),
      'headerParameters':
          instance.headerParameters.map((e) => e.toJson()).toList(),
      'pathParameters': instance.pathParameters.map((e) => e.toJson()).toList(),
      'isInFunctionsObjects': instance.isInFunctionsObjects,
      'pathWithParams': instance.pathWithParams,
    };
