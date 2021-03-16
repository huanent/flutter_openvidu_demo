import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/components/chat/ctrlBar.dart';
import 'package:flutter_openvidu_demo/components/chat/errorDialog.dart';
import 'package:flutter_openvidu_demo/components/chat/opposite.dart';
import 'package:flutter_openvidu_demo/components/chat/self.dart';
import 'package:flutter_openvidu_demo/components/loading.dart';
import 'package:flutter_openvidu_demo/models/chatModel.dart';
import 'package:flutter_openvidu_demo/models/tokenModel.dart';
import 'package:flutter_openvidu_demo/utils/token.dart';

import 'package:provider/provider.dart';

class Chat extends StatelessWidget {
  static const routeName = "/chat";

  @override
  Widget build(BuildContext context) {
    final tokenModel = ModalRoute.of(context).settings.arguments as TokenModel;

    if (Platform.isAndroid) {}

    return Scaffold(
      body: ChangeNotifierProvider(
          create: (context) => ChatModel(),
          builder: (context, child) {
            final model = Provider.of<ChatModel>(context, listen: false);
            return FutureBuilder(
              future: Future(() async {
                final token = await Token(tokenModel.server, tokenModel.session)
                    .getToken();
                await model.start(token, tokenModel.userName);
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Loading();
                }

                return child;
              },
            );
          },
          child: Stack(
            children: [
              Opposite(),
              Self(),
              Align(
                alignment: Alignment.bottomCenter,
                child: CtrlBar(),
              ),
              ErrorDialog(),
            ],
          )),
    );
  }
}
