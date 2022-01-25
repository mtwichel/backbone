import 'dart:async';
import 'dart:convert';

import 'package:backbone/backbone.dart';
import 'package:shelf/shelf.dart';

class EndpointWithRequestTarget<RequestType, ResponseType> implements Endpoint {
  const EndpointWithRequestTarget(
    this._function, {
    required JsonConverter<RequestType> requestFromJson,
    required bool requiresAuthentication,
    required TokenVerifier tokenVerifier,
  })  : _requestFromJson = requestFromJson,
        _tokenVerifier = tokenVerifier,
        _requiresAuthentication = requiresAuthentication;

  final EndpointWithRequestFunction<RequestType, ResponseType> _function;
  final JsonConverter<RequestType> _requestFromJson;
  final TokenVerifier _tokenVerifier;
  final bool _requiresAuthentication;

  @override
  FutureOr<Response> handler(Request request) async {
    final argument = await toRequestType(request, _requestFromJson);

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

    final response = await _function(argument, requestContext);
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

typedef EndpointWithRequestFunction<RequestType, ResponseType>
    = FutureOr<ResponseType> Function(
  RequestType request,
  RequestContext context,
);
