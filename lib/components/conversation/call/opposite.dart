import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/components/common/mediaStreamView.dart';
import 'package:flutter_openvidu_demo/models/callModel.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';

class Opposite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final callModel = context.read<CallModel>();
    return Selector<CallModel, MediaStream>(
      builder: (context, value, child) {
        //如果发现对方已经在房间内推流,而自己还没有推,则立即推流
        if (!callModel.enterd && value != null) {
          callModel.enter();
        }

        return MediaStreamView(
          stream: value,
          mirror: true,
        );
      },
      selector: (ctx, s) => s.oppositeStream,
    );
  }
}
