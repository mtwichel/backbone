library pets_api;

import 'package:backbone/backbone.dart';
import 'package:shelf/shelf.dart';
import 'package:pets_api_functions_objects/pets_api_functions_objects.dart';

Future<String> verifyToken(String token) async {
  throw UnimplementedError('API is not set up for verifing auth tokens yet.');
}

final middlewares = <Middleware>[];

Future<UploadImageResponse> uploadImage(
  UploadImageParameters params,
  RequestContext context,
) async {
  return UploadImageResponse();
}

Future<ListPetsResponse> listPets(
  RequestContext context,
) async {
  return ListPetsResponse(pets: []);
}

Future<CreatePetResponse> createPet(
  Pet request,
  RequestContext context,
) async {
  return CreatePetResponse(
    id: 'id',
    type: 'cat',
    age: 4,
  );
}

Future<GetPetResponse> getPet(
  GetPetParameters params,
  RequestContext context,
) async {
  return GetPetResponse(
    pet: Pet(
      id: 'id',
      type: 'cat',
      age: 4,
    ),
  );
}

Future<UpdatePetResponse> updatePet(
  Pet request,
  UpdatePetParameters params,
  RequestContext context,
) async {
  return UpdatePetResponse(
    pet: Pet(
      id: 'id',
      type: 'cat',
      age: 4,
    ),
  );
}
