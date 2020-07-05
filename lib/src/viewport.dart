import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:viewport/src/widget.dart';

/// Describes a rendering area size.
///
/// It is the central abstraction of the library which provides a simple
/// interface to the viewport information and designed mainly for widgets which
/// are sized relatively to the available rendering area, which is usually
/// retrieved using [MediaQuery.of]. So main use case of the library is to
/// replace all [MediaQueryData.size] calls with [ViewPort.width] and
/// [ViewPort.height]. This allows for easy reuse of such widgets on web and
/// desktop if they were initially designed for mobile apps.
///
/// The [width] property describe the available width, [height] - available
/// height, and [aspectRatio] - relation of the [width] to the [height].
///
/// [ViewPort.of] provides an access to the [ViewPort] configured using
/// [ViewPortWidget] [InheritedWidget] and follows the typical convention `of`
/// convention to retrieve the data associated with the widget that was found
/// in the tree. Example:
///
/// ```dart
/// EmailTextField(width: ViewPort.of(context).width * 0.66)
/// ```
///
/// See also:
///
///  * [ViewPortWidget] - [InheritedWidget] that holds a configuration of a
///    ViewPort using a WidgetViewPortFactory (factory is necessary to provide
///    a computation of the viewport instead of tree rebuild on every
///    MediaQuery rebuild which will be a dependency of this ViewPortWidget
///    instance in the most cases)
///  * [ViewPorts] - collection of the most regular [ViewPort] compositions
///  * [FixedViewPort] - provides a statically defined width and height values
///  * [MediaQuerySizeViewPort] - [ViewPort] adapter for a [MediaQueryData]
///    instance, which usually will be used in a composition with other ViewPort
///    implementations which will dynamically define the resulting width and
///    height values
///  * [MinimalOfViewPort] - takes two [ViewPort] instances and chooses the
///    minimal width and height
///  * [MaximalOfViewPort] - takes two [ViewPort] instances and chooses the
///    maximal width and height
abstract class ViewPort {
  double get width;

  double get height;

  /// width / height ratio.
  ///
  /// Throws [UnevaluateableAspectRatioError] if the resulting aspect ratio is
  /// not a number.
  double get aspectRatio;

  static ViewPort of(BuildContext context) {
    assert(context != null, 'Provided BuildContext reference points to null');
    final ViewPortWidget widget =
        context.dependOnInheritedWidgetOfExactType<ViewPortWidget>();
    if (widget != null) {
      return widget.factory.create(context);
    } else {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary(
            'ViewPortWidget.of() called with a context that does not contain a '
            'ViewPortWidget.'),
        ErrorDescription('''
No ViewPortWidget ancestor could be found starting from the context that was 
passed to ViewPortWidget.of(). This most probably happens because the parents 
chain of the widget that requested invoked ViewPortWidget.of() does not have a 
ViewPortWidget instance as a part of it's tree.'''),
        context.describeElement('The context used was')
      ]);
    }
  }
}

/// Collection of the most regular [ViewPort] compositions.
///
/// Refer to the "test/viewports_test.dart" for examples.
///
/// See also:
///
///  * [ViewPort] - abstraction that describes a rendering area size
///  * [ViewPortWidget] - [InheritedWidget] that holds a ViewPort configuration
@immutable
class ViewPorts {
  const ViewPorts();

  /// Provides a [ViewPort] which holds the given [height] and [width]
  /// statically. Arguments are set to [double.infinity] by default.
  ///
  /// ```dart
  /// const ViewPorts().fixed(height: 400, width: 500);
  /// ```
  ViewPort fixed({
    double height = double.infinity,
    double width = double.infinity,
  }) =>
      FixedViewPort(height: height, width: width);

  /// Provides a [ViewPort] that adapts the [MediaQueryData.size] interface
  ///
  /// ```dart
  /// const ViewPorts().fromMediaQueryData(MediaQuery.of(context));
  /// ```
  ViewPort fromMediaQueryData(MediaQueryData data) =>
      MediaQuerySizeViewPort(data);

  /// Provides a [ViewPort] which chooses the minimal [ViewPort.height] and
  /// [ViewPort.width] value out of the two [ViewPort] implementations given
  ///
  /// ```dart
  /// final ViewPort vp = const ViewPorts().minOf(
  ///   const ViewPorts().fromMediaQueryData(MediaQuery.of(context)),
  ///   const ViewPorts().fixed(width: 1024.0),
  /// );
  /// ```
  ViewPort minOf(ViewPort left, ViewPort right) =>
      MinimalOfViewPort(left, right);

  /// Provides a [ViewPort] which chooses the maximal [ViewPort.height] and
  /// [ViewPort.width] value out of the two [ViewPort] implementations given
  ///
  /// ```dart
  /// final ViewPort vp = const ViewPorts().maxOf(
  ///   const ViewPorts().fromMediaQueryData(MediaQuery.of(context)),
  ///   const ViewPorts().fixed(width: 200.0),
  /// );
  /// ```
  ViewPort maxOf(ViewPort left, ViewPort right) =>
      MaximalOfViewPort(left, right);

  /// Provides a [ViewPort] which [ViewPort.width] and [ViewPort.height] values
  /// will be upper bounded by the given ones.
  ///
  /// Simply said, if the [decorated] values are bigger than the defined bounds,
  /// then bound values are returned (e.g. decorated.width = 500 and
  /// [width] = 400, then 400 will be returned).
  ///
  /// [width] describes the width's upper bound, [height] - height's upper
  /// bound. The bounds are set to [double.infinity] by default (so if both
  /// values were not specified then the resulting object will produce the
  /// [decorated] instance behavior).
  ///
  ///```dart
  /// final ViewPort vp = const ViewPorts().upperBounded(
  ///   const ViewPorts().fromMediaQueryData(MediaQuery.of(context)),
  ///   width: 1024.0,
  /// );
  /// ```
  ViewPort upperBounded(
    ViewPort decorated, {
    double height = double.infinity,
    double width = double.infinity,
  }) =>
      minOf(decorated, fixed(height: height, width: width));

  /// Provides a [ViewPort] which [ViewPort.width] and [ViewPort.height] values
  /// will be lower bounded by the given ones.
  ///
  /// Simply said, if the [decorated] values are lesser than the defined bounds,
  /// then bound values are returned (e.g. decorated.width = 500 and
  /// [width] = 600, then 600 will be returned).
  ///
  /// [width] describes the width's lower bound, [height] - height's lower
  /// bound. The values are 0 by default (so if both values were not
  /// specified then the resulting object will produce the [decorated] instance
  /// behavior).
  ///
  ///```dart
  /// final ViewPort vp = const ViewPorts().lowerBounded(
  ///   const ViewPorts().fromMediaQueryData(MediaQuery.of(context)),
  ///   width: 200.0,
  /// );
  /// ```
  ViewPort lowerBounded(
    ViewPort decorated, {
    double height = 0,
    double width = 0,
  }) =>
      maxOf(decorated, fixed(height: height, width: width));

  /// Provides a [ViewPort] which [ViewPort.width] and [ViewPort.height] values
  /// will be lower bounded by the provided [minWidth] and [minHeight] and
  /// upper bounded by [maxWidth] and [maxHeight].
  ///
  /// Simply said, if the [decorated] values are lesser than the defined minimal
  /// bounds, then the minimal bounds' values are returned (e.g.
  /// decorated.width = 500 and [minWidth] = 600, then 600 will be returned),
  /// and if the [decorated] values are bigger than the defined maximal bounds,
  /// then the maximal bounds' are returned (e.g. decorated.width = 1500 and
  /// [maxWidth] = 1024, then 1024 will be returned).
  ///
  /// [minWidth] describes the width's lower bound, [minHeight] - height's lower
  /// bound. Minimal bounds are 0 by default. [maxWidth] describes the width's
  /// upper bound, [maxHeight] - height's upper bound. Maximal bounds are set to
  /// [double.infinity] by default.
  ///
  /// Invocation of this method with all the parameters provided with the
  /// default values will produce no additional effect over the direct
  /// [decorated] instance usage unless there are specific cases like
  /// decorated.width resulting into [double.infinity], for which the result is
  /// unspecified.
  ///
  /// Throws [AssertionError] if [minHeight] > [maxHeight] or
  /// [minWidth] > [maxWidth]
  ///
  ///```dart
  /// final ViewPort vp = const ViewPorts().coerced(
  ///   const ViewPorts().fromMediaQueryData(MediaQuery.of(context)),
  ///   minWidth: 200.0,
  ///   maxWidth: 1024.0,
  /// );
  /// ```
  ViewPort coerced(
    ViewPort decorated, {
    double minHeight = 0,
    double minWidth = 0,
    double maxHeight = double.infinity,
    double maxWidth = double.infinity,
  }) {
    assert(minHeight <= maxHeight, 'minHeight > maxHeight, which is forbidden');
    assert(minWidth <= maxWidth, 'minWidth > maxWidth, which is forbidden');
    return minOf(
        FixedViewPort(height: maxHeight, width: maxWidth),
        maxOf(
          FixedViewPort(height: minHeight, width: minWidth),
          decorated,
        ));
  }

  /// Provides a [ViewPort] which will produce the [data]'s size values that are
  /// upper bounded by the given [height] and [width]
  ///
  /// Simply said, if the [data] size values are bigger than the defined bounds,
  /// then bound values are returned (e.g. data.size.width = 500 and
  /// [width] = 400, then 400 will be returned).
  ///
  /// [width] describes the width's upper bound, [height] - height's upper
  /// bound. The values are set to [double.infinity] by default (so if both
  /// values were not specified then the resulting object will produce the
  /// [data]'s size instance behavior).
  ///
  ///```dart
  /// final ViewPort vp = const ViewPorts().upperBoundedMediaQuery(
  ///   MediaQuery.of(context),
  ///   width: 1024.0,
  /// );
  /// ```
  ViewPort upperBoundedMediaQuery(
    MediaQueryData data, {
    double height = double.infinity,
    double width = double.infinity,
  }) =>
      upperBounded(fromMediaQueryData(data), height: height, width: width);

  /// Provides a [ViewPort] which will produce the [data]'s size values that are
  /// lower bounded by the given [height] and [width]
  ///
  /// Simply said, if the [data] size values are lesser than the defined bounds,
  /// then bound values are returned (e.g. data.size.width = 300 and
  /// [width] = 400, then 400 will be returned).
  ///
  /// [width] describes the width's lower bound, [height] - height's lower
  /// bound. The bounds are 0 by default (so if both values were not
  /// specified then the resulting object will produce the [data]'s size
  /// instance behavior).
  ///
  ///```dart
  /// final ViewPort vp = const ViewPorts().lowerBoundedMediaQuery(
  ///   MediaQuery.of(context),
  ///   width: 200.0,
  /// );
  /// ```
  ViewPort lowerBoundedMediaQuery(
    MediaQueryData data, {
    double height = 0,
    double width = 0,
  }) =>
      lowerBounded(fromMediaQueryData(data), height: height, width: width);

  /// Provides a [ViewPort] which will produce the [data]'s size values that are
  /// lower bounded by the given [minHeight] and [minWidth] and upper bounded by
  /// the given [maxHeight] and [maxWidth]
  ///
  /// Simply said, if the [data] size values are lesser than the defined bounds,
  /// then bound values are returned (e.g. data.size.width = 300 and
  /// [minWidth] = 400, then 400 will be returned). The same applies for the
  /// upper bounds (e.g. data.size.width = 1200 and [maxWidth] = 1024, then 1024
  /// will be returned).
  ///
  /// [minWidth] describes the width's lower bound, [minHeight] - height's lower
  /// bound. The lower bounds are 0 by default. [maxWidth] describes the width's
  /// upper bound, [maxHeight] - height's upper bound. The lower bounds are set
  /// to [double.infinity] by default.
  ///
  /// Invocation of this method with all the parameters provided with the
  /// default values will produce no additional effect over the direct
  /// [data]'s size instance usage unless there are specific cases like
  /// data.size.width resulting into [double.infinity], for which the
  /// result is unspecified.
  ///
  ///```dart
  /// final ViewPort vp = const ViewPorts().coercedMediaQuery(
  ///   MediaQuery.of(context),
  ///   minWidth: 200.0,
  ///   maxWidth: 1024.0,
  /// );
  /// ```
  ViewPort coercedMediaQuery(
    MediaQueryData data, {
    double minHeight = 0,
    double minWidth = 0,
    double maxHeight = double.infinity,
    double maxWidth = double.infinity,
  }) =>
      coerced(
        fromMediaQueryData(data),
        minHeight: minHeight,
        maxHeight: maxHeight,
        minWidth: minWidth,
        maxWidth: maxWidth,
      );
}

/// Provides a statically defined [height] and [width].
///
/// Throws [AssertionError] if height or width are null or negative.
/// 
/// See also:
///  * [ViewPort] - defines rendering area size.
///  * [ViewPortWidget] - [InheritedWidget] that holds a [ViewPort] 
///  configuration 
///  * [ViewPorts] - collection of the most regular [ViewPort] compositions
///  * [MediaQuerySizeViewPort] - [ViewPort] adapter for a [MediaQueryData]
///  * [MinimalOfViewPort] - takes two [ViewPort] instances and chooses the
///    minimal width and height
///  * [MaximalOfViewPort] - takes two [ViewPort] instances and chooses the
///    maximal width and height
@immutable
class FixedViewPort implements ViewPort {
  @override
  final double height;
  @override
  final double width;

  const FixedViewPort({
    this.height = double.infinity,
    this.width = double.infinity,
  })  : assert(height != null, 'height must not be null'),
        assert(width != null, 'width must not be null'),
        assert(height >= 0, 'height must not be negative, but got $height'),
        assert(width >= 0, 'width must not be negative, but got $width');

  @override
  double get aspectRatio => _WidthToHeightAspectRatio.of(this).doubleValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FixedViewPort &&
          runtimeType == other.runtimeType &&
          height == other.height &&
          width == other.width;

  @override
  int get hashCode => height.hashCode ^ width.hashCode;

  @override
  String toString() => 'FixedViewPort{height: $height, width: $width}';
}

/// Adapter of a [MediaQueryData] instance to the [ViewPort] interface.
///
/// Throws [AssertionError] if the given [_data] points to null.
/// 
/// See also:
///  * [ViewPort] - defines rendering area size.
///  * [ViewPortWidget] - [InheritedWidget] that holds a [ViewPort] 
///  configuration 
///  * [ViewPorts] - collection of the most regular [ViewPort] compositions
///  * [FixedViewPort] - provides a statically defined width and height
///  * [MinimalOfViewPort] - takes two [ViewPort] instances and chooses the
///    minimal width and height
///  * [MaximalOfViewPort] - takes two [ViewPort] instances and chooses the
///    maximal width and height
@immutable
class MediaQuerySizeViewPort implements ViewPort {
  final MediaQueryData _data;

  const MediaQuerySizeViewPort(this._data)
      : assert(_data != null, 'Provided MediaQueryData points to null');

  @override
  double get aspectRatio => _WidthToHeightAspectRatio.of(this).doubleValue;

  @override
  double get height => _data.size.height;

  @override
  double get width => _data.size.width;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaQuerySizeViewPort &&
          runtimeType == other.runtimeType &&
          _data == other._data;

  @override
  int get hashCode => _data.hashCode;

  @override
  String toString() => 'MediaQuerySizeViewPort{_data: $_data}';
}

/// Takes two [ViewPort] instances and chooses the minimal [ViewPort.width] and 
/// [ViewPort.height] values.
///
/// Throws [AssertionError] if the given [_leftPort] or [_rightPort] point to 
/// null.
/// 
/// See also:
///  * [ViewPort] - defines rendering area size.
///  * [ViewPortWidget] - [InheritedWidget] that holds a [ViewPort] 
///  configuration 
///  * [ViewPorts] - collection of the most regular [ViewPort] compositions
///  * [FixedViewPort] - provides a statically defined width and height
///  * [MediaQuerySizeViewPort] - [ViewPort] adapter for a [MediaQueryData]
///  * [MaximalOfViewPort] - takes two [ViewPort] instances and chooses the
///    maximal width and height
@immutable
class MinimalOfViewPort implements ViewPort {
  final ViewPort _leftPort;
  final ViewPort _rightPort;

  const MinimalOfViewPort(this._leftPort, this._rightPort)
      : assert(_leftPort != null, 'First (left) viewport given points to null'),
        assert(
            _rightPort != null, 'Second (right) viewport given points to null');

  @override
  double get height => min(_leftPort.height, _rightPort.height);

  @override
  double get width => min(_leftPort.width, _rightPort.width);

  @override
  double get aspectRatio => _WidthToHeightAspectRatio.of(this).doubleValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MinimalOfViewPort &&
          runtimeType == other.runtimeType &&
          _leftPort == other._leftPort &&
          _rightPort == other._rightPort;

  @override
  int get hashCode => _leftPort.hashCode ^ _rightPort.hashCode;

  @override
  String toString() =>
      'MinimalOfViewPort{_leftSize: $_leftPort, _rightSize: $_rightPort}';
}

/// Takes two [ViewPort] instances and chooses the maximal [ViewPort.width] and 
/// [ViewPort.height] values.
///
/// Throws [AssertionError] if the given [_leftPort] or [_rightPort] point to 
/// null.
/// 
/// See also:
///  * [ViewPort] - defines rendering area size.
///  * [ViewPortWidget] - [InheritedWidget] that holds a [ViewPort] 
///  configuration 
///  * [ViewPorts] - collection of the most regular [ViewPort] compositions
///  * [FixedViewPort] - provides a statically defined width and height
///  * [MediaQuerySizeViewPort] - [ViewPort] adapter for a [MediaQueryData]
///  * [MinimalOfViewPort] - takes two [ViewPort] instances and chooses the
///    minimal width and height
@immutable
class MaximalOfViewPort implements ViewPort {
  final ViewPort _leftPort;
  final ViewPort _rightPort;

  const MaximalOfViewPort(this._leftPort, this._rightPort)
      : assert(_leftPort != null, 'First (left) viewport given points to null'),
        assert(
            _rightPort != null, 'Second (right) viewport given points to null');

  @override
  double get height => max(_leftPort.height, _rightPort.height);

  @override
  double get width => max(_leftPort.width, _rightPort.width);

  @override
  double get aspectRatio => _WidthToHeightAspectRatio.of(this).doubleValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaximalOfViewPort &&
          runtimeType == other.runtimeType &&
          _leftPort == other._leftPort &&
          _rightPort == other._rightPort;

  @override
  int get hashCode => _leftPort.hashCode ^ _rightPort.hashCode;

  @override
  String toString() =>
      'MaximalOfViewPort{_leftSize: $_leftPort, _rightSize: $_rightPort}';
}

/// Shared implementation of the [ViewPort.aspectRatio].
///
/// Used to avoid implementation inheritance and to centralize the calculation
/// in the single place. Type-bound mixins require implementation inheritance
/// (extends) and unbound mixins require interface (width and height)
/// redeclaration and prevents const constructors, so they could not be used.
@immutable
class _WidthToHeightAspectRatio {
  final ViewPort _viewPort;

  const _WidthToHeightAspectRatio.of(this._viewPort);

  double get doubleValue {
    final double value = _viewPort.width / _viewPort.height;
    if (!value.isNaN) {
      return value;
    } else {
      throw UnevaluateableAspectRatioError('''
ViewPort's aspect ratio cannot be evaluated (is any of the arguments has 
double.infinity?):$_viewPort''');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WidthToHeightAspectRatio &&
          runtimeType == other.runtimeType &&
          _viewPort == other._viewPort;

  @override
  int get hashCode => _viewPort.hashCode;

  @override
  String toString() => '_ViewPortAspectRatio{_viewPort: $_viewPort}';
}

/// Thrown if the aspect ratio can't be evaluated (is NaN).
class UnevaluateableAspectRatioError extends StateError {
  UnevaluateableAspectRatioError(String message) : super(message);
}
