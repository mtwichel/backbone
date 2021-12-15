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
  final TokenVerifier? _tokenVerifier;
  final bool _requiresAuthentication;

  @override
  FutureOr<Response> handler(Request request) async {
    final userId = _requiresAuthentication
        ? await verifyAuthorization(request, _tokenVerifier)
        : null;

    final response = await _function(
      RequestContext(loggerForRequest(request), request, userId),
    );
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
