import 'package:flutter/widgets.dart';
import 'package:viewport/viewport.dart';

/// [InheritedWidget] holding a [ViewPort] configuration.
///
/// As any inherited widget, to provide an effect to the application, it should
/// be accessible to the user widget from the parents chain.
///
/// ```dart
/// class ParentWidget extends StatelessWidget {
///   // ...
///
///   @override
///   Widget build(BuildContext context) {
///     return ViewPortWidget.upperBoundedMediaQuery(
///       maxWidth: 1024.0,
///       child: const ViewPortUserWidget(),
///     );
///   }
/// }
///
/// class ViewPortUserWidget extends StatelessWidget {
///   // ...
///
///   @override
///   Widget build(BuildContext context) {
///     return Container(
///        width: ViewPort.of(context).width * 0.6,
///        child: ...,
///     );
///   }
/// }
/// ```
///
/// It makes use of [WidgetViewPortFactory] to support dynamic calculations (as
/// [ViewPort] instances operate purely on their fields to evaluate the result
/// and convenient access interface such as [ViewPort.of] would be impossible).
/// So the default constructor takes a [WidgetViewPortFactory] instance, and
/// there are a bunch of constructors with pre-defined configurations available
/// to simplify the usage for the most common cases, such as:
///
/// 1. [ViewPortWidget.fixed] - to create a [FixedViewPort]-backed configuration
/// 2. [ViewPortWidget.mediaQuery] - to create a [MediaQuerySizeViewPort]-backed
/// configuration
/// 3. [ViewPortWidget.lowerBoundedMediaQuery] - to create a configuration
/// analogous to the dynamic [ViewPorts.lowerBoundedMediaQuery]
/// 4. [ViewPortWidget.upperBoundedMediaQuery] - to create a configuration
/// analogous to the dynamic [ViewPorts.upperBoundedMediaQuery]
/// 5. [ViewPortWidget.coercedMediaQuery] - to create a configuration
/// analogous to the dynamic [ViewPorts.coercedMediaQuery]
///
/// See also:
///   * [ViewPort] - describes the rendering area size
///   * [ViewPorts] - provides common [ViewPort] configurations
///   * [WidgetViewPortFactory] - used to support dynamic [ViewPort]
///     configuration, which will produce the instance based on the passed
///     BuildContext
@immutable
class ViewPortWidget extends InheritedWidget {
  final WidgetViewPortFactory factory;

  /// Configures the widget with any passed [WidgetViewPortFactory]
  /// implementation.
  ///
  /// These implementation can be user-defined, and that's why the API internals
  /// was made public.
  ///
  /// See also:
  ///   * [WidgetViewPortFactory] - provides an interface for dynamic [ViewPort]
  ///     configuration.
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

  /// Provides a fixed [ViewPort] configuration.
  ///
  /// See also:
  ///   * [FixedViewPort] - provides a statically defined height and width.
  ///   * [FixedViewPortFactory] - provides [FixedViewPort]-backed
  ///     dynamic configuration
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

  /// Provides a [MediaQueryData]-based [ViewPort] configuration.
  ///
  /// Typically used for mobile version of mobile-first projects for which the
  /// mirroring web version is being implemented.
  ///
  /// See also:
  ///   * [MediaQuerySizeViewPort] - provides a statically defined height and
  ///   width.
  ///   * [MediaQueryViewPortFactory] - provides [MediaQuerySizeViewPort]-backed
  ///     dynamic configuration
  const ViewPortWidget.mediaQuery({
    @required Widget child,
    Key key,
  }) : this(
          factory: const MediaQueryViewPortFactory(),
          child: child,
          key: key,
        );


  /// Provides an upper-bounded [MediaQueryData]-based [ViewPort] configuration.
  ///
  /// Typically used for web version of mobile-first projects for which the
  /// mirroring web version is being implemented.
  ///
  /// See also:
  ///   * [UpperBoundedViewPortFactory] - provides an upper bound for the
  ///     decorated ViewPort instance's height and width.
  ///   * [MediaQueryViewPortFactory] - provides [MediaQuerySizeViewPort]-backed
  ///     dynamic configuration
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

  /// Provides a lower-bounded [MediaQueryData]-based [ViewPort] configuration.
  ///
  /// See also:
  ///   * [UpperBoundedViewPortFactory] - provides a lower bound for the
  ///     decorated ViewPort instance's height and width.
  ///   * [MediaQueryViewPortFactory] - provides [MediaQuerySizeViewPort]-backed
  ///     dynamic configuration
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

  /// Provides a coerced [MediaQueryData]-based [ViewPort] configuration.
  ///
  /// See also:
  ///   * [CoercedViewPortFactory] - provides a lower and upper bounds for the
  ///     decorated ViewPort instance's height and width.
  ///   * [MediaQueryViewPortFactory] - provides [MediaQuerySizeViewPort]-backed
  ///     dynamic configuration
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

/// Dynamically configures [ViewPort].
///
/// Given a [BuildContext] to the [WidgetViewPortFactory.create] function, an
/// implementation is expected to produce a [ViewPort] instance. The specific
/// [ViewPort] instance to be produced is defined by the implementation itself.
///
/// See also:
///   * [FixedViewPortFactory] - constitutes a fixed viewport.
///   * [MediaQueryViewPortFactory] - a [ViewPort] adapter for [MediaQueryData].
///   * [MinimalOfViewPortFactory] - returns a minimal value out of the two
///     ViewPort instances given.
///   * [MaximalOfViewPortFactory] - returns a maximal value out of the two
///     ViewPort instances given.
///   * [UpperBoundedViewPortFactory] - returns a value of the underlying
///     ViewPort instance upper bounded by the given values.
///   * [LowerBoundedViewPortFactory] - returns a value of the underlying
///     ViewPort instance lower bounded by the given values.
///   * [CoercedViewPortFactory] - returns a value of the underlying [ViewPort]
///     instance coerced by the given values.
@immutable
abstract class WidgetViewPortFactory {
  ViewPort create(BuildContext context);
}

/// Constitutes a fixed viewport.
///
/// See also:
///   * [ViewPorts.fixed] - Provides a [ViewPort] which holds the given
///   height and width statically.
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
  String toString() => 'FixedViewPortFactory{_width: $width, _height: $height}';
}

/// [ViewPort] adapter for [MediaQueryData]
///
/// See also:
///   * [ViewPorts.fromMediaQueryData] - provides a [ViewPort] that adapts
///     the MediaQueryData.size interface
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

/// Returns a minimal value out of the two [ViewPort] instances given
///
/// See also:
///   * [ViewPorts.minOf] - Provides a [ViewPort] which chooses the minimal
///     height and width values out of the two ViewPort instances given
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

/// Returns a maximal value out of the two [ViewPort] instances given
///
/// See also:
///   * [ViewPorts.maxOf] - Provides a [ViewPort] which chooses the maximal
///     height and width values out of the two ViewPort instances given
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

/// Returns a value of the underlying ViewPort instance upper bounded by the
/// given values.
///
/// See also:
///   * [ViewPorts.upperBounded] - Provides a [ViewPort] which width and height
///   values will be upper bounded by the given ones.
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

/// Returns a value of the underlying ViewPort instance lower bounded by the
/// given values.
///
/// See also:
///   * [ViewPorts.lowerBounded] - Provides a [ViewPort] which width and height
///   values will be lower bounded by the given ones.
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

/// Returns a value of the underlying [ViewPort] instance coerced by the given
/// values.
///
/// See also:
///   * [ViewPorts.coerced] - Provides a [ViewPort] which width and height
///   values will be lower and upper bounded by the given ones.
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
  })  : assert(delegateFactory != null,
            'Given decorated viewport factory points to null'),
        assert(minHeight <= maxHeight,
            'maxHeight < minHeight, which is forbidden'),
        assert(minWidth <= maxWidth, 'maxWidth < minWidth, which is forbidden');

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
