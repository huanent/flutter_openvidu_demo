import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/models/chatModel.dart';
import 'package:provider/provider.dart';

class CtrlBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      child: Consumer<ChatModel>(
        builder: (context, value, child) => Row(
          children: [
            FloatingActionButton(
              heroTag: "microphone",
              child: Icon(value.microphone ? Icons.mic : Icons.mic_off),
              onPressed: () {
                value.microphone = !value.microphone;
              },
            ),
            FloatingActionButton(
              heroTag: "close",
              child: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              backgroundColor: Colors.red.shade300,
            ),
            FloatingActionButton(
              heroTag: "video",
              child: Icon(value.video ? Icons.videocam : Icons.videocam_off),
              onPressed: () {
                value.video = !value.video;
              },
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
    );
  }
}
