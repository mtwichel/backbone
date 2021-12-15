import 'package:backbone/backbone.dart';
import 'package:shelf/shelf.dart';

Middleware authenticationMiddleware() {
  return (innerHandler) {
    return (request) async {
      try {
        return await innerHandler(request);
      } on UnauthenticatedException catch (e) {
        throw BadRequestException(401, e.message ?? 'Unauthenticated');
      } on UnauthorizedException catch (e) {
        throw BadRequestException(403, e.message ?? 'Unauthorized');
      }
    };
  };
}
