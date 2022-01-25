import 'dart:async';
import 'dart:convert';

import 'package:backbone/backbone.dart';
import 'package:shelf/shelf.dart';

class EndpointWithoutRequestAndParamsTarget<ResponseType, ParamsType>
    implements Endpoint {
  const EndpointWithoutRequestAndParamsTarget(
    this._function, {
    required JsonConverter<ParamsType> fromParams,
    required bool requiresAuthentication,
    required TokenVerifier tokenVerifier,
  })  : _fromParams = fromParams,
        _tokenVerifier = tokenVerifier,
        _requiresAuthentication = requiresAuthentication;

  final EndpointWithoutRequestAndParamsFunction<ResponseType, ParamsType>
      _function;
  final JsonConverter<ParamsType> _fromParams;
  final TokenVerifier _tokenVerifier;
  final bool _requiresAuthentication;

  @override
  FutureOr<Response> handler(Request request) async {
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

    final response = await _function(params, requestContext);
    if (response is Response) {
      return response;
    }
    final responseJson = jsonEncode(response);

    return Response.ok(
      responseJson,
      headers: const {contentTypeHeader: jsonContentType},
    );
  }
}

typedef EndpointWithoutRequestAndParamsFunction<ResponseType, ParamsType>
    = FutureOr<ResponseType> Function(
  ParamsType params,
  RequestContext context,
);
