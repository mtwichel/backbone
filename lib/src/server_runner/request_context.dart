import 'package:backbone/backbone.dart';
import 'package:shelf/shelf.dart';

class RequestContext {
  const RequestContext({
    required this.logger,
    required this.rawRequest,
    required this.authenticated,
    String? userId,
  }) : _userId = userId;

  final RequestLogger logger;
  final Request rawRequest;
  final bool authenticated;
  final String? _userId;

  String get userId {
    if (authenticated && _userId == null) {
      throw const UnauthenticatedException(
        'User is authenticated but no user id is set',
      );
    } else {
      return _userId!;
    }
  }
}
