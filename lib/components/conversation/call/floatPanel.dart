import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_openvidu_demo/components/conversation/call/ctrl.dart';
import 'package:flutter_openvidu_demo/models/callModel.dart';
import 'package:provider/provider.dart';

import 'audioPanel.dart';
import 'videoPanel.dart';

class FloatPanel extends StatelessWidget {
  final bool isAudio;
  const FloatPanel({Key key, this.isAudio = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final srceen = MediaQuery.of(context);

    return Selector<CallModel, bool>(
      builder: (context, float, child) {
        return AnimatedPositioned(
          curve: Curves.easeInOut,
          child: InkWell(
            child: child,
            onTap: () {
              if (float) context.read<CallModel>().float = false;
            },
          ),
          duration: Duration(milliseconds: 500),
          right: float ? 20 + srceen.padding.right : 0,
          top: float ? 20 + srceen.padding.top : 0,
          width: float ? 100 : srceen.size.width,
          height: float ? 150 : srceen.size.height,
        );
      },
      selector: (ctx, s) => s.float,
      child: Stack(
        children: [
          isAudio ? AudioPanel() : VideoPanel(),
          Ctrl(),
        ],
      ),
    );
  }
}