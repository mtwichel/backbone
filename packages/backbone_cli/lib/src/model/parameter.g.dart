// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parameter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$ParameterToJson(Parameter instance) => <String, dynamic>{
      'name': instance.name,
      'fields': instance.fields?.map((e) => e.toJson()).toList(),
      'isObject': instance.isObject,
      'isArray': instance.isArray,
      'description': instance.description,
      'typeName': instance.typeName,
      'required': instance.required,
      'itemsType': instance.itemsType?.toJson(),
      'isRoot': instance.isRoot,
      'toJsonString': instance.toJsonString,
      'fromJsonString': instance.fromJsonString,
      'location': _$ParameterLocationEnumMap[instance.location],
      'isHeader': instance.isHeader,
      'isQuery': instance.isQuery,
      'isPath': instance.isPath,
    };

const _$ParameterLocationEnumMap = {
  ParameterLocation.header: 'header',
  ParameterLocation.query: 'query',
  ParameterLocation.path: 'path',
};
