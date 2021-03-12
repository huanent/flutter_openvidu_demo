import 'dart:convert';

import 'jsonRpc.dart';
import 'models/token.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'connection.dart';
import 'streamCreator.dart';

class LocalConnection extends Connection {
  LocalConnection(String id, Token token, JsonRpc rpc) : super(id, token, rpc);
  bool audioOnly;
  bool hasAudio;
  bool hasVideo;
  bool audioActive;
  bool videoActive;
  String typeOfVideo = "CAMERA";
  int frameRate;
  int width;
  int height;
  final bool doLoopback = false;

  void setStream(
    MediaStream stream,
    StreamMode mode,
    VideoParams videoParams,
  ) {
    this.stream = stream;
    audioActive = true;
    hasAudio = true;

    if (mode == StreamMode.audio) {
      audioOnly = true;
    } else {
      hasVideo = true;
      videoActive = true;
    }

    if (mode == StreamMode.srceen) typeOfVideo = "SCREEN";

    frameRate = videoParams.frameRate;
    width = videoParams.width;
    height = videoParams.height;
  }

  Future<void> publishStream() async {
    final connection = await peerConnection;
    connection.addStream(stream);
    final offer = await connection.createOffer(constraints);
    connection.setLocalDescription(offer);

    final result = await rpc.send(
      "publishVideo",
      params: {
        'audioOnly': audioOnly,
        'hasAudio': hasVideo,
        'doLoopback': doLoopback,
        'hasVideo': hasVideo,
        'audioActive': audioActive,
        'videoActive': videoActive,
        'typeOfVideo': typeOfVideo,
        'frameRate': frameRate,
        'videoDimensions': json.encode({"width": width, "height": height}),
        'sdpOffer': offer.sdp
      },
      hasResult: true,
    );

    streamId = result["id"];
    final answer = RTCSessionDescription(result['sdpAnswer'], 'answer');
    await connection.setRemoteDescription(answer);
  }

  Future<void> publishVideo(bool enable) async {
    if (stream == null) return;
    stream.getVideoTracks().forEach((e) => e.enabled = enable);
    videoActive = enable;
    await _streamPropertyChanged("videoActive", videoActive, "publishVideo");
  }

  Future<void> publishAudio(bool enable) async {
    if (stream == null) return;
    stream.getAudioTracks().forEach((e) => e.enabled = enable);
    audioActive = enable;
    await _streamPropertyChanged("audioActive", audioActive, "publishAudio");
  }

  Future<void> _streamPropertyChanged(
    String property,
    Object value,
    String reason,
  ) async {
    await rpc.send(
      "streamPropertyChanged",
      params: {
        "streamId": streamId,
        "property": property,
        "newValue": value,
        "reason": reason,
      },
    );
  }
}
