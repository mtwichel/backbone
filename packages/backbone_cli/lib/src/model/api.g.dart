// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$ApiToJson(Api instance) => <String, dynamic>{
      'apiName': instance.apiName,
      'endpoints': instance.endpoints.map((e) => e.toJson()).toList(),
      'objects': instance.objects.map((e) => e.toJson()).toList(),
      'parameters': instance.parameters.map((e) => e.toJson()).toList(),
      'backendFolder': instance.backendFolder,
    };
