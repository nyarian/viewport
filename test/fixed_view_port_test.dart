import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:viewport/src/viewport.dart';

void main() {
  test(
    'assert that default constructor with no explicit args given returns '
    'normally',
    () {
      expect(
        () => const FixedViewPort(),
        returnsNormally,
      );
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );

  test(
    'assert that default-args-constructed instance gives infinite height '
    'and width values',
    () {
      const subject = FixedViewPort();
      expect(subject.width, double.infinity);
      expect(subject.height, double.infinity);
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );

  test(
    "assert that default-args-constructed instance's aspect ratio evaluation "
    'throws UnevaluateableAspectRatioError',
    () {
      expect(
        () => const FixedViewPort().aspectRatio,
        throwsA(const TypeMatcher<UnevaluateableAspectRatioError>()),
      );
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );

  test(
    'assert that height negative height if forbidden',
    () {
      expect(
        () => FixedViewPort(height: -1),
        throwsAssertionError,
      );
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );

  test(
    'assert that height negative width if forbidden',
    () {
      expect(
        () => FixedViewPort(width: -1),
        throwsAssertionError,
      );
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );

  test(
    'assert that height is fixed',
    () {
      const givenHeight = 255.0;
      const subject = FixedViewPort(height: givenHeight);
      expect(
        subject.height,
        givenHeight,
      );
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );

  test(
    'assert that width is fixed',
    () {
      const givenWidth = 255.0;
      const subject = FixedViewPort(width: givenWidth);
      expect(
        subject.width,
        givenWidth,
      );
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );

  test(
    'assert that aspect ratio is 1 if width and height are equal',
    () {
      const givenSize = 255.0;
      const subject = FixedViewPort(height: givenSize, width: givenSize);
      expect(
        subject.aspectRatio,
        1.0,
      );
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );
}
