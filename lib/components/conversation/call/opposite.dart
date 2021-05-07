import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/components/common/mediaStreamView.dart';
import 'package:flutter_openvidu_demo/models/callModel.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';

class Opposite extends StatelessWidget {
  const Opposite({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<CallModel, MediaStream>(
      builder: (context, value, child) {
        return value == null
            ? SizedBox.expand()
            : MediaStreamView(
                stream: value,
                mirror: true,
              );
      },
      selector: (ctx, s) => s.oppositeStream,
    );
  }
}
