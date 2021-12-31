library pets_api;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pets_api/pets_api.dart';

export 'package:pets_api_functions_objects/pets_api_functions_objects.dart';

class PetsApi {
  const PetsApi({
    required this.baseUrl,
    required this.client,
    this.authToken,
  });

  final String baseUrl;
  final Dio client;
  final String? authToken;

  Future<UploadImageResponse> uploadImage(UploadImageParameters params) async {
    final response = await client.request(
      '/v1/pets/${params.petId}/images',
      queryParameters: {},
      options: Options(
        method: 'POST',
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      ),
    );

    return UploadImageResponse.fromJson(response.data);
  }

  Future<ListPetsResponse> listPets() async {
    final response = await client.request(
      '/v1/pets',
      queryParameters: {},
      options: Options(
        method: 'GET',
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      ),
    );

    return ListPetsResponse.fromJson(response.data);
  }

  Future<CreatePetResponse> createPet(Pet request) async {
    final response = await client.request(
      '/v1/pets',
      data: request.toJson(),
      queryParameters: {},
      options: Options(
        method: 'POST',
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      ),
    );

    return CreatePetResponse.fromJson(response.data);
  }

  Future<GetPetResponse> getPet(GetPetParameters params) async {
    final response = await client.request(
      '/v1/pets/${params.petId}',
      queryParameters: {},
      options: Options(
        method: 'GET',
        headers: {
          'test': params.test,
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      ),
    );

    return GetPetResponse.fromJson(response.data);
  }

  Future<UpdatePetResponse> updatePet(
    Pet request,
    UpdatePetParameters params,
  ) async {
    final response = await client.request(
      '/v1/pets/${params.petId}',
      data: request.toJson(),
      queryParameters: {},
      options: Options(
        method: 'PUT',
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      ),
    );

    return UpdatePetResponse.fromJson(response.data);
  }
}
