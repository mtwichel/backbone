library pets_api_functions_objects;

void main() {
  const pet = Pet(
    id: 'test-id',
    name: 'Test Pet',
    type: 'Cat',
    age: 5,
    otherNames: ['Tester Petter'],
  );

  final json = pet.toJson();
  final petFromJson = Pet.fromJson(json);
  print('hi');
}

class UploadImageResponse {
  const UploadImageResponse({
    this.id,
  });

  factory UploadImageResponse.fromJson(Map<String, dynamic> json) {
    return UploadImageResponse(
      id: json['id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
      };

  final String? id;
}

class ListPetsResponse {
  const ListPetsResponse({
    required this.pets,
  });

  factory ListPetsResponse.fromJson(Map<String, dynamic> json) {
    return ListPetsResponse(
      pets: (json['pets'] as List)
          .map((dynamic e) => Pet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'pets': pets.map((e) => e.toJson()).toList(),
      };

  final List<Pet> pets;
}

class CreatePetResponse {
  const CreatePetResponse({
    required this.id,
    this.name,
    this.age,
    required this.type,
    required this.otherNames,
  });

  factory CreatePetResponse.fromJson(Map<String, dynamic> json) {
    return CreatePetResponse(
      id: json['id'] as String,
      name: json['name'] as String?,
      age: json['age'] as int?,
      type: json['type'] as String,
      otherNames: (json['other-names'] as List)
          .map((dynamic e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'age': age,
        'type': type,
        'other-names': otherNames.map((e) => e).toList(),
      };

  final String id;
  final String? name;
  final int? age;
  final String type;
  final List<String> otherNames;
}

class Pet {
  const Pet({
    required this.id,
    this.name,
    this.age,
    required this.type,
    required this.otherNames,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as String,
      name: json['name'] as String?,
      age: json['age'] as int?,
      type: json['type'] as String,
      otherNames: (json['other-names'] as List)
          .map((dynamic e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'age': age,
        'type': type,
        'other-names': otherNames.map((e) => e).toList(),
      };

  final String id;
  final String? name;
  final int? age;
  final String type;
  final List<String> otherNames;
}

class GetPetResponse {
  const GetPetResponse({
    required this.pet,
  });

  factory GetPetResponse.fromJson(Map<String, dynamic> json) {
    return GetPetResponse(
      pet: Pet.fromJson(json['pet'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'pet': pet.toJson(),
      };

  final Pet pet;
}

class UpdatePetResponse {
  const UpdatePetResponse({
    required this.pet,
  });

  factory UpdatePetResponse.fromJson(Map<String, dynamic> json) {
    return UpdatePetResponse(
      pet: Pet.fromJson(json['pet'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'pet': pet.toJson(),
      };

  final Pet pet;
}

class UploadImageParameters {
  const UploadImageParameters({
    required this.petId,
  });

  factory UploadImageParameters.fromJson(Map<String, dynamic> json) {
    return UploadImageParameters(
      petId: json['petId'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'petId': petId,
      };

  final String petId;
}

class GetPetParameters {
  const GetPetParameters({
    required this.petId,
    required this.test,
  });

  factory GetPetParameters.fromJson(Map<String, dynamic> json) {
    return GetPetParameters(
      petId: json['petId'] as String,
      test: json['test'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'petId': petId,
        'test': test,
      };

  final String petId;
  final String test;
}

class UpdatePetParameters {
  const UpdatePetParameters({
    required this.petId,
  });

  factory UpdatePetParameters.fromJson(Map<String, dynamic> json) {
    return UpdatePetParameters(
      petId: json['petId'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'petId': petId,
      };

  final String petId;
}
