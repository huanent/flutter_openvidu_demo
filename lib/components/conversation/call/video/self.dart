import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/components/common/mediaStreamView.dart';
import 'package:flutter_openvidu_demo/models/callModel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Self extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localStream = context.select<CallModel, MediaStream>(
      (value) => value.localStream,
    );

    final hiddenLocal = context.select<CallModel, bool>(
      (value) => value.hiddenLocal,
    );

    return Visibility(
      child: ClipRect(
        child: Align(
          child: MediaStreamView(
            stream: localStream,
            mirror: true,
          ),
          alignment: Alignment.center,
        ),
      ),
      visible: !hiddenLocal,
    );
  }
}
