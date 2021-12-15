import 'dart:async';
import 'dart:convert';

import 'package:backbone/backbone.dart';
import 'package:shelf/shelf.dart';

class EndpointWithoutRequestAndParamsTarget<ResponseType, ParamsType>
    implements Endpoint {
  const EndpointWithoutRequestAndParamsTarget(
    this._function,
    this._fromParams,
  );

  final EndpointWithoutRequestAndParamsFunction<ResponseType, ParamsType>
      _function;
  final ParamsType Function(Map<String, dynamic> params) _fromParams;

  @override
  FutureOr<Response> handler(Request request) async {
    final params = await toParamsType(request, _fromParams);
    final response = await _function(
      params,
      RequestContext(loggerForRequest(request), request),
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
