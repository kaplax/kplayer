import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kplayer/widgets/common/video_player_controls/method/fullscreen.dart';
import 'package:kplayer/widgets/common/video_player_controls/theme.dart';
import 'package:kplayer/widgets/common/video_player_controls/widget/fullscreen_inherited_widget.dart';
import 'package:kplayer/widgets/common/video_player_controls/widget/rate_menu.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' as mediaKit;
import 'package:media_kit_video/media_kit_video_controls/media_kit_video_controls.dart';
// import 'package:volume_controller/volume_controller.dart';
// import 'package:screen_brightness/screen_brightness.dart';

import 'package:media_kit_video/media_kit_video_controls/src/controls/methods/video_state.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/widgets/video_controls_theme_data_injector.dart';

Widget VideoPlayerControls(mediaKit.VideoState state) {
  return VideoControlsThemeDataInjector(
    child: _VideoControls(state: state),
  );
}

VideoControlsThemeData _theme(BuildContext context) =>
    mediaKit.FullscreenInheritedWidget.maybeOf(context) == null
        ? VideoControlsTheme.maybeOf(context)?.normal ??
            kDefaultVideoControlsThemeData
        : VideoControlsTheme.maybeOf(context)?.fullscreen ??
            kDefaultVideoControlsThemeData;

const kDefaultVideoControlsThemeData = VideoControlsThemeData();

class _VideoControls extends StatefulWidget {
  final mediaKit.VideoState state;
  const _VideoControls({required this.state});

  @override
  State<_VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<_VideoControls> {
  late bool mount = _theme(context).visibleOnMount;
  late bool visible = _theme(context).visibleOnMount;
  late bool buffering = controller(context).player.state.buffering;
  int swipeDuration = 0;
  bool showSwipeDuration = false;

  bool _speedUpIndicator = false;

  bool _visibleMoreSetting = false;
  bool _mountSeekBackwardButton = false;
  bool _mountSeekForwardButton = false;
  bool _hideSeekBackwardButton = false;
  bool _hideSeekForwardButton = false;

  bool _volumeIndicator = false;

  Offset _dragInitialDetail = Offset.zero;

  Timer? _timer;

  double _volumeValue = 0.0;
  double _curRate = 1.0;

  late Player player = controller(context).player;

  double get subtitleVerticalShiftOffset =>
      (_theme(context).padding?.bottom ?? 0) +
      (_theme(context).bottomButtonBarMargin.vertical) +
      (_theme(context).bottomButtonBar.isEmpty
          ? _theme(context).buttonBarHeight
          : 0.0);

  Offset? _tapPosition;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller(context).player.stream.playing.listen((playing) {
      if (playing && visible) {
        hiddenControlPanel();
      }
    });
  }

  final ValueNotifier<Duration> _seekBarDeltaValueNotifier =
      ValueNotifier<Duration>(Duration.zero);

  void hiddenControlPanel() {
    _timer?.cancel();
    _timer = Timer(_theme(context).controlsHoverDuration, () {
      if (mounted && player.state.playing) {
        setState(() {
          visible = false;
        });
        unshiftSubtitle();
      }
    });
  }

  void shiftSubtitle() {
    if (_theme(context).shiftSubtitlesOnControlsVisibilityChange) {
      state(context).setSubtitleViewPadding(
        state(context).widget.subtitleViewConfiguration.padding +
            EdgeInsets.fromLTRB(0, 0, 0, subtitleVerticalShiftOffset),
      );
    }
  }

  void unshiftSubtitle() {
    if (_theme(context).shiftSubtitlesOnControlsVisibilityChange) {
      state(context).setSubtitleViewPadding(
        state(context).widget.subtitleViewConfiguration.padding,
      );
    }
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _tapPosition = details.localPosition;
    });
  }

  void _handleLongPress() {
    setState(() {
      _speedUpIndicator = true;
    });
    controller(context).player.setRate(_theme(context).speedUpFactor);
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    setState(() {
      _speedUpIndicator = false;
    });
    controller(context).player.setRate(_curRate);
  }

  void onDoubleTapSeekForward() {
    setState(() {
      _mountSeekForwardButton = true;
    });
  }

  void onDoubleTapSeekBackward() {
    setState(() {
      _mountSeekBackwardButton = true;
    });
  }

  void onTap() {
    if (!visible) {
      setState(() {
        mount = true;
        visible = true;
      });
      shiftSubtitle();
      hiddenControlPanel();
    } else {
      setState(() {
        visible = false;
      });
      unshiftSubtitle();
    }
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_dragInitialDetail == Offset.zero) {
      _dragInitialDetail = details.localPosition;
      return;
    }

    final diff = _dragInitialDetail.dx - details.localPosition.dx;
    final duration = controller(context).player.state.duration.inSeconds;
    final position = controller(context).player.state.position.inSeconds;

    final seconds =
        -(diff * duration / _theme(context).horizontalGestureSensitivity)
            .round();

    final relativePosition = position + seconds;

    if (relativePosition <= duration && relativePosition >= 0) {
      setState(() {
        swipeDuration = seconds;
        showSwipeDuration = true;
        _seekBarDeltaValueNotifier.value = Duration(seconds: seconds);
      });
    }
  }

  void onHorizontalDragEnd() {
    if (swipeDuration != 0) {
      Duration newPostion = controller(context).player.state.position +
          Duration(seconds: swipeDuration);
      newPostion = newPostion.clamp(
        Duration.zero,
        controller(context).player.state.duration,
      );
      controller(context).player.seek(newPostion);
    }

    setState(() {
      _dragInitialDetail = Offset.zero;
      showSwipeDuration = false;
    });
  }

  void onRateChange(double rate) {
    setState(() {
      _curRate = rate;
    });
    controller(context).player.setRate(rate);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var seekOnDoubleTapEnableWhileControlsAreVisible =
        (_theme(context).seekOnDoubleTap &&
            _theme(context).seekOnDoubleTapEnabledWhileControlsVisible);
    return Theme(
      data: Theme.of(context).copyWith(
        focusColor: const Color(0x00000000),
        hoverColor: const Color(0x00000000),
        splashColor: const Color(0x00000000),
        highlightColor: const Color(0x00000000),
      ),
      child: Focus(
        autofocus: true,
        child: Material(
          elevation: 0,
          borderOnForeground: false,
          animationDuration: Duration.zero,
          color: const Color(0x00000000),
          surfaceTintColor: const Color(0x00000000),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                curve: Curves.easeInOut,
                opacity: visible ? 1.0 : 0.0,
                duration: _theme(context).controlsTransitionDuration,
                onEnd: () {
                  setState(() {
                    if (!visible) {
                      mount = false;
                    }
                  });
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: Container(color: _theme(context).backdropColor),
                    ),
                    Positioned.fill(
                      left: 16,
                      top: 16,
                      right: 16,
                      bottom: 16,
                      child: GestureDetector(
                        onTap: onTap,
                        onDoubleTapDown: _handleTapDown,
                        onLongPress: _theme(context).speedUpOnLongPress
                            ? _handleLongPress
                            : null,
                        onLongPressEnd: _theme(context).speedUpOnLongPress
                            ? _handleLongPressEnd
                            : null,
                        onDoubleTap: () {
                          if (_tapPosition != null &&
                              _tapPosition!.dx >
                                  MediaQuery.of(context).size.width / 2) {
                            if (!mount && _theme(context).seekOnDoubleTap ||
                                seekOnDoubleTapEnableWhileControlsAreVisible) {
                              onDoubleTapSeekForward();
                            }
                          }
                        },
                        onHorizontalDragUpdate: (details) {
                          if ((!mount && _theme(context).seekGesture) ||
                              (_theme(context)
                                  .gesturesEnabledWhileControlsVisible)) {
                            onHorizontalDragUpdate(details);
                          }
                        },
                        onHorizontalDragEnd: (details) {
                          onHorizontalDragEnd();
                        },
                        onVerticalDragUpdate: (e) {
                          // TODO:
                        },
                        child: Container(
                          color: const Color(0x00000000),
                        ),
                      ),
                    ),
                    if (mount)
                      Padding(
                        padding: _theme(context).padding ??
                            (isFullScreen(context)
                                ? MediaQuery.of(context).padding
                                : EdgeInsets.zero),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: _theme(context).buttonBarHeight,
                              margin: _theme(context).bottomButtonBarMargin,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // TODO: 待替换
                                // children: _theme(context).topButtonBar,
                                children: [
                                  Container(
                                    child: const Text('Back'),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _visibleMoreSetting = true;
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    child: Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            showModalBottomSheet(
                                                                context:
                                                                    context,
                                                                builder: (ctx) {
                                                                  return RateMenu(
                                                                    value:
                                                                        _curRate,
                                                                    onTap:
                                                                        onRateChange,
                                                                  );
                                                                });
                                                          },
                                                          child: const Column(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .one_x_mobiledata,
                                                              ),
                                                              Text(
                                                                '倍速播放',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                });
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: AnimatedOpacity(
                                curve: Curves.easeInOut,
                                opacity: buffering ? 0.0 : 1.0,
                                duration:
                                    _theme(context).controlsTransitionDuration,
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: _theme(context).primaryButtonBar,
                                  ),
                                ),
                              ),
                            ),
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                if (_theme(context).displaySeedBar)
                                  VideoPlayerSeekBar(
                                    delta: _seekBarDeltaValueNotifier,
                                    onSeekStart: () {
                                      _timer?.cancel();
                                    },
                                    onSeekEnd: () {
                                      hiddenControlPanel();
                                    },
                                  ),
                                Container(
                                  height: _theme(context).buttonBarHeight,
                                  margin: _theme(context).bottomButtonBarMargin,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: _theme(context).bottomButtonBar,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              // if (!mount)
              //   if (_mountSeekForwardButton ||
              //       _mountSeekBackwardButton ||
              //       showSwipeDuration)
              //     Column(
              //       children: [
              //         const Spacer(),
              //         Stack(
              //           alignment: Alignment.bottomCenter,
              //           children: [
              //             if (_theme(context).displaySeedBar)
              //               VideoPlayerSeekBar(
              //                 delta: _seekBarDeltaValueNotifier,
              //               ),
              //             Container(
              //               height: _theme(context).buttonBarHeight,
              //               margin: _theme(context).bottomButtonBarMargin,
              //             )
              //           ],
              //         ),
              //       ],
              //     ),
              // TODO: ??
              IgnorePointer(
                child: Padding(
                  padding: _theme(context).padding ??
                      (isFullScreen(context)
                          ? MediaQuery.of(context).padding
                          : EdgeInsets.zero),
                  child: Column(
                    children: [
                      Container(
                        height: _theme(context).buttonBarHeight,
                        margin: _theme(context).topButtonBarMargin,
                      ),
                      Expanded(
                        child: Center(
                          child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                  begin: 0.0, end: buffering ? 1.0 : 0.0),
                              duration:
                                  _theme(context).controlsTransitionDuration,
                              builder: (context, value, child) {
                                if (value > 0.0) {
                                  return Opacity(
                                      opacity: value,
                                      child: _theme(context)
                                              .bufferingIndicatorBuilder
                                              ?.call(context) ??
                                          child!);
                                }
                                return const SizedBox.shrink();
                              }),
                        ),
                      ),
                      Container(
                        height: _theme(context).buttonBarHeight,
                        margin: _theme(context).bottomButtonBarMargin,
                      )
                    ],
                  ),
                ),
              ),
              IgnorePointer(
                child: AnimatedOpacity(
                  curve: Curves.easeInOut,
                  opacity: (!mount ||
                              _theme(context)
                                  .gesturesEnabledWhileControlsVisible) &&
                          _volumeIndicator
                      ? 1.0
                      : 0.0,
                  duration: _theme(context).controlsTransitionDuration,
                  child: _theme(context)
                          .volumeIndicatorBuilder
                          ?.call(context, _volumeValue) ??
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0x88000000),
                          borderRadius: BorderRadius.circular(64.0),
                        ),
                        height: 52.0,
                        width: 108.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 52.0,
                              width: 42.0,
                              alignment: Alignment.centerRight,
                              child: Icon(
                                _volumeValue == 0.0
                                    ? Icons.volume_off
                                    : _volumeValue < 0.5
                                        ? Icons.volume_down
                                        : Icons.volume_up,
                                color: const Color(0xFFFFFFFF),
                                size: 24.0,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                '${(_volumeValue * 100.0).round()}%',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                          ],
                        ),
                      ),
                ),
              ),
              // Speedup Indicator
              IgnorePointer(
                child: Padding(
                  padding: _theme(context).padding ??
                      (
                          // Add padding in fullscreen!
                          isFullscreen(context)
                              ? MediaQuery.of(context).padding
                              : EdgeInsets.zero),
                  child: Column(
                    children: [
                      Container(
                        height: _theme(context).buttonBarHeight,
                        margin: _theme(context).topButtonBarMargin,
                      ),
                      Expanded(
                        child: AnimatedOpacity(
                          opacity: _speedUpIndicator ? 1 : 0,
                          duration: _theme(context).controlsTransitionDuration,
                          child: _theme(context).speedUpIndicatorBuilder?.call(
                                  context, _theme(context).speedUpFactor) ??
                              Container(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  margin: const EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0x88000000),
                                    borderRadius: BorderRadius.circular(64.0),
                                  ),
                                  height: 48.0,
                                  width: 108.0,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: Text(
                                          '${_theme(context).speedUpFactor.toStringAsFixed(1)}x',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 48,
                                        width: 48 - 16,
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.fast_forward,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
// Seek Indicator.
              IgnorePointer(
                child: AnimatedOpacity(
                  duration: _theme(context).controlsTransitionDuration,
                  opacity: showSwipeDuration ? 1 : 0,
                  child: _theme(context)
                          .seekIndicatorBuilder
                          ?.call(context, Duration(seconds: swipeDuration)) ??
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0x88000000),
                          borderRadius: BorderRadius.circular(64.0),
                        ),
                        height: 52.0,
                        width: 108.0,
                        child: Text(
                          swipeDuration > 0
                              ? "+ ${Duration(seconds: swipeDuration).label()}"
                              : "- ${Duration(seconds: swipeDuration.abs()).label()}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPlayerSeekBar extends StatefulWidget {
  final ValueNotifier<Duration>? delta;
  final VoidCallback? onSeekStart;
  final VoidCallback? onSeekEnd;

  const VideoPlayerSeekBar({
    super.key,
    this.delta,
    this.onSeekStart,
    this.onSeekEnd,
  });

  @override
  VideoPlayerSeekBarState createState() => VideoPlayerSeekBarState();
}

class VideoPlayerSeekBarState extends State<VideoPlayerSeekBar> {
  bool tapped = false;
  double slider = 0.0;

  late bool playing = controller(context).player.state.playing;
  late Duration position = controller(context).player.state.position;
  late Duration duration = controller(context).player.state.duration;
  late Duration buffer = controller(context).player.state.buffer;

  final List<StreamSubscription> subscriptions = [];

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void listener() {
    setState(() {
      final delta = widget.delta?.value ?? Duration.zero;
      position = controller(context).player.state.position + delta;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (subscriptions.isEmpty && widget.delta == null) {
      subscriptions.addAll(
        [
          controller(context).player.stream.playing.listen((event) {
            setState(() {
              playing = event;
            });
          }),
          controller(context).player.stream.completed.listen((event) {
            setState(() {
              position = Duration.zero;
            });
          }),
          controller(context).player.stream.position.listen((event) {
            setState(() {
              if (!tapped) {
                position = event;
              }
            });
          }),
          controller(context).player.stream.duration.listen((event) {
            setState(() {
              duration = event;
            });
          }),
          controller(context).player.stream.buffer.listen((event) {
            setState(() {
              buffer = event;
            });
          }),
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    widget.delta?.addListener(listener);
  }

  @override
  void dispose() {
    widget.delta?.removeListener(listener);
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  void onPanStart(DragStartDetails e, BoxConstraints constraints) {
    final percent = e.localPosition.dx / constraints.maxWidth;
    setState(() {
      tapped = true;
      slider = percent.clamp(0.0, 1.0);
    });
  }

  void onPanDown(DragDownDetails e, BoxConstraints constraints) {
    final percent = e.localPosition.dx / constraints.maxWidth;
    setState(() {
      tapped = true;
      slider = percent.clamp(0.0, 1.0);
    });
  }

  void onPanUpdate(DragUpdateDetails e, BoxConstraints constraints) {
    final percent = e.localPosition.dx / constraints.maxWidth;
    setState(() {
      tapped = true;
      slider = percent.clamp(0.0, 1.0);
    });
  }

  void onPointerMove(PointerEvent e, BoxConstraints constraints) {
    final percent = e.localPosition.dx / constraints.maxWidth;
    setState(() {
      tapped = true;
      slider = percent.clamp(0.0, 1.0);
    });
  }

  void onPointerDown() {
    widget.onSeekStart?.call();
    setState(() {
      tapped = true;
    });
  }

  void onPointerUp() {
    widget.onSeekEnd?.call();
    setState(() {
      tapped = false;
    });
    controller(context).player.seek(duration * slider);
    setState(() {
      // Explicitly set the position to prevent the slider from jumping.
      position = duration * slider;
    });
  }

  double get bufferPercent {
    if (buffer == Duration.zero || duration == Duration.zero) {
      return 0.0;
    } else {
      final value = buffer.inMilliseconds / duration.inMilliseconds;
      return value.clamp(0.0, 1.0);
    }
  }

  double get positionPercent {
    if (position == Duration.zero || duration == Duration.zero) {
      return 0.0;
    } else {
      final value = position.inMilliseconds / duration.inMilliseconds;
      return value.clamp(0.0, 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      margin: _theme(context).seekBarMargin,
      child: LayoutBuilder(
        builder: (context, constraints) => MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onPanStart: (e) => onPanStart(e, constraints),
            onPanDown: (e) => onPanDown(e, constraints),
            onPanUpdate: (e) => onPanUpdate(e, constraints),
            child: Listener(
              onPointerMove: (e) => onPointerMove(e, constraints),
              onPointerDown: (e) => onPointerDown(),
              onPointerUp: (e) => onPointerUp(),
              child: Container(
                color: Colors.transparent,
                width: constraints.maxWidth,
                alignment: _theme(context).seekBarAlignment,
                height: _theme(context).seekBarContainerHeight,
                padding: const EdgeInsets.only(bottom: 6),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: constraints.maxWidth,
                      height: _theme(context).seekBarHeight,
                      alignment: Alignment.bottomLeft,
                      color: _theme(context).seekBarColor,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomLeft,
                        children: [
                          Container(
                            width: constraints.maxWidth * bufferPercent,
                            color: _theme(context).seekBarBufferColor,
                          ),
                          Container(
                            width: tapped
                                ? constraints.maxWidth * slider
                                : constraints.maxWidth * positionPercent,
                            color: _theme(context).seekBarPositionColor,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: tapped
                          ? (constraints.maxWidth -
                                  _theme(context).seekBarThumbSize / 2) *
                              slider
                          : (constraints.maxWidth -
                                  _theme(context).seekBarThumbSize / 2) *
                              positionPercent,
                      bottom: -1.0 * _theme(context).seekBarThumbSize / 2 +
                          _theme(context).seekBarHeight / 2,
                      child: Container(
                        width: _theme(context).seekBarThumbSize,
                        height: _theme(context).seekBarThumbSize,
                        decoration: BoxDecoration(
                          color: _theme(context).seekBarThumbColor,
                          borderRadius: BorderRadius.circular(
                              _theme(context).seekBarThumbSize / 2),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
