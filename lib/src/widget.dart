import 'package:flutter/widgets.dart';
import 'package:viewport/viewport.dart';

@immutable
class ViewPortWidget extends InheritedWidget {
  final WidgetViewPortFactory factory;

  const ViewPortWidget({
    @required this.factory,
    @required Widget child,
    Key key,
  })  : assert(
            factory != null,
            'Factory is necessary to define the actual '
            'ViewPort that will be used'),
        assert(child != null, 'Child reference must not be null'),
        super(key: key, child: child);

  ViewPortWidget.fixed({
    @required Widget child,
    double height = double.infinity,
    double width = double.infinity,
    Key key,
  }) : this(
          factory: FixedViewPortFactory(
            height: height,
            width: width,
          ),
          child: child,
          key: key,
        );

  const ViewPortWidget.mediaQuery({
    @required Widget child,
    Key key,
  }) : this(
          factory: const MediaQueryViewPortFactory(),
          child: child,
          key: key,
        );

  ViewPortWidget.upperBoundedMediaQuery({
    @required Widget child,
    double maxHeight = double.infinity,
    double maxWidth = double.infinity,
    Key key,
  }) : this(
          factory: UpperBoundedViewPortFactory(
            const MediaQueryViewPortFactory(),
            maxHeight: maxHeight,
            maxWidth: maxWidth,
          ),
          child: child,
          key: key,
        );

  ViewPortWidget.lowerBoundedMediaQuery({
    @required Widget child,
    double minHeight = 0,
    double minWidth = 0,
    Key key,
  }) : this(
          factory: LowerBoundedViewPortFactory(
            const MediaQueryViewPortFactory(),
            minHeight: minHeight,
            minWidth: minWidth,
          ),
          child: child,
          key: key,
        );

  ViewPortWidget.coercedMediaQuery({
    @required Widget child,
    double maxHeight = double.infinity,
    double maxWidth = double.infinity,
    double minHeight = 0,
    double minWidth = 0,
    Key key,
  }) : this(
          factory: CoercedViewPortFactory(
            const MediaQueryViewPortFactory(),
            maxHeight: maxHeight,
            maxWidth: maxWidth,
            minHeight: minHeight,
            minWidth: minWidth,
          ),
          child: child,
          key: key,
        );

  @override
  bool updateShouldNotify(ViewPortWidget oldWidget) =>
      oldWidget.factory != factory;
}

@immutable
abstract class WidgetViewPortFactory {
  ViewPort create(BuildContext context);
}

class FixedViewPortFactory implements WidgetViewPortFactory {
  final double width;
  final double height;

  const FixedViewPortFactory({@required this.width, @required this.height});

  @override
  ViewPort create(BuildContext context) =>
      const ViewPorts().fixed(width: width, height: height);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FixedViewPortFactory &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height;

  @override
  int get hashCode => width.hashCode ^ height.hashCode;

  @override
  String toString() =>
      'FixedViewPortFactory{_width: $width, _height: $height}';
}

@immutable
class MediaQueryViewPortFactory implements WidgetViewPortFactory {

  const MediaQueryViewPortFactory();

  @override
  ViewPort create(BuildContext context) =>
      const ViewPorts().fromMediaQueryData(MediaQuery.of(context));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaQueryViewPortFactory && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'MediaQueryViewPortFactory{}';
}

@immutable
class MinimalOfViewPortFactory implements WidgetViewPortFactory {
  final WidgetViewPortFactory _left;
  final WidgetViewPortFactory _right;

  const MinimalOfViewPortFactory(this._left, this._right);

  @override
  ViewPort create(BuildContext context) =>
      const ViewPorts().minOf(_left.create(context), _right.create(context));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MinimalOfViewPortFactory &&
          runtimeType == other.runtimeType &&
          _left == other._left &&
          _right == other._right;

  @override
  int get hashCode => _left.hashCode ^ _right.hashCode;

  @override
  String toString() =>
      'MinimalOfViewPortFactory{_left: $_left, _right: $_right}';
}

@immutable
class MaximalOfViewPortFactory implements WidgetViewPortFactory {
  final WidgetViewPortFactory _left;
  final WidgetViewPortFactory _right;

  const MaximalOfViewPortFactory(this._left, this._right);

  @override
  ViewPort create(BuildContext context) =>
      const ViewPorts().maxOf(_left.create(context), _right.create(context));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaximalOfViewPortFactory &&
          runtimeType == other.runtimeType &&
          _left == other._left &&
          _right == other._right;

  @override
  int get hashCode => _left.hashCode ^ _right.hashCode;

  @override
  String toString() =>
      'MaximalOfViewPortFactory{_left: $_left, _right: $_right}';
}

@immutable
class UpperBoundedViewPortFactory implements WidgetViewPortFactory {
  final double maxHeight;
  final double maxWidth;
  final WidgetViewPortFactory delegateFactory;

  const UpperBoundedViewPortFactory(
    this.delegateFactory, {
    this.maxHeight = double.infinity,
    this.maxWidth = double.infinity,
  }) : assert(delegateFactory != null,
            'Given decorated viewport factory points to null');

  @override
  ViewPort create(BuildContext context) => const ViewPorts().upperBounded(
        delegateFactory.create(context),
        height: maxHeight,
        width: maxWidth,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpperBoundedViewPortFactory &&
          runtimeType == other.runtimeType &&
          maxHeight == other.maxHeight &&
          maxWidth == other.maxWidth &&
          delegateFactory == other.delegateFactory;

  @override
  int get hashCode =>
      maxHeight.hashCode ^ maxWidth.hashCode ^ delegateFactory.hashCode;

  @override
  String toString() => 'UpperBoundedViewPortFactory{maxHeight: '
      '$maxHeight, maxWidth: $maxWidth, delegateFactory: $delegateFactory}';
}

@immutable
class LowerBoundedViewPortFactory implements WidgetViewPortFactory {
  final double minHeight;
  final double minWidth;
  final WidgetViewPortFactory delegateFactory;

  const LowerBoundedViewPortFactory(
    this.delegateFactory, {
    this.minHeight = 0,
    this.minWidth = 0,
  }) : assert(delegateFactory != null,
            'Given decorated viewport factory points to null');

  @override
  ViewPort create(BuildContext context) => const ViewPorts().lowerBounded(
        delegateFactory.create(context),
        height: minHeight,
        width: minWidth,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LowerBoundedViewPortFactory &&
          runtimeType == other.runtimeType &&
          minHeight == other.minHeight &&
          minWidth == other.minWidth &&
          delegateFactory == other.delegateFactory;

  @override
  int get hashCode =>
      minHeight.hashCode ^ minWidth.hashCode ^ delegateFactory.hashCode;

  @override
  String toString() => 'LowerBoundedViewPortFactory{minHeight: '
      '$minHeight, minWidth: $minWidth, delegateFactory: $delegateFactory}';
}

@immutable
class CoercedViewPortFactory implements WidgetViewPortFactory {
  final double maxHeight;
  final double maxWidth;
  final double minHeight;
  final double minWidth;
  final WidgetViewPortFactory delegateFactory;

  const CoercedViewPortFactory(
    this.delegateFactory, {
    this.maxHeight = double.infinity,
    this.maxWidth = double.infinity,
    this.minHeight = 0,
    this.minWidth = 0,
  }) : assert(delegateFactory != null,
            'Given decorated viewport factory points to null');

  @override
  ViewPort create(BuildContext context) => const ViewPorts().coerced(
        delegateFactory.create(context),
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        minHeight: minHeight,
        minWidth: minWidth,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoercedViewPortFactory &&
          runtimeType == other.runtimeType &&
          maxHeight == other.maxHeight &&
          maxWidth == other.maxWidth &&
          minHeight == other.minHeight &&
          minWidth == other.minWidth &&
          delegateFactory == other.delegateFactory;

  @override
  int get hashCode =>
      maxHeight.hashCode ^
      maxWidth.hashCode ^
      minHeight.hashCode ^
      minWidth.hashCode ^
      delegateFactory.hashCode;

  @override
  String toString() => 'CoercedViewPortFactory{maxHeight: $maxHeight, '
      'maxWidth: $maxWidth, minHeight: $minHeight, minWidth: $minWidth, '
      'delegateFactory: $delegateFactory}';
}
