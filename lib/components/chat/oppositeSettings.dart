import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/models/chatModel.dart';
import 'package:provider/provider.dart';

class OppositeSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: Consumer<ChatModel>(
        builder: (context, value, child) => Row(
          children: [
            IconButton(
              icon: Icon(
                value.oppsiteAudio ? Icons.mic : Icons.mic_off,
                color: Colors.white,
              ),
              onPressed: () {
                value.oppsiteAudio = !value.oppsiteAudio;
              },
            ),
            IconButton(
              icon: Icon(
                value.oppsiteVideo ? Icons.videocam : Icons.videocam_off,
                color: Colors.white,
              ),
              onPressed: () {
                value.oppsiteVideo = !value.oppsiteVideo;
              },
            ),
            IconButton(
              icon: Icon(
                value.oppsiteSpeakerphone ? Icons.speaker_phone : Icons.phone,
                color: Colors.white,
              ),
              onPressed: () {
                value.oppsiteSpeakerphone = !value.oppsiteSpeakerphone;
              },
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
