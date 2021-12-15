import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:pets_api/pets_api.dart' as api;
import 'package:pets_api_functions_objects/pets_api_functions_objects.dart'
    as function_objects;
import 'package:backbone/backbone.dart';

void main() async {
  final port = Platform.environment['PORT'] ?? '8080';

  final router = Router();

  router.add(
    'POST',
    '/v1/pets/<petId>/images',
    EndpointWithoutRequestAndParamsTarget<function_objects.UploadImageResponse,
        function_objects.UploadImageParameters>(
      api.uploadImage,
      (params) => function_objects.UploadImageParameters.fromJson(params),
    ).handler,
  );

  router.add(
    'GET',
    '/v1/pets',
    EndpointWithoutRequestTarget<function_objects.ListPetsResponse>(
      api.listPets,
    ).handler,
  );

  router.add(
    'POST',
    '/v1/pets',
    EndpointWithRequestTarget<function_objects.Pet,
        function_objects.CreatePetResponse>(
      api.createPet,
      (json) => function_objects.Pet.fromJson(json),
    ).handler,
  );

  router.add(
    'GET',
    '/v1/pets/<petId>',
    EndpointWithoutRequestAndParamsTarget<function_objects.GetPetResponse,
        function_objects.GetPetParameters>(
      api.getPet,
      (params) => function_objects.GetPetParameters.fromJson(params),
    ).handler,
  );

  router.add(
    'PUT',
    '/v1/pets/<petId>',
    EndpointWithRequestAndParamsTarget<
        function_objects.Pet,
        function_objects.UpdatePetResponse,
        function_objects.UpdatePetParameters>(
      api.updatePet,
      (json) => function_objects.Pet.fromJson(json),
      (params) => function_objects.UpdatePetParameters.fromJson(params),
    ).handler,
  );

  final server = await shelf_io.serve(
    Pipeline().addHandler(router),
    InternetAddress.anyIPv4,
    int.parse(port),
  );
  print('Listening on :${server.port}');
}
