import 'package:args/command_runner.dart';
import 'package:backbone/cli.dart';

class GenerateCommand extends Command<void> {
  GenerateCommand() {
    argParser.addOption(
      'root',
      abbr: 'r',
      help: 'Root directory of the project.',
      defaultsTo: '.',
    );
  }

  @override
  String get description =>
      'Generates backend code for the given openapi spec.';

  @override
  String get name => 'generate';

  @override
  Future<void> run() async {
    final dynamic root = argResults!['root'];
    if (root is! String?) {
      throw ArgumentError.value(root, 'root', 'Must be a string.');
    }
    final rootFolder = root ?? '.';

    final api = await parseApi('$rootFolder/openapi.yaml');
    print('Open API File Parsed');
    await generateApiFiles(
      Api.fromOpenApi(api),
      rootPath: rootFolder,
    );
    print('Backend Code Generated');
  }
}
