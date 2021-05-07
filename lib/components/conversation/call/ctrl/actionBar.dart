import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/models/callModel.dart';
import 'package:flutter_openvidu_demo/models/conversationModel.dart';
import 'package:provider/provider.dart';

class ActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<CallModel, bool>(
      builder: (context, float, child) {
        return AnimatedPositioned(
          child: Row(
            children: [
              FloatingActionButton(
                heroTag: "close",
                child: Icon(Icons.close),
                onPressed: context.read<ConversationModel>().stopCall,
                backgroundColor: Colors.red.shade300,
                mini: float,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          duration: Duration(milliseconds: 500),
          bottom: float ? 10 : 50,
          left: 0,
          right: 0,
        );
      },
      selector: (ctx, s) => s.float,
    );
  }
}
