import 'package:flutter/foundation.dart';
import 'package:kooboo_openvidu/models/event.dart';
import 'package:kooboo_openvidu/models/streamMode.dart';
import 'package:kooboo_openvidu/session.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class ChatModel extends ChangeNotifier {
  MediaStream _localStream;

  MediaStream get localStream => _localStream;

  set localStream(MediaStream localStream) {
    _localStream = localStream;
    notifyListeners();
  }

  MediaStream _oppositeStream;

  MediaStream get oppositeStream => _oppositeStream;

  set oppositeStream(MediaStream oppositeStream) {
    _oppositeStream = oppositeStream;
    notifyListeners();
  }

  String _oppositeId;

  bool _microphone = true;

  bool get microphone => _microphone;

  set microphone(bool microphone) {
    _microphone = microphone;
    _session.publishAudio(microphone);
    notifyListeners();
  }

  bool _video = true;

  bool get video => _video;

  set video(bool video) {
    _video = video;
    _session.publishVideo(video);
    notifyListeners();
  }

  Session _session;
  bool get float => _oppositeStream != null;

  Future<void> start(String token, String userName) async {
    if (_session != null) return;

    //webrtc 开始
    _session = Session(token);

    _session.on(Event.userPublished, (params) {
      _session.subscribeRemoteStream(params["id"]);
    });

    _session.on(Event.addStream, (params) {
      oppositeStream = params["stream"];
      _oppositeId = params["id"];
    });

    _session.on(Event.removeStream, (params) {
      if (params["id"] == _oppositeId) {
        oppositeStream = null;
      }
    });

    await _session.connect(userName);
    localStream = await _session.startLocalPreview(StreamMode.frontCamera);
    _session.publishLocalStream();

    //webrtc 结束
  }

  Future<void> stop() async {
    if (_session == null) return;
    await _session?.disconnect();
    await localStream?.dispose();
    await oppositeStream?.dispose();
  }
}
