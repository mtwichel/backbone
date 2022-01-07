import 'dart:io';

import 'package:backbone_cli/backbone_cli.dart';
import 'package:mason/mason.dart';
import 'package:process_run/cmd_run.dart';

Future<void> generateApiFiles(
  Api api, {
  String rootPath = '.',
  required bool generateInitial,
}) async {
  print('Generating API Files...');
  final convertedApi = api.toJson();

  if (generateInitial) {
    final initialGenerator =
        await MasonGenerator.fromBundle(initialGeneratorBundle);
    await initialGenerator.generate(
      DirectoryGeneratorTarget(
        Directory(rootPath),
        Logger(),
        FileConflictResolution.overwrite,
      ),
      vars: convertedApi,
    );
  }

  final ongoingGenerator =
      await MasonGenerator.fromBundle(ongoingGeneratorBundle);
  await ongoingGenerator.generate(
    DirectoryGeneratorTarget(
      Directory(rootPath),
      Logger(),
      FileConflictResolution.overwrite,
    ),
    vars: convertedApi,
  );

  await _postGenerate(
    outputPath: rootPath,
  );
}

Future<void> _postGenerate({
  required String outputPath,
}) async {
  print('Formatting...');
  await runCmd(DartCmd(['format', outputPath]));
}
