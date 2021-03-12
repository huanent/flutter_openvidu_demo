import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/models/chatModel.dart';
import 'package:provider/provider.dart';
import 'videoPlayer.dart';

class Self extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final videoPlayerKey = GlobalKey<VideoPlayerState>();

    return Consumer<ChatModel>(
      builder: (context, value, child) {
        if (videoPlayerKey.currentState != null) {
          videoPlayerKey.currentState.changeStream(value.localStream);
        }

        return AnimatedContainer(
          curve: Curves.easeInOut,
          child: child,
          width: value.float ? 80 : size.width,
          height: value.float ? 100 : size.height,
          margin: value.float
              ? EdgeInsets.fromLTRB(20, 70, 0, 0)
              : EdgeInsets.all(0),
          duration: Duration(milliseconds: 500),
        );
      },
      child: VideoPlayer(videoPlayerKey, true),
    );
  }
}
