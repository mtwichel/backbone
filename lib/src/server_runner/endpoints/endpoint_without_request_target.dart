import 'dart:async';
import 'dart:convert';

import 'package:backbone/backbone.dart';

import 'package:shelf/shelf.dart';

class EndpointWithoutRequestTarget<ResponseType> implements Endpoint {
  const EndpointWithoutRequestTarget(
    this._function, {
    required bool requiresAuthentication,
    required TokenVerifier tokenVerifier,
  })  : _tokenVerifier = tokenVerifier,
        _requiresAuthentication = requiresAuthentication;

  final EndpointWithoutRequestFunction<ResponseType> _function;
  final TokenVerifier _tokenVerifier;
  final bool _requiresAuthentication;

  @override
  FutureOr<Response> handler(Request request) async {
    final logger = loggerForRequest(request);
    final requestContext = _requiresAuthentication
        ? RequestContextWithUserId(
            logger,
            request,
            await verifyAuthorization(request, _tokenVerifier),
          )
        : RequestContext(logger, request);

    final response = await _function(requestContext);
    final responseJson = jsonEncode(response);

    return Response.ok(
      responseJson,
      headers: const {contentTypeHeader: jsonContentType},
    );
  }
}

typedef EndpointWithoutRequestFunction<ResponseType> = FutureOr<ResponseType>
    Function(
  RequestContext context,
);
