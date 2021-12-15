class UnauthenticatedException implements Exception {
  const UnauthenticatedException(this.message);

  final String? message;
}

class UnauthorizedException implements Exception {
  const UnauthorizedException(this.message);

  final String? message;
}
