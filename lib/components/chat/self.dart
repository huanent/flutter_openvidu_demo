import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/components/loading.dart';
import 'package:flutter_openvidu_demo/models/chatModel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Self extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final render = RTCVideoRenderer();

    return FutureBuilder(
      future: render.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Loading();
        }

        return Consumer<ChatModel>(
          builder: (context, value, child) {
            render.srcObject = value.localStream;

            return AnimatedContainer(
              curve: Curves.easeInOut,
              child: RTCVideoView(
                render,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                mirror: true,
              ),
              width: value.float ? 80 : size.width,
              height: value.float ? 100 : size.height,
              margin: value.float
                  ? EdgeInsets.fromLTRB(20, 70, 0, 0)
                  : EdgeInsets.all(0),
              duration: Duration(milliseconds: 500),
            );
          },
        );
      },
    );
  }
}
