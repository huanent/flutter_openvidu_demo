import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/components/home/homeForm.dart';
import 'package:flutter_openvidu_demo/models/tokenModel.dart';
import 'package:flutter_openvidu_demo/pages/conversation.dart';
import 'package:flutter_openvidu_demo/utils/permission.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  static const routeName = "/home";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    PermissionChecker.check();

    void submit(TokenModel model) async {
      Navigator.pushNamed(context, Conversation.routeName, arguments: model);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: ChangeNotifierProvider(
          create: (context) => TokenModel(),
          builder: (context, child) => Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: HomeForm(),
              ),
              Align(
                child: Container(
                  child: Consumer<TokenModel>(
                    builder: (context, value, child) => MaterialButton(
                      child: Text("进入房间"),
                      onPressed: () => submit(value),
                      color: theme.accentColor,
                      textColor: Colors.white,
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 50),
                ),
                alignment: Alignment.bottomCenter,
              )
            ],
          ),
        ));
  }
}
