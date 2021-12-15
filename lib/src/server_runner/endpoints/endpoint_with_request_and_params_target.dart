import 'dart:async';
import 'dart:convert';

import 'package:backbone/backbone.dart';
import 'package:shelf/shelf.dart';

class EndpointWithRequestAndParamsTarget<RequestType, ResponseType, ParamsType>
    implements Endpoint {
  const EndpointWithRequestAndParamsTarget(
    this._function,
    this._fromJson,
    this._fromParams,
  );

  final EndpointWithRequestAndParamsFunction<RequestType, ResponseType,
      ParamsType> _function;
  final RequestType Function(Map<String, dynamic> json) _fromJson;
  final ParamsType Function(Map<String, dynamic> params) _fromParams;

  @override
  FutureOr<Response> handler(Request request) async {
    final argument = await toRequestType(request, _fromJson);
    final params = await toParamsType(request, _fromParams);
    final response = await _function(
      argument,
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

typedef EndpointWithRequestAndParamsFunction<RequestType, ResponseType,
        ParamsType>
    = FutureOr<ResponseType> Function(
  RequestType request,
  ParamsType params,
  RequestContext context,
);
