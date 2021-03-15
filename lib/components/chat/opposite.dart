import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/components/loading.dart';
import 'package:flutter_openvidu_demo/models/chatModel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Opposite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final render = RTCVideoRenderer();
    return FutureBuilder(
      future: render.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Loading();
        }

        return Consumer<ChatModel>(
          builder: (context, value, child) {
            render.srcObject = value.oppositeStream;
            return RTCVideoView(
              render,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            );
          },
        );
      },
    );
  }
}
