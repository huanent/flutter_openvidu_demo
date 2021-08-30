import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/models/callModel.dart';
import 'package:flutter_openvidu_demo/models/conversationModel.dart';
import 'package:kooboo_openvidu/models/error.dart';
import 'package:provider/provider.dart';

class ErrorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var conversationModel = context.read<ConversationModel>();

    return Selector<CallModel, OpenViduError?>(
      builder: (context, error, child) {
        if (error == null) return SizedBox.shrink();

        return Container(
          child: AlertDialog(
            title: Text('提示'),
            content: Text(error.message),
            actions: <Widget>[
              TextButton(
                  child: Text('返回'),
                  onPressed: () => conversationModel.stopCall()),
            ],
          ),
          color: Colors.black45,
        );
      },
      selector: (ctx, s) => s.error,
    );
  }
}
