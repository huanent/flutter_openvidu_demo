import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/models/callModel.dart';
import 'package:provider/provider.dart';

class Timer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final srceen = MediaQuery.of(context);
    return Selector<CallModel, bool>(
      builder: (context, float, child) {
        return AnimatedPositioned(
          curve: Curves.easeInOut,
          child: child ?? Container(),
          duration: Duration(milliseconds: 500),
          right: float ? 20 + srceen.padding.right : 0,
          top: (float ? 180 : 40) + srceen.padding.top,
          width: float ? 100 : srceen.size.width,
        );
      },
      selector: (ctx, s) => s.float,
      child: Center(
        child: Text(
          "29:30:00",
          style: TextStyle(color: Colors.redAccent),
        ),
      ),
    );
  }
}
