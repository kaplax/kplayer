import 'package:flutter/material.dart';
import 'package:kplayer/widgets/common/video_player_controls/index.dart';
import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayer extends StatefulWidget {
  final String url;
  const VideoPlayer({super.key, required this.url});
  @override
  State<StatefulWidget> createState() => _VideoPlayer();
}

class _VideoPlayer extends State<VideoPlayer> {
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    // Play a [Media] or [Playlist].
    player.open(Media(widget.url));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Video(
            controller: controller,
            controls: VideoPlayerControls,
          ),
        ),
      ),
    );
  }
}
