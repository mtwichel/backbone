import 'dart:async';

import 'package:backbone/backbone.dart';
import 'package:shelf/shelf.dart';

class RequestContext {
  RequestContext({
    required this.logger,
    required this.rawRequest,
    required this.authenticated,
    String? userId,
  }) : _userId = userId;

  final RequestLogger logger;
  final Request rawRequest;
  final bool authenticated;
  final String? _userId;

  final Map<String, dynamic> _dependencies = <String, dynamic>{};

  String get userId {
    if (authenticated && _userId == null) {
      throw const UnauthenticatedException(
        'User is authenticated but no user id is set',
      );
    } else {
      return _userId!;
    }
  }

  Future<T> dependency<T>(
    FutureOr<T> Function() builder, {
    bool force = false,
  }) async {
    final key = T.toString();
    if (!force && _dependencies.containsKey(key)) {
      return _dependencies[key] as T;
    } else {
      final value = await builder();
      _dependencies[key] = value;
      return value;
    }
  }
}
