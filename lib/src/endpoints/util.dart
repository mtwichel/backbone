import 'dart:convert';

import 'package:backbone/backbone.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Future<RequestType> toRequestType<RequestType>(
  Request request,
  RequestType Function(Map<String, dynamic> json) fromJson,
) async {
  final type = mediaTypeFromRequest(request);
  mustBeJson(type);
  final jsonObject = await decodeJson(request);
  if ((jsonObject is! Map<String, dynamic>?) || jsonObject == null) {
    throw BadRequestException(400, 'Expected a JSON object');
  }
  return fromJson(jsonObject);
}

Future<ParamsType> toParamsType<ParamsType>(
  Request request,
  ParamsType Function(Map<String, dynamic> params) fromParams,
) async {
  final combinedParams = {
    ...request.params,
    ...request.headers,
    ...request.requestedUri.queryParameters,
  };

  return fromParams(combinedParams);
}

Map<String, dynamic> combinedParamsMap(Request request) {
  return <String, dynamic>{
    ...request.headers,
    ...request.requestedUri.queryParameters,
    ...request.params,
  };
}

MediaType mediaTypeFromRequest(Request request) {
  final contentType = request.headers[contentTypeHeader];
  if (contentType == null) {
    throw BadRequestException(400, '$contentTypeHeader header is required.');
  }
  try {
    return MediaType.parse(contentType);
  } catch (e, stack) {
    throw BadRequestException(
      400,
      'Could not parse $contentTypeHeader header.',
      innerError: e,
      innerStack: stack,
    );
  }
}

void mustBeJson(MediaType type) {
  if (type.mimeType != jsonContentType) {
    throw BadRequestException(
      400,
      'Unsupported encoding "${type.toString()}". '
      'Only "$jsonContentType" is supported.',
    );
  }
}

Future<Object?> decodeJson(Request request) async {
  final content = await request.readAsString();
  try {
    final Object? value = jsonDecode(content);
    return value;
  } on FormatException catch (e, stackTrace) {
    throw BadRequestException(
      400,
      'Could not parse the request body as JSON.',
      innerError: e,
      innerStack: stackTrace,
    );
  }
}
