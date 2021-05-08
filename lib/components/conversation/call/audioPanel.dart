import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_openvidu_demo/components/common/mediaStreamView.dart';
import 'package:flutter_openvidu_demo/models/callModel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class AudioPanel extends StatelessWidget {
  const AudioPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localStream = context.select<CallModel, MediaStream>(
      (v) => v.localStream,
    );

    final oppositeStream = context.select<CallModel, MediaStream>(
      (v) => v.oppositeStream,
    );

    return Stack(
      children: [
        Visibility(
          child: Stack(
            children: [
              MediaStreamView(stream: localStream),
              MediaStreamView(stream: oppositeStream),
            ],
          ),
          visible: false,
        ),
        Container(
          color: Colors.black45,
          child: Center(
            child: Text(
              "语音通话,替换为项目背景图",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
