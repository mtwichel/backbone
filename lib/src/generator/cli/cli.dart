import 'package:args/command_runner.dart';
import 'package:backbone/cli.dart';

export 'commands/commands.dart';

Future<void> runCli(List<String> args) async {
  final runner = CommandRunner<void>(
    'main.dart',
    'A command line interface for generating Dart backends.',
  )
    ..addCommand(GenerateCommand())
    ..addCommand(NewCommand());

  await runner.run(args);
}
