import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:synchronized/synchronized.dart';

final Lock lock = Lock();

bool isFullScreen(BuildContext context) =>
    FullscreenInheritedWidget.maybeOf(context) != null;

Future<void> exitFullscreen(BuildContext context) {
  return lock.synchronized(() async {
    if (isFullscreen(context)) {
      if (context.mounted) {
        await Navigator.of(context).maybePop();
        if (context.mounted) {
          FullscreenInheritedWidget.of(context).parent.refreshView();
        }
      }
    }
  });
}
