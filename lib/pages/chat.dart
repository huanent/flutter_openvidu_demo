import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/components/chat/ctrlBar.dart';
import 'package:flutter_openvidu_demo/components/chat/opposite.dart';
import 'package:flutter_openvidu_demo/components/chat/self.dart';
import 'package:flutter_openvidu_demo/models/chatModel.dart';

import 'package:provider/provider.dart';

class Chat extends StatelessWidget {
  static const routeName = "/chat";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
          create: (context) => ChatModel(),
          builder: (context, child) {
            final arguments = ModalRoute.of(context).settings.arguments
                as Map<String, String>;
            final model = Provider.of<ChatModel>(context, listen: false);
            model.start(arguments["token"], arguments["userName"]);
            return child;
          },
          child: Stack(
            children: [
              Opposite(),
              Self(),
              Align(
                alignment: Alignment.bottomCenter,
                child: CtrlBar(),
              )
            ],
          )),
    );
  }
}
