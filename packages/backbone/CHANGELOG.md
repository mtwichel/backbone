## 0.0.1-dev.12

- Added fuction to determine which gcp project you are running in.

## 0.0.1-dev.11

- The backbone package is now a seperate package from the CLI, which can be found at [pub.dev/packages/backbone_cli](https://pub.dev/packages/backbone_cli).

## 0.0.1-dev.10

- **breaking** `verifyToken` function now must include a `RequestContext` parameter. This can be used to get cached dependencies, which is often useful to decoded the JWT.

## 0.0.1-dev.9

- Auto create `Dockerfile` when running `backbone generate --new`
- Add support for middleware
- Add support for dependency caching

## 0.0.1-dev.6

- Make authentication return `userId` as `String` instead of `String?`

## 0.0.1-dev.5

- Added support for authentication via JWT

## 0.0.1-dev.4

- Fixed bug generating param objects

## 0.0.1-dev.3

- Fixed bug with generating json seralizable
- added `--version` flag

## 0.0.1-dev.2

Updated pubspec to make backbone executable

## 0.0.1-dev.1

Initial release!
