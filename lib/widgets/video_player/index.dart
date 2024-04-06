import 'package:flutter/material.dart';
import 'package:kplayer/widgets/common/video_player_controls/index.dart';
import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key});
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
    player.open(Media(
        'http://192.168.1.91:3000/favor/movie/normal/%E5%B0%84%E9%9B%95%E8%8B%B1%E9%9B%84%E4%BC%A0%E4%B9%8B%E4%B8%9C%E6%88%90%E8%A5%BF%E5%B0%B1.mkv'));
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
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 9.0 / 16.0,
            // Use [Video] widget to display video output.
            child: Video(
              controller: controller,
              controls: VideoPlayerControls,
              // controls: (state) {
              //   return Column(
              //     children: [
              //       Center(
              //           child: IconButton(
              //               onPressed: () {
              //                 state.widget.controller.player.playOrPause();
              //               },
              //               icon: StreamBuilder(
              //                   stream:
              //                       state.widget.controller.player.stream.playing,
              //                   builder: (context, playing) {
              //                     // state.widget.controller.player.state.position.inSeconds.toDouble()
              //                     return Icon(playing.data == true
              //                         ? Icons.pause
              //                         : Icons.play_arrow);
              //                   }))),
              //       StreamBuilder(
              //           stream: state.widget.controller.player.stream.position,
              //           builder: (context, position) {
              //             return Slider(
              //                 value: position.data!.inSeconds.toDouble(),
              //                 min: 0,
              //                 max: state.widget.controller.player.state.duration
              //                     .inSeconds
              //                     .toDouble(),
              //                 onChanged: (value) {
              //                   controller.player
              //                       .seek(Duration(seconds: value.toInt()));
              //                 });
              //           })
              //     ],
              //   );
              // },
            ),
          ),
        ),
      ),
    );
  }
}
