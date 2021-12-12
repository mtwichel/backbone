import 'package:backbone/backbone.dart';
import 'package:shelf/shelf.dart';

class RequestContext {
  const RequestContext(this.logger, this.rawRequest);
  final RequestLogger logger;
  final Request rawRequest;
}
