import 'dart:io';

import 'package:open_api_forked/v3.dart';
import 'package:yaml/yaml.dart';

Future<APIDocument> parseApi(String path) async {
  final file = File(path);
  final dynamic contents = loadYaml(await file.readAsString());

  if (contents is! YamlMap) {
    throw Exception('Yaml Parsing Error');
  }
  return APIDocument.fromMap(Map<String, dynamic>.from(contents.toMap()));
}

extension on YamlMap {
  dynamic _convertNode(dynamic v) {
    if (v is YamlMap) {
      return v.toMap();
    } else if (v is YamlList) {
      final list = <dynamic>[];
      for (final e in v) {
        list.add(_convertNode(e));
      }
      return list;
    } else {
      return v;
    }
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    nodes.forEach((dynamic k, v) {
      map[(k as YamlScalar).value.toString()] = _convertNode(v.value);
    });
    return map;
  }
}
