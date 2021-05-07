import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kooboo_openvidu/models/error.dart';
import 'package:kooboo_openvidu/models/event.dart';
import 'package:kooboo_openvidu/models/streamMode.dart';
import 'package:kooboo_openvidu/session.dart';

class CallModel extends ChangeNotifier {
  Session _session;
  MediaStream _localStream;
  MediaStream _oppositeStream;
  String _oppositeId;
  bool _float = false;
  OpenViduError _error;

  MediaStream get localStream => _localStream;
  MediaStream get oppositeStream => _oppositeStream;
  bool get float => _float;

  set float(bool value) {
    _float = value;
    notifyListeners();
  }

  Future<void> start(String userName, String token, StreamMode mode) async {
    try {
      _session = Session(token);
      _localStream = await _session.startLocalPreview(mode);
      _listenSessionEvents();
      await _session.connect(userName);
      notifyListeners();
    } catch (e) {
      _error = e is OpenViduError ? e : OtherError();
      await stop();
    }
  }

  void _listenSessionEvents() {
    _session.on(Event.userPublished, (params) {
      _session.subscribeRemoteStream(params["id"]);
    });

    _session.on(Event.addStream, (params) {
      _oppositeStream = params["stream"];
      _oppositeId = params["id"];
      notifyListeners();
    });

    _session.on(Event.removeStream, (params) {
      if (params["id"] == _oppositeId) {
        _oppositeStream = null;
        notifyListeners();
      }
    });

    _session.on(Event.error, (params) {
      if (params.containsKey("error")) {
        _error = params["error"];
      } else {
        _error = OtherError();
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }

  Future<void> stop() async {
    await _localStream?.dispose();

    try {
      await _session?.disconnect();
    } catch (e) {}

    _session = null;
  }
}
