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

    final response = await _function(requestContext);
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

typedef EndpointWithoutRequestFunction<ResponseType> = FutureOr<ResponseType>
    Function(
  RequestContext context,
);
