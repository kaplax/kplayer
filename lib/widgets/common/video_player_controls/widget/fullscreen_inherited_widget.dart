import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/methods/video_state.dart';

class FullscreenInheritedWidget extends InheritedWidget {
  final VideoState parent;

  FullscreenInheritedWidget({
    super.key,
    required this.parent,
    required Widget child,
  }) : super(child: _FullscreenInheritedWidgetPopScope(child: child));

  static FullscreenInheritedWidget? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FullscreenInheritedWidget>();
  }

  static FullscreenInheritedWidget of(BuildContext context) {
    final FullscreenInheritedWidget? result = maybeOf(context);
    assert(
      result != null,
      'No [FullscreenInheritedWidget] found in [context]',
    );
    return result!;
  }

  @override
  bool updateShouldNotify(FullscreenInheritedWidget oldWidget) =>
    identical(parent, oldWidget.parent);

}

class _FullscreenInheritedWidgetPopScope extends StatefulWidget {
  final Widget child;
  const _FullscreenInheritedWidgetPopScope({
    required this.child,
  });
  @override
  State<_FullscreenInheritedWidgetPopScope> createState() =>
      _FullscreenInheritedWidgetPopScopeState();
}

class _FullscreenInheritedWidgetPopScopeState
    extends State<_FullscreenInheritedWidgetPopScope> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await onExitFullscreen(context)?.call();
        return true;
      },
      child: widget.child,
    );
  }
}
  
