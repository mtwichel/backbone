import 'dart:async';
import 'dart:convert';

import 'package:backbone/backbone.dart';
import 'package:shelf/shelf.dart';

class EndpointWithRequestTarget<RequestType, ResponseType> implements Endpoint {
  const EndpointWithRequestTarget(
    this._function,
    this._fromJson,
  );

  final EndpointWithRequestFunction<RequestType, ResponseType> _function;
  final RequestType Function(Map<String, dynamic> json) _fromJson;

  @override
  FutureOr<Response> handler(Request request) async {
    final argument = await toRequestType(request, _fromJson);
    final response = await _function(
      argument,
      RequestContext(loggerForRequest(request), request),
    );
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
