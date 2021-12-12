import 'package:args/command_runner.dart';
import 'package:backbone/cli.dart';

class NewCommand extends Command<void> {
  NewCommand() {
    argParser.addOption(
      'root',
      abbr: 'r',
      help: 'Root directory of the project.',
      defaultsTo: '.',
    );
  }
  @override
  String get description => 'Creates a new backend project.';

  @override
  String get name => 'new';

  @override
  Future<void> run() async {
    final dynamic root = argResults!['root'];
    if (root is! String?) {
      throw ArgumentError.value(root, 'root', 'Must be a string.');
    }
    final rootFolder = root ?? '.';

    final api = await parseApi('$rootFolder/openapi.yaml');
    print('Open API File Parsed');
    await initialGenerateApiFiles(
      Api.fromOpenApi(api),
      rootPath: rootFolder,
    );
    print('Backend Code Generated');
  }
}
