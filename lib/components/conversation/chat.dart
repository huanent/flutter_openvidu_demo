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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => startCall(CallMode.Video, true),
                  child: Text("发起视频通话"),
                ),
                TextButton(
                  onPressed: () => startCall(CallMode.Audio, true),
                  child: Text("发起语音通话"),
                ),
                TextButton(
                  onPressed: () => startCall(CallMode.Video, false),
                  child: Text("进入视频响铃状态"),
                ),
                TextButton(
                  onPressed: () => startCall(CallMode.Audio, false),
                  child: Text("进入语音响铃状态"),
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
