import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_openvidu_demo/components/common/futureWrapper.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class MediaStreamView extends StatefulWidget {
  final bool mirror;
  final MediaStream stream;

  const MediaStreamView({
    Key key,
    this.stream,
    this.mirror = true,
  }) : super(key: key);

  @override
  _MediaStreamViewState createState() => _MediaStreamViewState();
}

class _MediaStreamViewState extends State<MediaStreamView> {
  RTCVideoRenderer _render;

  @override
  Widget build(BuildContext context) {
    if (widget.stream == null) return Container(color: Colors.black);
    _render = RTCVideoRenderer();

    return FutureWrapper(
      future: _render.initialize(),
      builder: (context) {
        _render.srcObject = widget.stream;
        return RTCVideoView(
          _render,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          mirror: widget.mirror,
        );
      },
    );
  }

  @override
  void dispose() {
    _render?.srcObject = null;
    _render?.dispose();
    super.dispose();
  }
}
