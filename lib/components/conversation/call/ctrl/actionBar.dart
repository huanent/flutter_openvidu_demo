import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/components/conversation/call/ctrl/answerBtn.dart';
import 'package:flutter_openvidu_demo/components/conversation/call/ctrl/closeBtn.dart';
import 'package:flutter_openvidu_demo/models/callModel.dart';
import 'package:flutter_openvidu_demo/models/conversationModel.dart';
import 'package:provider/provider.dart';

class ActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final enterd = context.select<CallModel, bool>((value) => value.enterd);
    final isOffer = context.read<ConversationModel>().isCallOffer;
    final List<Widget> children = [CloseBtn()];
    if (!enterd && !isOffer) children.add(AnswerBtn());

    return Selector<CallModel, bool>(
      builder: (context, float, child) {
        return AnimatedPositioned(
          child: Row(
            children: children,
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
