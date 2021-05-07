import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/components/common/mediaStreamView.dart';
import 'package:flutter_openvidu_demo/models/callModel.dart';
import 'package:provider/provider.dart';

class Self extends StatelessWidget {
  const Self({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final srceen = MediaQuery.of(context);
    final callModel = context.read<CallModel>();

    return Selector<CallModel, bool>(
      builder: (context, float, child) {
        return child;
      },
      selector: (ctx, r) => r.oppositeStream != null,
      child: ClipRect(
        child: Align(
          child: MediaStreamView(
            stream: callModel.localStream,
            mirror: true,
          ),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
