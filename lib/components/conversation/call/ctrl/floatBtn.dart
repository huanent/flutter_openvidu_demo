import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/models/callModel.dart';
import 'package:provider/provider.dart';

class FloatBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final callModel = context.read<CallModel>();

    return Selector<CallModel, bool>(
        builder: (context, float, child) {
          return AnimatedPositioned(
              child: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  callModel.float = true;
                },
              ),
              top: float ? -100 : 0,
              left: 0,
              right: 0,
              duration: Duration(milliseconds: 500),
            );
        },
        selector: (ctx, s) => s.float);
  }
}
