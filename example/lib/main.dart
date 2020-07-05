import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:viewport/viewport.dart';

/// This example demonstrates a dynamic usage of `viewport` library, for simpler
/// use cases (like bounding browser rendering area and forgetting about it)
/// non-default ViewPortWidget constructors can be used, such as
/// [ViewPortWidget.upperBoundedMediaQuery]

void main() => runApp(const ViewPortApp());

// Constant used to bound the browser's rendering area
const double kBrowserMaxWidth = 1024.0;
// The unrendered area background color
const Color kBackgroundColor = Colors.black;

class ViewPortApp extends StatelessWidget {
  const ViewPortApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BoundedArea(
        width: kIsWeb ? kBrowserMaxWidth : null,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'viewport demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const BoundedArea(
            // TODO: remove this to remove the browser's render area width bound
            width: kBrowserMaxWidth,
            child: DynamicViewportWidget(),
          ),
        ),
      );
}

class BoundedArea extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const BoundedArea({
    @required this.child,
    this.width,
    this.height,
    Key key,
  })  : assert(child != null, "Child widget reference can't be null"),
        super(key: key);

  @override
  Widget build(BuildContext context) =>
      width != null || height != null ? _buildBoundedAreaTree() : child;

  Widget _buildBoundedAreaTree() => Stack(
        textDirection: TextDirection.ltr,
        children: <Widget>[
          Container(color: kBackgroundColor),
          Center(
            child: Container(
              width: width,
              height: height,
              child: child,
            ),
          )
        ],
      );
}

class DynamicViewportWidget extends StatefulWidget {
  const DynamicViewportWidget({Key key}) : super(key: key);

  @override
  _DynamicViewportWidgetState createState() => _DynamicViewportWidgetState();
}

class _DynamicViewportWidgetState extends State<DynamicViewportWidget> {
  WidgetViewPortFactory _factory;

  void _updateFactory(WidgetViewPortFactory factory) =>
      setState(() => _factory = factory);

  @override
  void initState() {
    super.initState();
    _factory = kIsWeb
        // Bounded rendering area is used for browser
        ? const UpperBoundedViewPortFactory(
            MediaQueryViewPortFactory(),
            maxWidth: kBrowserMaxWidth,
          )
        // Native MediaQuery is user for mobile
        : const MediaQueryViewPortFactory();
  }

  @override
  Widget build(BuildContext context) => ViewPortWidget(
        factory: _factory,
        child: LoginFormPage(onFactoryChangedCallback: _updateFactory),
      );
}

typedef OnFactoryUpdatedCallback = void Function(WidgetViewPortFactory);

typedef ViewPortChangeIntent = void Function(BuildContext);

class LoginFormPage extends StatelessWidget {
  final OnFactoryUpdatedCallback onFactoryChangedCallback;

  const LoginFormPage({
    @required this.onFactoryChangedCallback,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('ViewPort Demo'),
          actions: <Widget>[
            PopupMenuButton<ViewPortChangeIntent>(
              onSelected: (fn) => fn(context),
              itemBuilder: _buildPopupMenuItems,
            ),
          ],
        ),
        body: Center(
          child: Container(
            width: ViewPort.of(context).width,
            height: ViewPort.of(context).height,
            color: Colors.red,
            alignment: Alignment.center,
            child: Text('width: ${ViewPort.of(context).width}, '
                'height: ${ViewPort.of(context).height}'),
          ),
        ),
      );

  List<PopupMenuEntry<ViewPortChangeIntent>> _buildPopupMenuItems(
    BuildContext context,
  ) =>
      <PopupMenuEntry<ViewPortChangeIntent>>[
        PopupMenuItem<ViewPortChangeIntent>(
          value: _setFixedViewPort,
          child: const Text('Fixed'),
        ),
        PopupMenuItem<ViewPortChangeIntent>(
          value: _setUpperBoundedMediaQueryViewPort,
          child: const Text('Upper bounded MediaQueryData'),
        ),
        PopupMenuItem<ViewPortChangeIntent>(
          value: _setLowerBoundedMediaQueryViewPort,
          child: const Text('Lower bounded MediaQueryData'),
        ),
        PopupMenuItem<ViewPortChangeIntent>(
          value: _setCoercedMediaQueryViewPort,
          child: const Text('Coerced MediaQueryData'),
        ),
      ];

  Future<void> _setFixedViewPort(BuildContext context) async {
    final TextEditingController heightController = TextEditingController();
    final TextEditingController widthController = TextEditingController();
    final factory = await showDialog<WidgetViewPortFactory>(
      context: context,
      builder: (BuildContext ctx) => SimpleDialog(
        title: const Text('Set fixed bounds'),
        children: [
          TextField(
            controller: heightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: 'height'),
          ),
          TextField(
            controller: widthController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: 'width'),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: heightController,
            builder: (_, TextEditingValue heightValue, __) =>
                ValueListenableBuilder<TextEditingValue>(
              valueListenable: widthController,
              builder: (_, TextEditingValue widthValue, __) => MaterialButton(
                onPressed: heightValue.text.isEmpty || widthValue.text.isEmpty
                    ? null
                    : () => Navigator.of(ctx).pop(FixedViewPortFactory(
                        width: double.parse(widthValue.text),
                        height: double.parse(heightValue.text))),
                child: const Text('Set fixed viewport'),
              ),
            ),
          ),
        ],
      ),
    );
    if (factory != null) onFactoryChangedCallback(factory);
  }

  Future<void> _setUpperBoundedMediaQueryViewPort(BuildContext context) async {
    final TextEditingController heightController = TextEditingController();
    final TextEditingController widthController = TextEditingController();
    final factory = await showDialog<WidgetViewPortFactory>(
      context: context,
      builder: (BuildContext ctx) => SimpleDialog(
        title: const Text('Set upper bounds'),
        children: [
          TextField(
            controller: heightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: 'height'),
          ),
          TextField(
            controller: widthController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: 'width'),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: heightController,
            builder: (_, TextEditingValue heightValue, __) =>
                ValueListenableBuilder<TextEditingValue>(
              valueListenable: widthController,
              builder: (_, TextEditingValue widthValue, __) => MaterialButton(
                onPressed: heightValue.text.isEmpty || widthValue.text.isEmpty
                    ? null
                    : () => Navigator.of(ctx).pop(UpperBoundedViewPortFactory(
                        const MediaQueryViewPortFactory(),
                        maxWidth: double.parse(widthValue.text),
                        maxHeight: double.parse(heightValue.text))),
                child: const Text('Set upper bounded viewport'),
              ),
            ),
          ),
        ],
      ),
    );
    if (factory != null) onFactoryChangedCallback(factory);
  }

  Future<void> _setLowerBoundedMediaQueryViewPort(BuildContext context) async {
    final TextEditingController heightController = TextEditingController();
    final TextEditingController widthController = TextEditingController();
    final factory = await showDialog<WidgetViewPortFactory>(
      context: context,
      builder: (BuildContext ctx) => SimpleDialog(
        title: const Text('Set lower bounds'),
        children: [
          TextField(
            controller: heightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: 'height'),
          ),
          TextField(
            controller: widthController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: 'width'),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: heightController,
            builder: (_, TextEditingValue heightValue, __) =>
                ValueListenableBuilder<TextEditingValue>(
              valueListenable: widthController,
              builder: (_, TextEditingValue widthValue, __) => MaterialButton(
                onPressed: heightValue.text.isEmpty || widthValue.text.isEmpty
                    ? null
                    : () => Navigator.of(ctx).pop(LowerBoundedViewPortFactory(
                        const MediaQueryViewPortFactory(),
                        minWidth: double.parse(widthValue.text),
                        minHeight: double.parse(heightValue.text))),
                child: const Text('Set lower bounded viewport'),
              ),
            ),
          ),
        ],
      ),
    );
    if (factory != null) onFactoryChangedCallback(factory);
  }

  Future<void> _setCoercedMediaQueryViewPort(BuildContext context) async {
    final TextEditingController minHeightController = TextEditingController();
    final TextEditingController minWidthController = TextEditingController();
    final TextEditingController maxHeightController = TextEditingController();
    final TextEditingController maxWidthController = TextEditingController();
    final factory = await showDialog<WidgetViewPortFactory>(
      context: context,
      builder: (BuildContext ctx) => SimpleDialog(
        title: const Text('Set lower bounds'),
        children: [
          TextField(
            controller: minHeightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: 'min height'),
          ),
          TextField(
            controller: minWidthController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: 'min width'),
          ),
          TextField(
            controller: maxHeightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: 'max height'),
          ),
          TextField(
            controller: maxWidthController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: 'max width'),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: minHeightController,
            builder: (_, TextEditingValue minHeightValue, __) =>
                ValueListenableBuilder<TextEditingValue>(
              valueListenable: minWidthController,
              builder: (_, TextEditingValue minWidthValue, __) =>
                  ValueListenableBuilder<TextEditingValue>(
                valueListenable: maxHeightController,
                builder: (_, TextEditingValue maxHeightValue, __) =>
                    ValueListenableBuilder<TextEditingValue>(
                  valueListenable: maxWidthController,
                  builder: (_, TextEditingValue maxWidthValue, __) =>
                      MaterialButton(
                    onPressed: minHeightController.text.isEmpty ||
                            minWidthValue.text.isEmpty ||
                            maxHeightController.text.isEmpty ||
                            maxWidthValue.text.isEmpty
                        ? null
                        : () => Navigator.of(ctx).pop(CoercedViewPortFactory(
                              const MediaQueryViewPortFactory(),
                              minWidth: double.parse(minWidthValue.text),
                              minHeight: double.parse(minHeightValue.text),
                              maxWidth: double.parse(maxWidthValue.text),
                              maxHeight: double.parse(maxHeightValue.text),
                            )),
                    child: const Text('Set lower bounded viewport'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    if (factory != null) onFactoryChangedCallback(factory);
  }
}
