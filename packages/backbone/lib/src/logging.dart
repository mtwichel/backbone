import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:backbone/backbone.dart';
import 'package:collection/collection.dart';
import 'package:shelf/shelf.dart';
import 'package:stack_trace/stack_trace.dart';

const cloudTraceContextHeader = 'x-cloud-trace-context';

RequestLogger loggerForRequest(Request request) =>
    _requestExpando[request] ?? const _DefaultLogger();

final _requestExpando = Expando<RequestLogger>('request logger expando');

Middleware createLoggingMiddleware(String? projectId) =>
    projectId == null ? _logSimple : cloudLoggingMiddleware(projectId);

/// Logging middleware that "does the right thing" when not hosted on
/// Google Cloud.
Middleware get _logSimple => logRequests().addMiddleware(_handleBadRequest);

/// Wraps [innerHandler], but catches any errors of type [BadRequestException].
///
/// Error details are written to [stderr] and a corresponding error [Response]
/// is returned.
Handler _handleBadRequest(Handler innerHandler) => (request) async {
      try {
        final response = await innerHandler(request);
        return response;
      } on BadRequestException catch (error, stack) {
        stderr.writeln(
          error.errorMessage(
            request.requestedUri,
            request.method,
            stack,
          ),
        );

        return _fromBadRequestException(error);
      }
    };

Response _fromBadRequestException(BadRequestException e) => Response(
      e.statusCode,
      body: '{"message": "${e.message}"}',
      headers: {
        'Content-Type': 'application/json',
      },
      context: {
        'bad_request_exception': e,
      },
    );

/// Return [Middleware] that logs errors using Google Cloud structured logs and
/// returns the correct response.
Middleware cloudLoggingMiddleware(String projectId) {
  Handler hostedLoggingMiddleware(Handler innerHandler) => (request) async {
        // Add log correlation to nest all log messages beneath request log in
        // Log Viewer.

        String? traceValue;

        final traceHeader = request.headers[cloudTraceContextHeader];
        if (traceHeader != null) {
          traceValue =
              'projects/$projectId/traces/${traceHeader.split('/')[0]}';
        }

        String createErrorLogEntry(
          Object error,
          StackTrace? stackTrace,
          LogSeverity logSeverity, {
          bool Function(Frame)? predicate,
        }) {
          // Collect and format error information as described here
          // https://cloud.google.com/functions/docs/monitoring/logging#writing_structured_logs

          final chain = stackTrace == null
              ? Chain.current()
              : Chain.forTrace(stackTrace).foldFrames(
                  predicate ??
                      (f) =>
                          f.package == 'functions_framework' ||
                          f.package == 'shelf',
                  terse: true,
                );

          final stackFrame = _frameFromChain(chain);

          return _createLogEntry(
            traceValue,
            '$error\n$chain'.trim(),
            logSeverity,
            stackFrame: stackFrame,
          );
        }

        final completer = Completer<Response>.sync();

        final currentZone = Zone.current;

        Zone.current
            .fork(
          specification: ZoneSpecification(
            handleUncaughtError: (self, parent, zone, error, stackTrace) {
              if (error is HijackException) {
                completer.completeError(error, stackTrace);
              }

              final logContentString = error is BadRequestException
                  ? createErrorLogEntry(
                      'Bad request. ${error.message}',
                      error.innerStack ?? stackTrace,
                      LogSeverity.warning,
                      predicate: (f) => f.package == 'shelf',
                    )
                  : createErrorLogEntry(
                      error,
                      stackTrace,
                      LogSeverity.error,
                    );

              // Serialize to a JSON string and output.
              parent.print(self, logContentString);

              if (completer.isCompleted) {
                return;
              }

              final response = error is BadRequestException
                  ? _fromBadRequestException(error)
                  : Response.internalServerError();

              completer.complete(response);
            },
            print: (self, parent, zone, line) {
              final logContent = _createLogEntry(
                traceValue,
                line,
                LogSeverity.info,
              );

              // Serialize to a JSON string and output to parent zone.
              parent.print(self, logContent);
            },
          ),
        )
            .runGuarded(
          () async {
            _requestExpando[request] = _CloudLogger(currentZone, traceValue);
            final response = await innerHandler(request);
            if (!completer.isCompleted) {
              completer.complete(response);
            }
          },
        );

        return completer.future;
      };

  return hostedLoggingMiddleware;
}

/// Returns a [Frame] from [chain] if possible, otherwise, `null`.
Frame? _frameFromChain(Chain? chain) {
  if (chain == null || chain.traces.isEmpty) return null;

  final trace = chain.traces.first;
  if (trace.frames.isEmpty) return null;

  // Try to exclude frames in `package:json_annotation`
  // These are likely the checked-yaml logic, which isn't helpful for debugging
  final frame = trace.frames.firstWhereOrNull(
    (element) => element.package != 'json_annotation',
  );

  return frame ?? trace.frames.first;
}

Map<String, dynamic> _sourceLocation(Frame frame) => <String, String?>{
      'file': frame.library,
      if (frame.line != null) 'line': frame.line.toString(),
      'function': frame.member,
    };

/// A [RequestLogger] that prints messages normally.
///
/// Any message that's not [LogSeverity.defaultSeverity] is prefixed by the
/// [LogSeverity] name.
class _DefaultLogger extends RequestLogger {
  const _DefaultLogger();

  @override
  void log(Object message, LogSeverity severity) {
    if (severity == LogSeverity.defaultSeverity) {
      print(message);
    } else {
      print('${severity.name}: $message');
    }
  }
}

/// A [RequestLogger] that prints messages using Google Cloud structured
/// logging.
class _CloudLogger extends RequestLogger {
  _CloudLogger(this._zone, this._traceId);
  final Zone _zone;
  final String? _traceId;

  @override
  void log(Object message, LogSeverity severity) =>
      _zone.print(_createLogEntry(_traceId, '$message', severity));
}

String _createLogEntry(
  String? traceValue,
  String message,
  LogSeverity severity, {
  Frame? stackFrame,
}) {
  // https://cloud.google.com/logging/docs/agent/logging/configuration#special-fields
  final logContent = {
    'message': message,
    'severity': severity,
    // 'logging.googleapis.com/labels': { }
    if (traceValue != null) 'logging.googleapis.com/trace': traceValue,
    if (stackFrame != null)
      'logging.googleapis.com/sourceLocation': _sourceLocation(stackFrame),
  };
  return jsonEncode(logContent);
}

abstract class RequestLogger {
  const RequestLogger();

  void log(Object message, LogSeverity severity);

  void debug(Object message) => log(message, LogSeverity.debug);

  void info(Object message) => log(message, LogSeverity.info);

  void notice(Object message) => log(message, LogSeverity.notice);

  void warning(Object message) => log(message, LogSeverity.warning);

  void error(Object message) => log(message, LogSeverity.error);

  void critical(Object message) => log(message, LogSeverity.critical);

  void alert(Object message) => log(message, LogSeverity.alert);

  void emergency(Object message) => log(message, LogSeverity.emergency);
}
