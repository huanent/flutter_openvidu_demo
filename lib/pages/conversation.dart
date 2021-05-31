import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/components/conversation/call.dart';
import 'package:flutter_openvidu_demo/components/conversation/chat.dart';
import 'package:flutter_openvidu_demo/models/conversationModel.dart';
import 'package:provider/provider.dart';

class Conversation extends StatelessWidget {
  static const routeName = "/conversation";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<ConversationModel>(
        create: (context) => ConversationModel(),
        builder: (context, child) {
          return Stack(
            children: [
              Chat(),
              Selector<ConversationModel, bool>(
                builder: (context, call, child) {
                  return call ? Call() : SizedBox.expand();
                },
                selector: (ctx, s) => s.callMode != CallMode.None,
              ),
            ],
          );
        },
      ),
    );
  }
}
