import 'package:backbone/backbone.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

class MockLogger extends Mock implements RequestLogger {}

class MockRequest extends Mock implements Request {}

void main() {
  group('RequestContext', () {
    late RequestLogger logger;
    late Request rawRequest;

    setUp(() {
      logger = MockLogger();
      rawRequest = MockRequest();
    });
    group('dependency', () {
      test('returns correctly', () async {
        final context = RequestContext(
          logger: logger,
          rawRequest: rawRequest,
          authenticated: false,
        );

        final stringDep = await context.dependency<String>(() => 'hi');
        expect(stringDep, 'hi');

        final intDep = await context.dependency<int>(() => 1);
        expect(intDep, 1);

        // We expect the string dependency to still be hi since it's
        // already set
        final newStringDep = await context.dependency(() => 'test');
        expect(newStringDep, 'hi');
      });

      test('returns correctly when forcing a reset', () async {
        final context = RequestContext(
          logger: logger,
          rawRequest: rawRequest,
          authenticated: false,
        );

        final stringDep = await context.dependency<String>(() => 'hi');
        expect(stringDep, 'hi');

        // We expect the string dependency to now be test since even
        // though it's already set because we're forcing it to reset
        final newStringDep = await context.dependency(
          () => 'test',
          force: true,
        );
        expect(newStringDep, 'test');
      });
    });

    group('userId', () {
      test('returns correctly if authenticated', () async {
        final context = RequestContext(
          logger: logger,
          rawRequest: rawRequest,
          authenticated: true,
          userId: 'userId',
        );

        expect(context.userId, 'userId');
      });

      test('throws error if unauthenticated', () async {
        final context = RequestContext(
          logger: logger,
          rawRequest: rawRequest,
          authenticated: false,
        );

        expect(() => context.userId, throwsA(isA<Error>()));
      });
    });
  });
}
