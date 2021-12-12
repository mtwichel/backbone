import 'package:stack_trace/stack_trace.dart';

class BadRequestException implements Exception {
  final int statusCode;
  final String message;
  final Object? innerError;
  final StackTrace? innerStack;

  BadRequestException(
    this.statusCode,
    this.message, {
    this.innerError,
    this.innerStack,
  }) : assert(message.isNotEmpty) {
    if (statusCode < 400 || statusCode > 499) {
      throw ArgumentError.value(
        statusCode,
        'statusCode',
        'Must be between 400 and 499',
      );
    }
  }

  @override
  String toString() => '$message ($statusCode)';

  String errorMessage(Uri requestedUri, String method, StackTrace stack) {
    final buffer = StringBuffer()
      ..writeln('[BAD REQUEST] $method\t'
          '${requestedUri.path}${_formatQuery(requestedUri.query)}')
      ..writeln(this);

    if (innerError != null) {
      buffer.writeln('$innerError'.trim());
    }

    final chain = Chain.forTrace(innerStack ?? stack)
        .foldFrames((frame) =>
            frame.isCore ||
            frame.package == 'shelf' ||
            frame.package == 'functions_framework')
        .terse;

    buffer.write('$chain'.trim());

    return buffer.toString();
  }
}
String _formatQuery(String query) => query == '' ? '' : '?$query';
