import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:viewport/src/widget.dart';

abstract class ViewPort {
  double get width;

  double get height;

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

@immutable
class ViewPorts {
  const ViewPorts();

  ViewPort fixed({
    double height = double.infinity,
    double width = double.infinity,
  }) =>
      FixedViewPort(height: height, width: width);

  ViewPort fromMediaQueryData(MediaQueryData data) =>
      MediaQuerySizeViewPort(data);

  ViewPort minOf(ViewPort left, ViewPort right) =>
      MinimalOfViewPort(left, right);

  ViewPort maxOf(ViewPort left, ViewPort right) =>
      MaximalOfViewPort(left, right);

  ViewPort upperBounded(
    ViewPort decorated, {
    double height = double.infinity,
    double width = double.infinity,
  }) =>
      minOf(decorated, fixed(height: height, width: width));

  ViewPort lowerBounded(
    ViewPort decorated, {
    double height = 0,
    double width = 0,
  }) =>
      maxOf(decorated, fixed(height: height, width: width));

  ViewPort coerced(
    ViewPort decorated, {
    double minHeight = 0,
    double minWidth = 0,
    double maxHeight = double.infinity,
    double maxWidth = double.infinity,
  }) =>
      minOf(
          FixedViewPort(height: maxHeight, width: maxWidth),
          maxOf(
            FixedViewPort(height: minHeight, width: minWidth),
            decorated,
          ));

  ViewPort upperBoundedMediaQuery(
    MediaQueryData data, {
    double height = double.infinity,
    double width = double.infinity,
  }) =>
      upperBounded(fromMediaQueryData(data), height: height, width: width);

  ViewPort lowerBoundedMediaQuery(
    MediaQueryData data, {
    double height = 0,
    double width = 0,
  }) =>
      lowerBounded(fromMediaQueryData(data), height: height, width: width);

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

@immutable
class MinimalOfViewPort implements ViewPort {
  final ViewPort _leftSize;
  final ViewPort _rightSize;

  const MinimalOfViewPort(this._leftSize, this._rightSize)
      : assert(_leftSize != null, 'First (left) viewport given points to null'),
        assert(
            _rightSize != null, 'Second (right) viewport given points to null');

  @override
  double get height => min(_leftSize.height, _rightSize.height);

  @override
  double get width => min(_leftSize.width, _rightSize.width);

  @override
  double get aspectRatio => _WidthToHeightAspectRatio.of(this).doubleValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MinimalOfViewPort &&
          runtimeType == other.runtimeType &&
          _leftSize == other._leftSize &&
          _rightSize == other._rightSize;

  @override
  int get hashCode => _leftSize.hashCode ^ _rightSize.hashCode;

  @override
  String toString() =>
      'MinimalOfViewPort{_leftSize: $_leftSize, _rightSize: $_rightSize}';
}

@immutable
class MaximalOfViewPort implements ViewPort {
  final ViewPort _leftSize;
  final ViewPort _rightSize;

  const MaximalOfViewPort(this._leftSize, this._rightSize)
      : assert(_leftSize != null, 'First (left) viewport given points to null'),
        assert(
            _rightSize != null, 'Second (right) viewport given points to null');

  @override
  double get height => max(_leftSize.height, _rightSize.height);

  @override
  double get width => max(_leftSize.width, _rightSize.width);

  @override
  double get aspectRatio => _WidthToHeightAspectRatio.of(this).doubleValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaximalOfViewPort &&
          runtimeType == other.runtimeType &&
          _leftSize == other._leftSize &&
          _rightSize == other._rightSize;

  @override
  int get hashCode => _leftSize.hashCode ^ _rightSize.hashCode;

  @override
  String toString() =>
      'MaximalOfViewPort{_leftSize: $_leftSize, _rightSize: $_rightSize}';
}

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

class UnevaluateableAspectRatioError extends StateError {
  UnevaluateableAspectRatioError(String message) : super(message);
}
