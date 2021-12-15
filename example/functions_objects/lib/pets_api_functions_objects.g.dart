// GENERATED CODE - DO NOT MODIFY BY HAND

part of pets_api_functions_objects;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadImageResponse _$UploadImageResponseFromJson(Map<String, dynamic> json) =>
    UploadImageResponse(
      id: json['id'] as String?,
    );

Map<String, dynamic> _$UploadImageResponseToJson(
        UploadImageResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

ListPetsResponse _$ListPetsResponseFromJson(Map<String, dynamic> json) =>
    ListPetsResponse(
      pets: (json['pets'] as List<dynamic>)
          .map((e) => Pet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListPetsResponseToJson(ListPetsResponse instance) =>
    <String, dynamic>{
      'pets': instance.pets,
    };

CreatePetResponse _$CreatePetResponseFromJson(Map<String, dynamic> json) =>
    CreatePetResponse(
      id: json['id'] as String,
      name: json['name'] as String?,
      age: json['age'] as int?,
      type: json['type'] as String,
    );

Map<String, dynamic> _$CreatePetResponseToJson(CreatePetResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'type': instance.type,
    };

Pet _$PetFromJson(Map<String, dynamic> json) => Pet(
      id: json['id'] as String,
      name: json['name'] as String?,
      age: json['age'] as int?,
      type: json['type'] as String,
    );

Map<String, dynamic> _$PetToJson(Pet instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'type': instance.type,
    };

GetPetResponse _$GetPetResponseFromJson(Map<String, dynamic> json) =>
    GetPetResponse(
      pet: Pet.fromJson(json['pet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetPetResponseToJson(GetPetResponse instance) =>
    <String, dynamic>{
      'pet': instance.pet,
    };

UpdatePetResponse _$UpdatePetResponseFromJson(Map<String, dynamic> json) =>
    UpdatePetResponse(
      pet: Pet.fromJson(json['pet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdatePetResponseToJson(UpdatePetResponse instance) =>
    <String, dynamic>{
      'pet': instance.pet,
    };

UploadImageParameters _$UploadImageParametersFromJson(
        Map<String, dynamic> json) =>
    UploadImageParameters(
      petId: json['petId'] as String,
    );

Map<String, dynamic> _$UploadImageParametersToJson(
        UploadImageParameters instance) =>
    <String, dynamic>{
      'petId': instance.petId,
    };

GetPetParameters _$GetPetParametersFromJson(Map<String, dynamic> json) =>
    GetPetParameters(
      petId: json['petId'] as String,
      test: json['test'] as String,
    );

Map<String, dynamic> _$GetPetParametersToJson(GetPetParameters instance) =>
    <String, dynamic>{
      'petId': instance.petId,
      'test': instance.test,
    };

UpdatePetParameters _$UpdatePetParametersFromJson(Map<String, dynamic> json) =>
    UpdatePetParameters(
      petId: json['petId'] as String,
    );

Map<String, dynamic> _$UpdatePetParametersToJson(
        UpdatePetParameters instance) =>
    <String, dynamic>{
      'petId': instance.petId,
    };
