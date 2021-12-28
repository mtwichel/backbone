// GENERATED CODE - DO NOT MODIFY BY HAND

part of pets_api_functions_objects;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$UploadImageResponseToJson(
        UploadImageResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

Map<String, dynamic> _$ListPetsResponseToJson(ListPetsResponse instance) =>
    <String, dynamic>{
      'pets': instance.pets.map((e) => e.toJson()).toList(),
    };

Map<String, dynamic> _$CreatePetResponseToJson(CreatePetResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'type': instance.type,
    };

Map<String, dynamic> _$PetToJson(Pet instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'type': instance.type,
    };

Map<String, dynamic> _$GetPetResponseToJson(GetPetResponse instance) =>
    <String, dynamic>{
      'pet': instance.pet.toJson(),
    };

Map<String, dynamic> _$UpdatePetResponseToJson(UpdatePetResponse instance) =>
    <String, dynamic>{
      'pet': instance.pet.toJson(),
    };

Map<String, dynamic> _$UploadImageParametersToJson(
        UploadImageParameters instance) =>
    <String, dynamic>{
      'petId': instance.petId,
    };

Map<String, dynamic> _$GetPetParametersToJson(GetPetParameters instance) =>
    <String, dynamic>{
      'petId': instance.petId,
      'test': instance.test,
    };

Map<String, dynamic> _$UpdatePetParametersToJson(
        UpdatePetParameters instance) =>
    <String, dynamic>{
      'petId': instance.petId,
    };
