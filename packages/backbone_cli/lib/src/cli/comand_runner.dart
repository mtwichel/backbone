import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:backbone_cli/backbone_cli.dart';

class BackendGeneratorCommandRunner extends CommandRunner<void> {
  BackendGeneratorCommandRunner(String executableName, String description)
      : super(executableName, description) {
    argParser.addFlag(
      'version',
      negatable: false,
      help: 'Print the current version.',
    );
  }

  @override
  Future<void> runCommand(ArgResults topLevelResults) async {
    if (topLevelResults['version'] == true) {
      print(packageVersion);
    } else {
      await super.runCommand(topLevelResults);
    }
  }
}
