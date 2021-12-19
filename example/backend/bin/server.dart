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
      fromParams: (params) =>
          function_objects.UploadImageParameters.fromJson(params),
      tokenVerifier: api.verifyToken,
      requiresAuthentication: false,
    ).handler,
  );

  router.add(
    'GET',
    '/v1/pets',
    EndpointWithoutRequestTarget<function_objects.ListPetsResponse>(
      api.listPets,
      tokenVerifier: api.verifyToken,
      requiresAuthentication: false,
    ).handler,
  );

  router.add(
    'POST',
    '/v1/pets',
    EndpointWithRequestTarget<function_objects.Pet,
        function_objects.CreatePetResponse>(
      api.createPet,
      requestFromJson: (json) => function_objects.Pet.fromJson(json),
      tokenVerifier: api.verifyToken,
      requiresAuthentication: true,
    ).handler,
  );

  router.add(
    'GET',
    '/v1/pets/<petId>',
    EndpointWithoutRequestAndParamsTarget<function_objects.GetPetResponse,
        function_objects.GetPetParameters>(
      api.getPet,
      fromParams: (params) =>
          function_objects.GetPetParameters.fromJson(params),
      tokenVerifier: api.verifyToken,
      requiresAuthentication: false,
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
      requestFromJson: (json) => function_objects.Pet.fromJson(json),
      fromParams: (params) =>
          function_objects.UpdatePetParameters.fromJson(params),
      tokenVerifier: api.verifyToken,
      requiresAuthentication: false,
    ).handler,
  );

  var pipeline = Pipeline();

  for (final middleware in api.middlewares) {
    pipeline = pipeline.addMiddleware(middleware);
  }
  pipeline = pipeline.addMiddleware(authenticationMiddleware());

  final handler = pipeline.addHandler(router);

  final server = await shelf_io.serve(
    handler,
    InternetAddress.anyIPv4,
    int.parse(port),
  );
  print('Listening on :${server.port}');
}
