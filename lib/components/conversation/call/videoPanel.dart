import 'package:flutter/widgets.dart';
import 'package:flutter_openvidu_demo/models/callModel.dart';
import 'package:provider/provider.dart';

import 'opposite.dart';
import 'self.dart';

class VideoPanel extends StatelessWidget {
  const VideoPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final callModel = context.read<CallModel>();

    return Stack(
      children: [
        Opposite(),
        Selector<CallModel, bool>(
          builder: (context, float, child) {
            return Visibility(
              child: child,
              visible: !float || callModel.oppositeStream == null,
            );
          },
          selector: (ctx, s) => s.float,
          child: Self(),
        ),
      ],
    );
  }
}
