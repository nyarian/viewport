# viewport

## Description
The library is designed to provide a way to use percentage-based layouts with easy viewport's policy (permitted size) 
change.

The most common use case is when an existing Flutter project for that works well for mobile devices should be mirrored
as is as a web and / or desktop application. Consider:
```dart
//...
child: EmailInputField(width: MediaQuery.of(context).size.width * 0.9),
//...
```
It can match the design spec for the mobile wireframes, but for the web or desktop applications this size will be way
too big, so an easy solution to this would be restriction of the web and desktop rendering area. The problem is that it
won't change the MediaQuery.of(context).size values, so, most probably, there will be a lot of "rendering area
overflow" errors all over the running application. And that's where viewport library comes into play - it supports a
variety of top-level configurations for the rendering area policy, so that it is trivial to say something like "set the
upper bound for the MediaQuery.of(context).size to such a values: ...":

```dart
class ParentWidget extends StatelessWidget {
  // ...

  @override
  Widget build(BuildContext context) {
    return ViewPortWidget.upperBoundedMediaQuery(
      maxWidth: 1024.0,
      child: const ViewPortUserWidget(),
    );
  }
}

class ViewPortUserWidget extends StatelessWidget {
  // ...

  @override
  Widget build(BuildContext context) {
    return Container(
       width: ViewPort.of(context).width * 0.6,
       child: ...,
    );
  }
}
```

And the error gets begone as the "rendering area" as viewed by the client widgets itself is restricted.

## Usage

```dart
Widget _buildRenderingAreaPolicyCarryingWidget(Widget child) {
  if (kIsWeb) {
    // Restrict the rendering area by width
    return ViewPortWidget.upperBoundedMediaQuery(
      maxWidth: kBrowserAndDesktopMaxWidth,
      child: child,
    );
  } else {
    // Use the intrinsic MediaQuery for the mobile
    return ViewPortWidget.mediaQuery(child: child);
  }
}
```

For more insight refer to the example/ and test/ directories as well as the library's documentation.
