import 'package:flutter/widgets.dart';
import 'package:flutter_openvidu_demo/models/callModel.dart';
import 'package:provider/provider.dart';

import 'opposite.dart';
import 'self.dart';

class VideoPanel extends StatefulWidget {
  const VideoPanel({Key key}) : super(key: key);

  @override
  _VideoPanelState createState() => _VideoPanelState();
}

class _VideoPanelState extends State<VideoPanel> {
  final self = Self();
  final opposite = Opposite();

  @override
  Widget build(BuildContext context) {
    final srceen = MediaQuery.of(context);

    return Stack(
      children: [
        opposite,
        Selector<CallModel, bool>(
          builder: (context, value, child) {
            if (value) {
              return Positioned(
                child: self,
                width: 100,
                height: 150,
                right: 20 + srceen.padding.right,
                top: 20 + srceen.padding.top,
              );
            } else {
              return self;
            }
          },
          selector: (ctx, s) => s.floatSelf,
        )
      ],
    );
  }
}
