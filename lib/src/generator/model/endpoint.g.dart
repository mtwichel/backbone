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
      'hasParams': instance.hasParams,
      'hasRequest': instance.hasRequest,
      'parameters': instance.parameters.map((e) => e.toJson()).toList(),
      'requestType': instance.requestType,
      'paramsType': instance.paramsType,
      'queryParameters':
          instance.queryParameters.map((e) => e.toJson()).toList(),
      'headerParameters':
          instance.headerParameters.map((e) => e.toJson()).toList(),
      'pathParameters': instance.pathParameters.map((e) => e.toJson()).toList(),
      'pathWithParams': instance.pathWithParams,
    };
