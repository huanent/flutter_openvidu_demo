import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/models/conversationModel.dart';
import 'package:provider/provider.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var startCall = context.read<ConversationModel>().startCall;

    return Container(
      child: Align(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => startCall(CallMode.Video),
                  child: Text("视频通话"),
                ),
                TextButton(
                  onPressed: () => startCall(CallMode.Audio),
                  child: Text("语音通话"),
                )
              ],
            ),
            TextField()
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        alignment: Alignment.center,
      ),
    );
  }
}
