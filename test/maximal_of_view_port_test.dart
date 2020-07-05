import 'package:flutter_test/flutter_test.dart';
import 'package:viewport/viewport.dart';

void main() {
  test(
    'assert that null as a first viewport is forbidden',
    () {
      expect(
        () => MaximalOfViewPort(null, const FixedViewPort()),
        throwsAssertionError,
      );
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );

  test(
    'assert that null as a second viewport is forbidden',
    () {
      expect(
        () => MaximalOfViewPort(const FixedViewPort(), null),
        throwsAssertionError,
      );
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );

  test(
    'assert that maximal of two height values was returned',
    () {
      const subject = MaximalOfViewPort(FixedViewPort(height: 50, width: 50),
          FixedViewPort(height: 40, width: 60));
      expect(subject.height, 50);
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );

  test(
    'assert that maximal of two width values was returned',
    () {
      const subject = MaximalOfViewPort(FixedViewPort(height: 50, width: 50),
          FixedViewPort(height: 40, width: 60));
      expect(subject.width, 60);
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );

  test(
    'assert that aspect ratio corresponds to the ratio of bigger values',
    () {
      const subject = MaximalOfViewPort(FixedViewPort(height: 50, width: 50),
          FixedViewPort(height: 40, width: 60));
      expect(subject.aspectRatio, 60 / 50);
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );
}
