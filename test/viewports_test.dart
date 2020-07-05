import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viewport/src/viewport.dart';

void main() {
  group('fixed', () {
    test('assert that returns given width and height', () {
      final subject = const ViewPorts().fixed(height: 55, width: 66);
      expect(subject.height, 55);
      expect(subject.width, 66);
      expect(subject.aspectRatio, 66 / 55);
    });
  });

  group('fromMediaQueryData', () {
    test(
        'assert that all properties are delegated to the MediaQueryData '
        'instance', () {
      final subject = const ViewPorts()
          .fromMediaQueryData(const MediaQueryData(size: Size(77, 888)));
      expect(subject.height, 888);
      expect(subject.width, 77);
      expect(subject.aspectRatio, 77 / 888);
    });
  });

  group('minOf', () {
    final subject = const ViewPorts().minOf(
        const FixedViewPort(height: 44, width: 55),
        const FixedViewPort(height: 66, width: 77));
    test(
      'assert that width returns minimal from two given fixed ports',
      () => expect(subject.width, 55),
    );

    test(
      'assert that height returns minimal from two given fixed ports',
      () => expect(subject.height, 44),
    );

    test(
      'assert that aspect returns a function of min width to min height',
      () => expect(subject.aspectRatio, 55 / 44),
    );
  });

  group('maxOf', () {
    final subject = const ViewPorts().maxOf(
        const FixedViewPort(height: 44, width: 55),
        const FixedViewPort(height: 66, width: 77));
    test(
      'assert that width returns maximal from two given fixed ports',
      () => expect(subject.width, 77),
    );

    test(
      'assert that height returns maximal from two given fixed ports',
      () => expect(subject.height, 66),
    );

    test(
      'assert that aspect returns a function of max width to max height',
      () => expect(subject.aspectRatio, 77 / 66),
    );
  });

  group('upperBounded', () {
    test(
        'assert that upper bound with default args has a semantics of a pure '
        'given viewport as is', () {
      const decorated = FixedViewPort(height: 123321, width: 321123);
      final subject = const ViewPorts().upperBounded(decorated);
      expect(subject.height, decorated.height);
      expect(subject.width, decorated.width);
      expect(subject.aspectRatio, decorated.aspectRatio);
    });

    group('bounds are bigger', () {
      const heightBound = 1000.0;
      const widthBound = 1000.0;
      const decorated = FixedViewPort(height: 888, width: 999);
      final subject = const ViewPorts()
          .upperBounded(decorated, height: heightBound, width: widthBound);

      test('assert that intrinsic height is returned',
          () => expect(subject.height, decorated.height));

      test('assert that intrinsic width is returned',
          () => expect(subject.width, decorated.width));

      test('assert that intrinsic aspect ratio is returned',
          () => expect(subject.aspectRatio, decorated.aspectRatio));
    });

    group('bounds are lesser', () {
      const heightBound = 700.0;
      const widthBound = 800.0;
      const decorated = FixedViewPort(height: 888, width: 999);
      final subject = const ViewPorts()
          .upperBounded(decorated, height: heightBound, width: widthBound);

      test("assert that bound's height is returned",
          () => expect(subject.height, heightBound));

      test("assert that bound's width is returned",
          () => expect(subject.width, widthBound));

      test("assert that bound's aspect ratio is returned",
          () => expect(subject.aspectRatio, widthBound / heightBound));
    });

    group('width is bigger and height is lesser', () {
      const heightBound = 800.0;
      const widthBound = 1000.0;
      const decorated = FixedViewPort(height: 700, width: 1100);
      final subject = const ViewPorts()
          .upperBounded(decorated, height: heightBound, width: widthBound);

      test('assert that intrinsic height is returned',
          () => expect(subject.height, decorated.height));

      test('assert that bound width is returned',
          () => expect(subject.width, widthBound));

      test('assert that expected aspect ratio is returned',
          () => expect(subject.aspectRatio, widthBound / decorated.height));
    });

    group('width is lesser and height is bigger', () {
      const widthBound = 800.0;
      const heightBound = 1000.0;
      const decorated = FixedViewPort(height: 1100, width: 700);
      final subject = const ViewPorts()
          .upperBounded(decorated, height: heightBound, width: widthBound);

      test('assert that bound height is returned',
          () => expect(subject.height, heightBound));

      test('assert that intrinsic width is returned',
          () => expect(subject.width, decorated.width));

      test('assert that expected aspect ratio is returned',
          () => expect(subject.aspectRatio, decorated.width / heightBound));
    });
  });

  group('lowerBounded', () {
    test(
        'assert that lower bound with default args has a semantics of a pure '
        'given viewport as is', () {
      const decorated = FixedViewPort(height: 123321, width: 321123);
      final subject = const ViewPorts().lowerBounded(decorated);
      expect(subject.height, decorated.height);
      expect(subject.width, decorated.width);
      expect(subject.aspectRatio, decorated.aspectRatio);
    });

    group('bounds are bigger', () {
      const heightBound = 1000.0;
      const widthBound = 1100.0;
      const decorated = FixedViewPort(height: 888, width: 999);
      final subject = const ViewPorts()
          .lowerBounded(decorated, height: heightBound, width: widthBound);

      test("assert that bound's height is returned",
          () => expect(subject.height, heightBound));

      test("assert that bound's width is returned",
          () => expect(subject.width, widthBound));

      test("assert that bound's aspect ratio is returned",
          () => expect(subject.aspectRatio, widthBound / heightBound));
    });

    group('bounds are lesser', () {
      const heightBound = 700.0;
      const widthBound = 800.0;
      const decorated = FixedViewPort(height: 888, width: 999);
      final subject = const ViewPorts()
          .lowerBounded(decorated, height: heightBound, width: widthBound);

      test('assert that intrinsic height is returned',
          () => expect(subject.height, 888));

      test('assert that intrinsic width is returned',
          () => expect(subject.width, 999));

      test('assert that intrinsic aspect ratio is returned',
          () => expect(subject.aspectRatio, 999 / 888));
    });

    group('width is bigger and height is lesser', () {
      const heightBound = 800.0;
      const widthBound = 1000.0;
      const decorated = FixedViewPort(height: 700, width: 1100);
      final subject = const ViewPorts()
          .lowerBounded(decorated, height: heightBound, width: widthBound);

      test('assert that bound height is returned',
          () => expect(subject.height, heightBound));

      test('assert that intrinsic width is returned',
          () => expect(subject.width, decorated.width));

      test('assert that expected aspect ratio is returned',
          () => expect(subject.aspectRatio, decorated.width / heightBound));
    });

    group('width is lesser and height is bigger', () {
      const heightBound = 1000.0;
      const widthBound = 800.0;
      const decorated = FixedViewPort(height: 1100, width: 700);
      final subject = const ViewPorts()
          .lowerBounded(decorated, height: heightBound, width: widthBound);

      test('assert that intrinsic height is returned',
          () => expect(subject.height, decorated.height));

      test('assert that bound width is returned',
          () => expect(subject.width, widthBound));

      test('assert that expected aspect ratio is returned',
          () => expect(subject.aspectRatio, widthBound / subject.height));
    });
  });

  group('coerced', () {
    test(
        'assert that default arguments create semantics of the unmodified '
        'instance that should be decorated', () {
      const decorated = FixedViewPort(height: 555, width: 555);
      final subject = const ViewPorts().coerced(decorated);
      expect(subject.height, decorated.height);
      expect(subject.width, decorated.width);
      expect(subject.aspectRatio, decorated.aspectRatio);
    });

    group('actual width is lesser than bound', () {
      const minWidth = 1000.0,
          maxWidth = 2000.0,
          minHeight = 1000.0,
          maxHeight = 2000.0;
      const decorated = FixedViewPort(height: 1500, width: 500);
      final subject = const ViewPorts().coerced(
        decorated,
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      );

      test('width, assert that minimal width is returned',
          () => expect(subject.width, minWidth));

      test('height, assert that origin height is returned',
          () => expect(subject.height, decorated.height));

      test(
          'aspectRatio, assert that function of minimal width to origin height '
          'is returned',
          () => expect(subject.aspectRatio, minWidth / decorated.height));
    });

    group('actual height is lesser than bound', () {
      const minWidth = 1000.0,
          maxWidth = 2000.0,
          minHeight = 1000.0,
          maxHeight = 2000.0;
      const decorated = FixedViewPort(height: 500, width: 1500);
      final subject = const ViewPorts().coerced(
        decorated,
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      );

      test('width, assert that origin width is returned',
          () => expect(subject.width, decorated.width));

      test('height, assert that minimal height is returned',
          () => expect(subject.height, minHeight));

      test(
          'aspectRatio, assert that function of origin width to minimal height '
          'is returned',
          () => expect(subject.aspectRatio, decorated.width / minHeight));
    });

    group('actual width is bigger than bound', () {
      const minWidth = 1000.0,
          maxWidth = 2000.0,
          minHeight = 1000.0,
          maxHeight = 2000.0;
      const decorated = FixedViewPort(height: 1500, width: 2500);
      final subject = const ViewPorts().coerced(
        decorated,
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      );

      test('height, assert that origin height is returned',
          () => expect(subject.height, decorated.height));

      test('width, assert that maximal width is returned',
          () => expect(subject.width, maxWidth));

      test(
          'aspectRatio, assert that function of maximal width to origin height '
          'is returned',
          () => expect(subject.aspectRatio, maxWidth / decorated.height));
    });

    group('actual height is bigger than bound', () {
      const minWidth = 1000.0,
          maxWidth = 2000.0,
          minHeight = 1000.0,
          maxHeight = 2000.0;
      const decorated = FixedViewPort(height: 2500, width: 1500);
      final subject = const ViewPorts().coerced(
        decorated,
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      );

      test('width, assert that origin width is returned',
          () => expect(subject.width, decorated.width));

      test('height, assert that maximal height is returned',
          () => expect(subject.height, maxHeight));

      test(
          'aspectRatio, assert that function of origin width to maximal height '
          'is returned',
          () => expect(subject.aspectRatio, decorated.width / maxHeight));
    });
  });
}
