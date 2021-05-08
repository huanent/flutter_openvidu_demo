import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/components/common/futureWrapper.dart';
import 'package:flutter_openvidu_demo/components/conversation/call/floatPanel.dart';
import 'package:flutter_openvidu_demo/models/callModel.dart';
import 'package:flutter_openvidu_demo/models/conversationModel.dart';
import 'package:flutter_openvidu_demo/models/tokenModel.dart';
import 'package:kooboo_openvidu/models/streamMode.dart';
import 'package:provider/provider.dart';

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
            return FloatPanel(
              isAudio: _isAudio(conversationModel),
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
