import 'dart:io';

import 'package:backbone/cli.dart';
import 'package:mason/mason.dart';
import 'package:process_run/cmd_run.dart';

Future<void> generateApiFiles(
  Api api, {
  String rootPath = '.',
}) async {
  print('Generating API Files...');
  final generator = await MasonGenerator.fromBundle(ongoingGeneratorBundle);
  final convertedApi = api.toJson();
  await generator.generate(
    DirectoryGeneratorTarget(
      Directory(rootPath),
      Logger(),
      FileConflictResolution.overwrite,
    ),
    vars: convertedApi,
  );

  await _postGenerate(rootPath);
}

Future<void> initialGenerateApiFiles(
  Api api, {
  String rootPath = '.',
}) async {
  final initialGenerator =
      await MasonGenerator.fromBundle(initialGeneratorBundle);
  final ongoingGenerator =
      await MasonGenerator.fromBundle(ongoingGeneratorBundle);
  final convertedApi = api.toJson();
  await initialGenerator.generate(
    DirectoryGeneratorTarget(
      Directory(rootPath),
      Logger(),
      FileConflictResolution.overwrite,
    ),
    vars: convertedApi,
  );
  await ongoingGenerator.generate(
    DirectoryGeneratorTarget(
      Directory(rootPath),
      Logger(),
      FileConflictResolution.overwrite,
    ),
    vars: convertedApi,
  );

  await _postGenerate(rootPath);
}

Future<void> _postGenerate(String rootPath) async {
  print('Formatting...');
  await runCmd(DartCmd(['format', rootPath]));
  print('Getting Depenencies...');
  await runCmd(
    DartCmd(
      [
        'pub',
        'get',
        '--directory',
        'functions_objects',
        '--directory',
        '$rootPath/functions_objects'
      ],
    ),
  );
  print('Building JSON Parsers...');
  await runExecutableArguments(
    'dart',
    [
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ],
    workingDirectory: '$rootPath/functions_objects',
  );
}
