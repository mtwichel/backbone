import 'package:backbone/cli.dart';

export 'comand_runner.dart';
export 'commands/commands.dart';

Future<void> runCli(List<String> args) async {
  final runner = BackendGeneratorCommandRunner(
    'main.dart',
    'A command line interface for generating Dart backends.',
  )..addCommand(GenerateCommand());

  await runner.run(args);
}
