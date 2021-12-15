import 'package:args/command_runner.dart';
import 'package:backbone/cli.dart';

class GenerateCommand extends Command<void> {
  GenerateCommand() {
    argParser
      ..addOption(
        'output',
        abbr: 'o',
        help: 'Root directory the generated files will be written to.',
        defaultsTo: '.',
      )
      ..addOption(
        'input',
        abbr: 'i',
        help: 'Path to the open api spec file.',
        defaultsTo: 'openapi.yaml',
      )
      ..addOption(
        'backend-name',
        help: 'Name of the folder the backend api will be generated.',
        defaultsTo: 'backend',
      )
      ..addFlag(
        'new',
        abbr: 'n',
        help: 'Generate new brand new files.',
        negatable: false,
      );
  }

  @override
  String get description =>
      'Generates backend code for the given openapi spec.';

  @override
  String get name => 'generate';

  @override
  Future<void> run() async {
    final dynamic root = argResults!['output'];
    final dynamic input = argResults!['input'];
    final dynamic backendName = argResults!['backend-name'];
    final dynamic newFiles = argResults!['new'];

    if (root is! String) {
      throw ArgumentError.value(root, 'output', 'Must be a string.');
    }
    if (input is! String) {
      throw ArgumentError.value(input, 'input', 'Must be a string.');
    }
    if (backendName is! String) {
      throw ArgumentError.value(
        backendName,
        'backend-name',
        'Must be a string.',
      );
    }
    if (newFiles is! bool) {
      throw ArgumentError.value(newFiles, 'new', 'Must be a bool.');
    }

    final api = await parseApi(input);
    print('Open API File Parsed');
    await generateApiFiles(
      Api.fromOpenApi(
        api,
        backendName: backendName,
      ),
      rootPath: root,
      generateInitial: newFiles,
    );

    print('Backend Code Generated');
  }
}
