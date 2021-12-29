// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parameter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$ParameterToJson(Parameter instance) => <String, dynamic>{
      'name': instance.name,
      'required': instance.required,
      'type': _$ParameterTypeEnumMap[instance.type],
      'isHeader': instance.isHeader,
      'isQuery': instance.isQuery,
      'isPath': instance.isPath,
    };

const _$ParameterTypeEnumMap = {
  ParameterType.header: 'header',
  ParameterType.query: 'query',
  ParameterType.path: 'path',
};
