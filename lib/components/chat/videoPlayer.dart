import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoPlayer extends StatefulWidget {
  final bool _mirror;

  VideoPlayer(Key key, this._mirror) : super(key: key);

  @override
  VideoPlayerState createState() => VideoPlayerState();
}

class VideoPlayerState extends State<VideoPlayer> {
  final _render = RTCVideoRenderer();
  bool _initialized = false;

  Future changeStream(MediaStream stream) async {
    if (!_initialized) {
      await _render.initialize();
      _initialized = true;
    }
    setState(() {
      _render.srcObject = stream;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RTCVideoView(
      _render,
      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      mirror: widget._mirror,
    );
  }
}
