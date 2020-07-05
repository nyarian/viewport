import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' as matcher;
import 'package:viewport/viewport.dart';

// ignore_for_file: avoid_as
void main() {
  testWidgets(
      'assert that FlutterError was thrown if no viewport parent exists in the '
      'tree', (WidgetTester tester) async {
    await tester.pumpWidget(const SizedWidget());
    expect(tester.takeException(), const matcher.TypeMatcher<FlutterError>());
  });

  group('fixed', () {
    const givenHeight = 500.0;
    const givenWidth = 600.0;

    testWidgets("sizedbox's width is equals to the fixed viewport's width",
        (WidgetTester tester) async {
      await tester.pumpWidget(ViewPortWidget.fixed(
        height: givenHeight,
        width: givenWidth,
        child: const SizedWidget(),
      ));
      final SizedBox widget =
          find.byType(SizedBox).evaluate().single.widget as SizedBox;
      expect(widget.width, givenWidth);
    });

    testWidgets("sizedbox's height is equals to the fixed viewport's width",
        (WidgetTester tester) async {
      await tester.pumpWidget(ViewPortWidget.fixed(
        height: givenHeight,
        width: givenWidth,
        child: const SizedWidget(),
      ));
      final SizedBox widget =
          find.byType(SizedBox).evaluate().single.widget as SizedBox;
      expect(widget.height, givenHeight);
    });
  });

  group('mediaQuery', () {
    const MediaQueryData givenData = MediaQueryData(size: Size(666.6, 999.9));

    testWidgets("assert that viewport's width is equal to mediaquery's width",
        (WidgetTester tester) async {
      await tester.pumpWidget(const MediaQuery(
        data: givenData,
        child: ViewPortWidget.mediaQuery(
          child: SizedWidget(),
        ),
      ));
      final SizedBox widget =
          find.byType(SizedBox).evaluate().single.widget as SizedBox;
      expect(widget.width, givenData.size.width);
    });

    testWidgets("assert that viewport's height is equal to mediaquery's width",
        (WidgetTester tester) async {
      await tester.pumpWidget(const MediaQuery(
        data: givenData,
        child: ViewPortWidget.mediaQuery(
          child: SizedWidget(),
        ),
      ));
      final SizedBox widget =
          find.byType(SizedBox).evaluate().single.widget as SizedBox;
      expect(widget.height, givenData.size.height);
    });
  });

  group('upperBoundedMediaQuery', () {
    group('less than boundary', () {
      const boundedHeight = 1000.0;
      const boundedWidth = 1000.0;
      const givenData = MediaQueryData(size: Size(900, 900));

      testWidgets("assert that resulting width is equal to mediaquery's one",
          (WidgetTester tester) async {
        await tester.pumpWidget(MediaQuery(
          data: givenData,
          child: ViewPortWidget.upperBoundedMediaQuery(
            maxHeight: boundedHeight,
            maxWidth: boundedWidth,
            child: const SizedWidget(),
          ),
        ));
        final SizedBox widget =
            find.byType(SizedBox).evaluate().single.widget as SizedBox;
        expect(widget.width, givenData.size.width);
      });

      testWidgets("assert that resulting height is equal to mediaquery's one",
          (WidgetTester tester) async {
        await tester.pumpWidget(MediaQuery(
          data: givenData,
          child: ViewPortWidget.upperBoundedMediaQuery(
            maxHeight: boundedHeight,
            maxWidth: boundedWidth,
            child: const SizedWidget(),
          ),
        ));
        final SizedBox widget =
            find.byType(SizedBox).evaluate().single.widget as SizedBox;
        expect(widget.height, givenData.size.height);
      });
    });

    group('more than boundary', () {
      const boundedHeight = 800.0;
      const boundedWidth = 800.0;
      const givenData = MediaQueryData(size: Size(900, 900));

      testWidgets("assert that resulting width is equal to bound's one",
          (WidgetTester tester) async {
        await tester.pumpWidget(MediaQuery(
          data: givenData,
          child: ViewPortWidget.upperBoundedMediaQuery(
            maxHeight: boundedHeight,
            maxWidth: boundedWidth,
            child: const SizedWidget(),
          ),
        ));
        final SizedBox widget =
            find.byType(SizedBox).evaluate().single.widget as SizedBox;
        expect(widget.width, boundedWidth);
      });

      testWidgets("assert that resulting height is equal to bound's one",
          (WidgetTester tester) async {
        await tester.pumpWidget(MediaQuery(
          data: givenData,
          child: ViewPortWidget.upperBoundedMediaQuery(
            maxHeight: boundedHeight,
            maxWidth: boundedWidth,
            child: const SizedWidget(),
          ),
        ));
        final SizedBox widget =
            find.byType(SizedBox).evaluate().single.widget as SizedBox;
        expect(widget.height, boundedHeight);
      });
    });
  });

  group('lowerBoundedMediaQuery', () {
    group('less than boundary', () {
      const boundedHeight = 1000.0;
      const boundedWidth = 1000.0;
      const givenData = MediaQueryData(size: Size(900, 900));

      testWidgets("assert that resulting width is equal to bound's one",
          (WidgetTester tester) async {
        await tester.pumpWidget(MediaQuery(
          data: givenData,
          child: ViewPortWidget.lowerBoundedMediaQuery(
            minHeight: boundedHeight,
            minWidth: boundedWidth,
            child: const SizedWidget(),
          ),
        ));
        final SizedBox widget =
            find.byType(SizedBox).evaluate().single.widget as SizedBox;
        expect(widget.width, boundedWidth);
      });

      testWidgets("assert that resulting height is equal to bound's one",
          (WidgetTester tester) async {
        await tester.pumpWidget(MediaQuery(
          data: givenData,
          child: ViewPortWidget.lowerBoundedMediaQuery(
            minHeight: boundedHeight,
            minWidth: boundedWidth,
            child: const SizedWidget(),
          ),
        ));
        final SizedBox widget =
            find.byType(SizedBox).evaluate().single.widget as SizedBox;
        expect(widget.height, boundedHeight);
      });
    });

    group('more than boundary', () {
      const boundedHeight = 800.0;
      const boundedWidth = 800.0;
      const givenData = MediaQueryData(size: Size(900, 900));

      testWidgets("assert that resulting width is equal to mediaquery's one",
          (WidgetTester tester) async {
        await tester.pumpWidget(MediaQuery(
          data: givenData,
          child: ViewPortWidget.lowerBoundedMediaQuery(
            minHeight: boundedHeight,
            minWidth: boundedWidth,
            child: const SizedWidget(),
          ),
        ));
        final SizedBox widget =
            find.byType(SizedBox).evaluate().single.widget as SizedBox;
        expect(widget.width, givenData.size.width);
      });

      testWidgets("assert that resulting height is equal to mediaquery's one",
          (WidgetTester tester) async {
        await tester.pumpWidget(MediaQuery(
          data: givenData,
          child: ViewPortWidget.lowerBoundedMediaQuery(
            minHeight: boundedHeight,
            minWidth: boundedWidth,
            child: const SizedWidget(),
          ),
        ));
        final SizedBox widget =
            find.byType(SizedBox).evaluate().single.widget as SizedBox;
        expect(widget.height, givenData.size.height);
      });
    });
  });

  group('coercedMediaQuery', () {
    test(
        'assert that assertion error is thrown if maxHeight is less than '
        'minHeight', () {
      expect(
          () => ViewPortWidget.coercedMediaQuery(
                minHeight: 400,
                maxHeight: 200,
                child: const SizedWidget(),
              ),
          throwsAssertionError);
    });

    test(
        'assert that assertion error is thrown if maxWidth is less than '
        'minWidth', () {
      expect(
          () => ViewPortWidget.coercedMediaQuery(
                minWidth: 400,
                maxWidth: 200,
                child: const SizedWidget(),
              ),
          throwsAssertionError);
    });

    group('less than boundary', () {
      const minHeight = 1000.0;
      const minWidth = 1000.0;
      const maxHeight = 2000.0;
      const maxWidth = 2000.0;
      const givenData = MediaQueryData(size: Size(900, 900));

      testWidgets("assert that resulting width is equal to lower bound's one",
          (WidgetTester tester) async {
        await tester.pumpWidget(MediaQuery(
          data: givenData,
          child: ViewPortWidget.coercedMediaQuery(
            minHeight: minHeight,
            minWidth: minWidth,
            maxHeight: maxHeight,
            maxWidth: maxWidth,
            child: const SizedWidget(),
          ),
        ));
        final SizedBox widget =
            find.byType(SizedBox).evaluate().single.widget as SizedBox;
        expect(widget.width, minWidth);
      });

      testWidgets("assert that resulting height is equal to lower bound's one",
          (WidgetTester tester) async {
        await tester.pumpWidget(MediaQuery(
          data: givenData,
          child: ViewPortWidget.coercedMediaQuery(
            minHeight: minHeight,
            minWidth: minWidth,
            maxHeight: maxHeight,
            maxWidth: maxWidth,
            child: const SizedWidget(),
          ),
        ));
        final SizedBox widget =
            find.byType(SizedBox).evaluate().single.widget as SizedBox;
        expect(widget.height, minHeight);
      });
    });

    group('inside the bounds', () {
      const minHeight = 1000.0;
      const minWidth = 1000.0;
      const maxHeight = 2000.0;
      const maxWidth = 2000.0;
      const givenData = MediaQueryData(size: Size(1500, 1500));

      testWidgets("assert that resulting width is equal to mediaquery's one",
          (WidgetTester tester) async {
        await tester.pumpWidget(MediaQuery(
          data: givenData,
          child: ViewPortWidget.coercedMediaQuery(
            minHeight: minHeight,
            minWidth: minWidth,
            maxHeight: maxHeight,
            maxWidth: maxWidth,
            child: const SizedWidget(),
          ),
        ));
        final SizedBox widget =
            find.byType(SizedBox).evaluate().single.widget as SizedBox;
        expect(widget.width, givenData.size.width);
      });

      testWidgets("assert that resulting height is equal to mediaquery's one",
          (WidgetTester tester) async {
        await tester.pumpWidget(MediaQuery(
          data: givenData,
          child: ViewPortWidget.coercedMediaQuery(
            minHeight: minHeight,
            minWidth: minWidth,
            maxHeight: maxHeight,
            maxWidth: maxWidth,
            child: const SizedWidget(),
          ),
        ));
        final SizedBox widget =
            find.byType(SizedBox).evaluate().single.widget as SizedBox;
        expect(widget.height, givenData.size.height);
      });
    });

    group('more than boundary', () {
      const minHeight = 1000.0;
      const minWidth = 1000.0;
      const maxHeight = 2000.0;
      const maxWidth = 2000.0;
      const givenData = MediaQueryData(size: Size(2100, 2100));

      testWidgets("assert that resulting width is equal to upper bound's one",
          (WidgetTester tester) async {
        await tester.pumpWidget(MediaQuery(
          data: givenData,
          child: ViewPortWidget.coercedMediaQuery(
            minHeight: minHeight,
            minWidth: minWidth,
            maxHeight: maxHeight,
            maxWidth: maxWidth,
            child: const SizedWidget(),
          ),
        ));
        final SizedBox widget =
            find.byType(SizedBox).evaluate().single.widget as SizedBox;
        expect(widget.width, maxWidth);
      });

      testWidgets("assert that resulting height is equal to upper bound's one",
          (WidgetTester tester) async {
        await tester.pumpWidget(MediaQuery(
          data: givenData,
          child: ViewPortWidget.coercedMediaQuery(
            minHeight: minHeight,
            minWidth: minWidth,
            maxHeight: maxHeight,
            maxWidth: maxWidth,
            child: const SizedWidget(),
          ),
        ));
        final SizedBox widget =
            find.byType(SizedBox).evaluate().single.widget as SizedBox;
        expect(widget.height, maxHeight);
      });
    });
  });
}

class SizedWidget extends StatelessWidget {
  const SizedWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: ViewPort.of(context).width,
        height: ViewPort.of(context).height,
      );
}
