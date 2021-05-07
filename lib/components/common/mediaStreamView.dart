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
  void initState() {
    if (widget.stream != null) _render = RTCVideoRenderer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureWrapper(
      future: _render?.initialize(),
      builder: (context) {
        if (_render != null) {
          _render.srcObject = widget.stream;
          return RTCVideoView(
            _render,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            mirror: widget.mirror,
          );
        } else {
          return SizedBox.expand();
        }
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
