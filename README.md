# The Backbone Dart Backend Framework

A Dart framework for writing REST APIs from an Open API spec.

| Package                                                                              | Pub                                                                                                    |
| ------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| [backbone](https://github.com/mtwichel/backbone/tree/main/packages/backbone)         | [![pub package](https://img.shields.io/pub/v/backbone.svg)](https://pub.dev/packages/backbone)         |
| [backbone_cli](https://github.com/mtwichel/backbone/tree/main/packages/backbone_cli) | [![pub package](https://img.shields.io/pub/v/backbone_cli.svg)](https://pub.dev/packages/backbone_cli) |

## Quick Start

```bash
# Activate from pub.dev
dart pub global activate backbone_cli
```

```bash
# Download example API spec
curl https://raw.githubusercontent.com/mtwichel/backbone/main/example/openapi.yaml --output openapi.yaml
```

```bash
# Generate the API
backbone generate --new
```

You can read the full documentation [here](https://github.com/mtwichel/backbone/tree/main/packages/backbone_cli)
