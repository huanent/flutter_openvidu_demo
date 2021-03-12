import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/models/chatModel.dart';
import 'package:provider/provider.dart';
import 'videoPlayer.dart';

class Opposite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final videoPlayerKey = GlobalKey<VideoPlayerState>();
    return Consumer<ChatModel>(
      builder: (context, value, child) {
        if (videoPlayerKey.currentState != null) {
          videoPlayerKey.currentState.changeStream(value.oppositeStream);
        }

        return child;
      },
      child: VideoPlayer(videoPlayerKey, false),
    );
  }
}
