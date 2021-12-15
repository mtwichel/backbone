library pets_api_functions_objects;

import 'package:json_annotation/json_annotation.dart';

part 'pets_api_functions_objects.g.dart';

@JsonSerializable()
class UploadImageResponse {
  const UploadImageResponse({
    this.id,
  });

  factory UploadImageResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadImageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadImageResponseToJson(this);

  final String? id;
}

@JsonSerializable()
class ListPetsResponse {
  const ListPetsResponse({
    required this.pets,
  });

  factory ListPetsResponse.fromJson(Map<String, dynamic> json) =>
      _$ListPetsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListPetsResponseToJson(this);

  final List<Pet> pets;
}

@JsonSerializable()
class CreatePetResponse {
  const CreatePetResponse({
    required this.id,
    this.name,
    this.age,
    required this.type,
  });

  factory CreatePetResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatePetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePetResponseToJson(this);

  final String id;
  final String? name;
  final int? age;
  final String type;
}

@JsonSerializable()
class Pet {
  const Pet({
    required this.id,
    this.name,
    this.age,
    required this.type,
  });

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);

  Map<String, dynamic> toJson() => _$PetToJson(this);

  final String id;
  final String? name;
  final int? age;
  final String type;
}

@JsonSerializable()
class GetPetResponse {
  const GetPetResponse({
    required this.pet,
  });

  factory GetPetResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetPetResponseToJson(this);

  final Pet pet;
}

@JsonSerializable()
class UpdatePetResponse {
  const UpdatePetResponse({
    required this.pet,
  });

  factory UpdatePetResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdatePetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePetResponseToJson(this);

  final Pet pet;
}

@JsonSerializable()
class Pet {
  const Pet({
    required this.id,
    this.name,
    this.age,
    required this.type,
  });

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);

  Map<String, dynamic> toJson() => _$PetToJson(this);

  final String id;
  final String? name;
  final int? age;
  final String type;
}

@JsonSerializable()
class Pet {
  const Pet({
    required this.id,
    this.name,
    this.age,
    required this.type,
  });

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);

  Map<String, dynamic> toJson() => _$PetToJson(this);

  final String id;
  final String? name;
  final int? age;
  final String type;
}
