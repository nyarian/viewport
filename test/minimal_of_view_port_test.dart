import 'package:flutter_test/flutter_test.dart';
import 'package:viewport/viewport.dart';

void main() {
  test(
    'assert that minimal of two height values was returned',
    () {
      const subject = MinimalOfViewPort(FixedViewPort(height: 50, width: 50),
          FixedViewPort(height: 40, width: 60));
      expect(subject.height, 40);
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );

  test(
    'assert that minimal of two width values was returned',
    () {
      const subject = MinimalOfViewPort(FixedViewPort(height: 50, width: 50),
          FixedViewPort(height: 40, width: 60));
      expect(subject.width, 50);
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );

  test(
    'assert that aspect ratio corresponds to the ratio of lesser values',
    () {
      const subject = MinimalOfViewPort(FixedViewPort(height: 50, width: 50),
          FixedViewPort(height: 40, width: 60));
      expect(subject.aspectRatio, 50 / 40);
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );
}
