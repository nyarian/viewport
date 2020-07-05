/// viewport library is designed to provide a way to use rendering size
/// percentage-based layouts with trivial viewport attributes policy change.
///
/// The most common use case is when an existing Flutter project for that works
/// well for mobile devices should be mirrored as is as a web and / or desktop
/// application. Imagine this:
/// ```dart
/// //...
/// child: EmailInputField(width: MediaQuery.of(context).size.width * 0.9),
/// //...
/// ```
/// It can match the design spec for the mobile wireframes, but for the web or
/// desktop applications this size will be way too big, so an easy solution to
/// this would be restriction of the web and desktop rendering area.
/// The problem is that it won't change the MediaQuery.of(context).size values,
/// so, most probably, there will be a lot of "rendering area overflow" errors
/// all over the running application. And that's where viewport library comes
/// into the game - it supports a variety of top-level configurations for the
/// rendering area policy, so that it is trivial to say something like "set the
/// upper bound for the MediaQuery.of(context).size to such a values: ...":
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
/// And the error gets begone as the "rendering area" as viewed by the client
/// widgets itself is restricted.
///
/// See also:
///   * [ViewPort] - describes a rendering area size.
///   * [ViewPorts] - provides a variety of common [ViewPort] policies.
///   * [ViewPortWidget] - InheritedWidget designed to produce a [ViewPort]
///     dynamically based on the provided ViewPort factory implementation and
///     the incoming BuildContext instance.
library viewport;

import 'package:viewport/src/viewport.dart';

export 'package:viewport/src/viewport.dart';
export 'package:viewport/src/widget.dart';
