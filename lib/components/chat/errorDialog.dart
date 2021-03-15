import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/models/chatModel.dart';
import 'package:flutter_openvidu_demo/pages/chat.dart';
import 'package:provider/provider.dart';

class ErrorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var model = context.watch<ChatModel>();
    final arguments = ModalRoute.of(context).settings.arguments;

    if (model.openViduError != null) {
      Future.delayed(
        Duration.zero,
        () async {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('提示'),
              content: Text(model.openViduError.message),
              actions: <Widget>[
                TextButton(
                  child: Text('返回'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text('重新载入'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
            barrierDismissible: false,
          );

          await Navigator.of(context).maybePop();

          if (result == true) {
            Navigator.pushNamed(
              context,
              Chat.routeName,
              arguments: arguments,
            );
          }
        },
      );
    }

    return Container();
  }
}
