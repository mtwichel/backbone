import 'dart:async';
import 'dart:convert';

import 'package:backbone/backbone.dart';
import 'package:shelf/shelf.dart';

class EndpointWithRequestAndParamsTarget<RequestType, ResponseType, ParamsType>
    implements Endpoint {
  const EndpointWithRequestAndParamsTarget(
    this._function, {
    required JsonConverter<RequestType> requestFromJson,
    required JsonConverter<ParamsType> fromParams,
    required bool requiresAuthentication,
    required TokenVerifier tokenVerifier,
  })  : _requestFromJson = requestFromJson,
        _fromParams = fromParams,
        _tokenVerifier = tokenVerifier,
        _requiresAuthentication = requiresAuthentication;

  final EndpointWithRequestAndParamsFunction<RequestType, ResponseType,
      ParamsType> _function;
  final JsonConverter<RequestType> _requestFromJson;
  final JsonConverter<ParamsType> _fromParams;
  final TokenVerifier _tokenVerifier;

  final bool _requiresAuthentication;

  @override
  FutureOr<Response> handler(Request request) async {
    final argument = await toRequestType(request, _requestFromJson);
    final params = await toParamsType(request, _fromParams);

    final logger = loggerForRequest(request);
    var requestContext = RequestContext(
      logger: logger,
      rawRequest: request,
      authenticated: _requiresAuthentication,
    );

    if (_requiresAuthentication) {
      requestContext = requestContext.copyWithUserId(
        await verifyAuthorization(requestContext, _tokenVerifier),
      );
    }

    final response = await _function(argument, params, requestContext);
    final responseJson = jsonEncode(response);

    return Response.ok(
      responseJson,
      headers: const {contentTypeHeader: jsonContentType},
    );
  }
}

typedef EndpointWithRequestAndParamsFunction<RequestType, ResponseType,
        ParamsType>
    = FutureOr<ResponseType> Function(
  RequestType request,
  ParamsType params,
  RequestContext context,
);
