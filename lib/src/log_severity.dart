import 'package:equatable/equatable.dart';

class LogSeverity extends Equatable {
  const LogSeverity._(this.value, this.name);
  static const defaultSeverity = LogSeverity._(0, 'DEFAULT');
  static const debug = LogSeverity._(100, 'DEBUG');
  static const info = LogSeverity._(200, 'INFO');
  static const notice = LogSeverity._(300, 'NOTICE');
  static const warning = LogSeverity._(400, 'WARNING');
  static const error = LogSeverity._(500, 'ERROR');
  static const critical = LogSeverity._(600, 'CRITICAL');
  static const alert = LogSeverity._(700, 'ALERT');
  static const emergency = LogSeverity._(800, 'EMERGENCY');

  final int value;
  final String name;

  String toJson() => name;

  @override
  List<Object> get props => [value, name];
}
