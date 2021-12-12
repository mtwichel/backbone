import 'dart:async';
import 'dart:convert';

import 'package:backbone/backbone.dart';

import 'package:shelf/shelf.dart';

class EndpointWithoutRequestTarget<ResponseType> implements Endpoint {
  const EndpointWithoutRequestTarget(this._function);

  final EndpointWithoutRequestFunction<ResponseType> _function;

  @override
  FutureOr<Response> handler(Request request) async {
    final response = await _function(
      RequestContext(loggerForRequest(request), request),
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
