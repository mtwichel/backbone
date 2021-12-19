# The Backbone Dart Backend Framework

A Dart framework for writing REST APIs from an Open API spec.

---

> NOTE: This framework is very early in its development. Use at your own risk 😎

A huge shoutout to the [mason package](https://pub.dev/packages/mason), the [open_api_forked package](https://pub.dev/packages/open_api_forked) and the [shelf package](https://pub.dev/packages/shelf)! This package uses them heavily in its implementation, and it would be much more challenging to build without them.

## Getting Started

### Installing

1. Make sure you have Dart installed on your computer. If you have Flutter installed, you probably also have Dart installed. You can check by running:

```bash
dart --version
```

If it is not, you can download it [here](https://dart.dev/get-dart). Also, make sure the version is >= `2.12.0`;

2. Install backbone by running

```bash
dart pub global activate backbone
```

### Usage

1. Create a new file called `openapi.yaml`.

2. Define your API using the [Open API Specification](https://swagger.io/specification/#specification), or copy the [example spec](https://github.com/mtwichel/backbone/blob/main/example/openapi.yaml).

3. In the folder your spec resides, run the following command. This will generate a new Backbone project in the current directory.

```bash
backbone generate --new
```

4. When the command finishes, you should see three new folders.

5. As you update the spec, you can run the following command without `--new` to update the API:

```bash
backbone generate
```

> For more options (including what directories you'd like generated code to reside in), run:

```bash
backbone help generate
```

## The Generated Code

The backbone generator looks in your supplied `openapi.yaml` and generates three dart packages for you automatically:

1. The `backend` package. This is the code that will run on the server and server your API.
2. The `functions_objects` package. This contains objects used by the backend and frontend to communicate with each other. You can think of this as the bridge between the frontend and backend.
3. The `fontend_packages/[API_NAME]` package. This is a frontend wrapper around your API so it can be easily called from Flutter code.

The `functions_objects` and `frontend_packages/[API_NAME]` packages are completely generated by the generator, so you will never need to edit them manually.

The `backend` package has a lot of code generated by backbone, but you will still have to write the functionality of your API.

## Writing your API

After initial generation, you should see a file `backend/lib/[API_NAME].dart`. This is where your API endpoint functions will go.

> NOTE: Your functions only need to be exported from this file, not nessesarily written there directly. You can write your functions anywhere in the `backend` package, just make sure they get exported from this file.

The signature of the function you need to write is different depending on if the request contains a body and if there are parameters to the request. Instead of remembering the rules, check out the `backend/functions.md` file. It lists all the functions your API expects to be exposed, and you can copy and paste them from there and into your source code.

### Writing your endpoint functions

#### RequestObject

If your request contains a body, your function will receive an object called `[OPERATION-ID]Request`. This is a simple Dart object that will contain the information passed to the request via the body.

#### RequestParameters

If your request has any parameters defined (from the path, query, or headers), your function will receive an object called `[OPERATION-ID]Parameters`. This is a simple Dart object that will contain the parameters passed into the request.

#### ResponseObject

All requests must return a `200` response, and your functions must return a object of type `[OPERATION-ID]Response`. It can also return a Future of that object instead if you'd like your function to be async.

#### RequestContext

The request context is passed to every function. It currently contains

- `rawRequest`: This is the shelf [Request](https://pub.dev/documentation/shelf/latest/shelf/Request-class.html) object, which contains all data about the request including headers and more.
- `logger`: This is a `RequestLogger` object that can be used to log requests. If running locally, it will print logs out to the console; if running on Google Cloud Run, it will format logs for Cloud Logging. You can use it like this:

```dart
Future<GetPuppiesResponse> getPuppies(RequestContext context) async{
  context.logger.info('Getting puppies');
}
```

- `userId`: This is the id of the user making the request, if any. See [Authentication](#authentication) for more details.
- `dependency<T>()` This can be used to cache depencencies in your backend. See [Dependency Caching](#dependency-caching) for more details.

## Other Topics

### Testing your API

Since each endpoint is simply one function, you can easily unit test it using Dart's [test package](https://pub.dev/packages/test). Simply mock the request and request context (we prefer [mocktail package](https://pub.dev/packages/mocktail) for this, but anything should work).

### Debugging your API

Since your API is just Dart code, you can debug it using the Dart debugging tools you're familiar with.

In fact, if you open to your `backend` package in [Visual Studio Code](https://code.visualstudio.com), in the "Run and Debug" tab, you can start debugging your API by just clicking run.

### Authentication

Backbone supports authentication via JWTs automatically. To use it, you need to do two steps:

1. In you `backend/lib/[API_NAME].dart` folder, implement the function:

```dart
Future<String> verifyToken(String token) async {
  // TODO: implement verifyToken
}
```

It doesn't matter how you implement this function, but it should return a `String?` that contains the userId if the token is valid. If the token is invalid, it should throw an `AuthenticationException`.

2. In your `openapi.yaml` file, add the following to the `components` section:

```yaml
securitySchemes:
  [AUTH_SCHEME_NAME]:
    type: http
    scheme: bearer
    bearerFormat: JWT
```

Then, in each operation, add the following:

```yaml
security:
  - [AUTH_SCHEME_NAME]: []
```

3. When creating your frontend object, pass the `authToken` into the constructor.

## Authorization

You should authorize the users in the functions you write (backbone doesn't support it directly). If a user is not authorized, the function should throw an `AuthorizationException`.

## Dependency Caching

You can use the `RequestContext` object to inject dependencies in your functions.

**Example**

```dart
Future<GetPetsResponse> getPets(RequestContext context) async {
  final db = await context.dependency<FirestoreDatabase>(
    () => createAndInitializeDatabase(),
  );
}
```

All you need to do is call `context.dependency<TYPE>(builder)`. The `builder` is a function that returns your dependency. The trick is, it only re-builds your dependency if it hasn't been built yet. For example

```dart
print(await context.dependency<String>(() => 'test1'));
print(await context.dependency<String>(() => 'test2'));
print(await context.dependency<String>(() => 'test3'));
```

Will print

```
test1
test1
test1
```

because the dependency for type `String` is set once the first time, and ignored the next two times. This is great if you have a database object that is expensive to initialize. You can initialize it once the first time you need it, and then re-use any subsequent times it's needed.

If you would like to force Backbone to reset the dependency, just add the `force: true` option to the function call.

**Example**

```dart
print(await context.dependency<String>(() => 'test1'));
print(await context.dependency<String>(() => 'test2', force: true));
print(await context.dependency<String>(() => 'test3', force: true));
```

Will print

```
test1
test2
test3
```

You can also reset all depencencies in your API by calling `resetDepencencies()`. This is great for testing because you can create a clean-slate environment for your tests.

> Note: While we think it's a great solution to this problem, since it's all just Dart code, you can use whatever pattern you'd like.

### Deploying your API

WIP

## Future Tasks

- [ ] Full support for multipart form data requests
- [ ] Auto-generate Dockerfile for deployment
- [ ] Include a mock request context and mock logger
- [x] Support for dependency injection using the request context
- [x] Support for middleware
- [ ] Nice logging while generator is running
- [x] Support for authentication
