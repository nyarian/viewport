import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viewport/src/viewport.dart';

void main() {
  test(
    'assert that height retrieval is delegated to the MediaQueryData',
    () {
      const givenData = MediaQueryData(size: Size(0, 155.0));
      const subject = MediaQuerySizeViewPort(givenData);
      expect(
        subject.height,
        givenData.size.height,
      );
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );

  test(
    'assert that width retrieval is delegated to the MediaQueryData',
    () {
      const givenData = MediaQueryData(size: Size(155.0, 0));
      const subject = MediaQuerySizeViewPort(givenData);
      expect(
        subject.width,
        givenData.size.width,
      );
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );

  test(
    'assert that aspect ratio retrieval is delegated to the MediaQueryData',
    () {
      const givenData = MediaQueryData(size: Size(155.0, 123.0));
      const subject = MediaQuerySizeViewPort(givenData);
      expect(
        subject.aspectRatio,
        givenData.size.aspectRatio,
      );
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );
}
