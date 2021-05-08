import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/components/common/futureWrapper.dart';
import 'package:flutter_openvidu_demo/components/conversation/call/callPanel.dart';
import 'package:flutter_openvidu_demo/components/conversation/call/timer.dart';
import 'package:flutter_openvidu_demo/models/callModel.dart';
import 'package:flutter_openvidu_demo/models/conversationModel.dart';
import 'package:flutter_openvidu_demo/models/tokenModel.dart';
import 'package:kooboo_openvidu/models/streamMode.dart';
import 'package:provider/provider.dart';

import 'call/errorDialog.dart';

class Call extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tokenModel = ModalRoute.of(context).settings.arguments as TokenModel;
    final conversationModel = context.read<ConversationModel>();

    return ChangeNotifierProvider<CallModel>(
      create: (ctx) => CallModel(),
      builder: (context, child) {
        final callModel = context.read<CallModel>();

        final future = new Future(() async {
          final token = await tokenModel.getToken();

          final mode = _isAudio(conversationModel)
              ? StreamMode.audio
              : StreamMode.frontCamera;

          await callModel.start(tokenModel.userName, token, mode);
        });

        return FutureWrapper(
          future: future,
          builder: (context) {
            return Selector<CallModel, bool>(
              builder: (context, value, child) {
                //如果发现对方已经在房间内推流,而自己还没有推,则立即推流
                if (!callModel.enterd && value) callModel.enter();

                return child;
              },
              selector: (ctx, s) => s.floatSelf,
              child: Stack(
                children: [
                  Container(color: Colors.black),
                  CallPanel(isAudio: _isAudio(conversationModel)),
                  Timer(),
                  ErrorDialog()
                ],
                fit: StackFit.expand,
              ),
            );
          },
        );
      },
    );
  }

  bool _isAudio(ConversationModel conversationModel) {
    return conversationModel.callMode == CallMode.Audio;
  }
}
