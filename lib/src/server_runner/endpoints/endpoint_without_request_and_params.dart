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
  final TokenVerifier? _tokenVerifier;
  final bool _requiresAuthentication;

  @override
  FutureOr<Response> handler(Request request) async {
    final params = await toParamsType(request, _fromParams);

    final userId = _requiresAuthentication
        ? await verifyAuthorization(request, _tokenVerifier)
        : null;

    final response = await _function(
      params,
      RequestContext(loggerForRequest(request), request, userId),
    );
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
