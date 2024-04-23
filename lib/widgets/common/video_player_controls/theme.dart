import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoControlsThemeData {
  final bool displaySeedBar;

  final bool automaticallyImplySkipNextButton;

  final bool automaticallyImplySkipPreviousButton;

  final bool volumeGesture;

  final bool seekOnDoubleTap;

  final bool seekOnDoubleTapEnabledWhileControlsVisible;

  final Duration controlsTransitionDuration;

  final bool visibleOnMount;

  final Color? backdropColor;

  final EdgeInsets? padding;

  final EdgeInsets bottomButtonBarMargin;

  final EdgeInsets topButtonBarMargin;

  final List<Widget> bottomButtonBar;

  final List<Widget> topButtonBar;

  final List<Widget> primaryButtonBar;

  final double buttonBarHeight;

  final Duration controlsHoverDuration;

  final bool shiftSubtitlesOnControlsVisibilityChange;

  final double speedUpFactor;

  final bool speedUpOnLongPress;

  final bool seekGesture;

  final EdgeInsets seekBarMargin;

  final double seekBarHeight;

  final double seekBarContainerHeight;

  final Color seekBarColor;

  final Color seekBarPositionColor;

  final Color seekBarBufferColor;

  final double seekBarThumbSize;

  final Color seekBarThumbColor;

  final Alignment seekBarAlignment;

  final bool gesturesEnabledWhileControlsVisible;

  final double horizontalGestureSensitivity;

  final Widget Function(BuildContext)? bufferingIndicatorBuilder;
  final Widget Function(BuildContext, double)? volumeIndicatorBuilder;
  final Widget Function(BuildContext, double)? speedUpIndicatorBuilder;

  final Widget Function(BuildContext, Duration)? seekIndicatorBuilder;

  const VideoControlsThemeData({
    this.displaySeedBar = true,
    this.automaticallyImplySkipNextButton = true,
    this.automaticallyImplySkipPreviousButton = true,
    this.volumeGesture = false,
    this.controlsTransitionDuration = const Duration(milliseconds: 300),
    this.visibleOnMount = false,
    this.backdropColor = const Color(0x66000000),
    this.shiftSubtitlesOnControlsVisibilityChange = false,
    this.speedUpFactor = 3.0,
    this.padding,
    this.speedUpOnLongPress = true,
    this.seekOnDoubleTap = true,
    this.seekOnDoubleTapEnabledWhileControlsVisible = true,
    this.seekGesture = true,
    this.gesturesEnabledWhileControlsVisible = true,
    this.bottomButtonBarMargin = const EdgeInsets.only(left: 16, right: 8),
    this.topButtonBarMargin = const EdgeInsets.symmetric(horizontal: 16),
    this.buttonBarHeight = 56.0,
    this.bottomButtonBar = const [
      MaterialPositionIndicator(),
      Spacer(),
      MaterialFullscreenButton(),
    ],
    this.primaryButtonBar = const [
      Spacer(flex: 2),
      MaterialSkipPreviousButton(),
      Spacer(),
      MaterialPlayOrPauseButton(iconSize: 48.0),
      Spacer(),
      MaterialSkipNextButton(),
      Spacer(flex: 2),
    ],
    this.topButtonBar = const [],
    this.controlsHoverDuration = const Duration(seconds: 5),
    this.horizontalGestureSensitivity = 1000,
    this.seekBarMargin = EdgeInsets.zero,
    this.seekBarHeight = 2.4,
    this.seekBarContainerHeight = 36.0,
    this.seekBarColor = const Color(0x3DFFFFFF),
    this.seekBarPositionColor = const Color(0xFFFF0000),
    this.seekBarBufferColor = const Color(0x3DFFFFFF),
    this.seekBarThumbSize = 12.8,
    this.seekBarThumbColor = const Color.fromRGBO(255, 255, 255, .8),
    this.seekBarAlignment = Alignment.bottomCenter,
    this.bufferingIndicatorBuilder,
    this.volumeIndicatorBuilder,
    this.speedUpIndicatorBuilder,
    this.seekIndicatorBuilder,
  });
}

class VideoControlsTheme extends InheritedWidget {
  final VideoControlsThemeData normal;
  final VideoControlsThemeData fullscreen;

  const VideoControlsTheme({
    super.key,
    required this.normal,
    required this.fullscreen,
    required super.child,
  });

  static VideoControlsTheme? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VideoControlsTheme>();
  }

  static VideoControlsTheme of(BuildContext context) {
    final VideoControlsTheme? result = maybeOf(context);
    assert(result != null, 'No [VideoControlsTheme] found in [context]');
    return result!;
  }

  @override
  bool updateShouldNotify(VideoControlsTheme oldWidget) =>
      identical(normal, oldWidget.normal) &&
      identical(fullscreen, oldWidget.fullscreen);
}
