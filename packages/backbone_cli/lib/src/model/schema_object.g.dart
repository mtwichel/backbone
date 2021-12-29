// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$SchemaObjectToJson(SchemaObject instance) =>
    <String, dynamic>{
      'name': instance.name,
      'fields': instance.fields?.map((e) => e.toJson()).toList(),
      'isObject': instance.isObject,
      'isArray': instance.isArray,
      'description': instance.description,
      'typeName': instance.typeName,
      'required': instance.required,
    };
