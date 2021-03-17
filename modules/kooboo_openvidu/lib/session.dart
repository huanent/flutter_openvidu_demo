import 'dart:convert';
import 'dart:io';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kooboo_openvidu/models/error.dart';

import 'connection.dart';
import 'jsonRpc.dart';
import 'localConnection.dart';
import 'models/event.dart';
import 'models/streamMode.dart';
import 'models/token.dart';
import 'models/videoParams.dart';
import 'remoteConnection.dart';
import 'streamCreator.dart';

class Session {
  Token _token;
  String _userName;
  bool _active = true;
  JsonRpc _rpc;
  LocalConnection _localConnection;
  Map<String, RemoteConnection> _remoteConnections = {};
  Map<Event, Function(Map<String, dynamic> params)> _handlers = {};

  List<Connection> get _allConnection {
    return [
      ..._remoteConnections.entries.map((e) => e.value),
      _localConnection,
    ];
  }

  Session(url) {
    _token = Token(url);
  }

  Future<void> connect([String userName]) async {
    _userName = userName ?? DateTime.now().millisecondsSinceEpoch;
    final url = "wss://${_token.host}/openvidu?sessionId=${_token.sessionId}";
    _rpc = JsonRpc(onMessage: _onRpcMessage);

    try {
      _rpc.connect(url);
      _heartbeat();
    } catch (e) {
      _rpc.disconnect();
      throw NetworkError();
    }

    final response = await _joinRoom(_userName);
    _dispatchEvent(Event.joinRoom, null);

    try {
      _localConnection = LocalConnection(response["id"], _token, _rpc);
      _addAlreadyInRoomConnections(response);
    } catch (e) {
      throw OtherError();
    }
  }

  Future<void> disconnect() async {
    _active = false;
    await _rpc.send("leaveRoom");
    await Future.wait(_allConnection.map((e) => e?.close()));
    await _rpc.disconnect();
  }

  Future<MediaStream> startLocalPreview(
    StreamMode mode, {
    VideoParams videoParams,
  }) async {
    videoParams = videoParams ?? VideoParams.middle;
    try {
      return await StreamCreator.create(mode, videoParams: videoParams);
    } catch (e) {
      throw NotPermissionError();
    }
  }

  Future<void> stopLocalPreview() async => StreamCreator.dispose();

  Future<void> publishLocalStream({
    bool video = true,
    bool audio = true,
  }) {
    if (StreamCreator.stream == null) {
      throw "Please call startLocalPreview first";
    }

    _localConnection.setStream(
      StreamCreator.stream,
      StreamCreator.mode,
      StreamCreator.videoParams,
    );

    return _localConnection.publishStream(video, audio);
  }

  Future<void> publishVideo(bool enable) {
    return _localConnection.publishVideo(enable);
  }

  Future<void> publishAudio(bool enable) {
    return _localConnection.publishAudio(enable);
  }

  Future<void> subscribeRemoteStream(
    String id, {
    bool video = true,
    bool audio = true,
    bool speakerphone = false,
  }) async {
    if (!_remoteConnections.containsKey(id)) return;
    _remoteConnections[id].subscribeStream(
      _dispatchEvent,
      video,
      audio,
      speakerphone,
    );
  }

  void setRemoteVideo(String id, bool enable) {
    if (!_remoteConnections.containsKey(id)) return;
    _remoteConnections[id].enableVideo(enable);
  }

  void setRemoteAudio(String id, bool enable) {
    if (!_remoteConnections.containsKey(id)) return;
    _remoteConnections[id].enableAudio(enable);
  }

  void setRemoteSpeakerphone(String id, bool enable) {
    if (!_remoteConnections.containsKey(id)) return;
    _remoteConnections[id].enableSpeakerphone(enable);
  }

  void on(Event event, Function(Map<String, dynamic> params) handler) {
    _handlers[event] = handler;
  }

  Future<Map<String, dynamic>> _joinRoom(String userName) async {
    final initializeParams = {
      "token": _token.url,
      "session": _token.sessionId,
      "platform": Platform.isAndroid ? 'Android' : 'iOS',
      "secret": "",
      "recorder": false,
      "metadata": json.encode({"clientData": userName})
    };

    try {
      return await _rpc.send(
        "joinRoom",
        params: initializeParams,
        hasResult: true,
      );
    } catch (e) {
      if (e["code"] == 401) throw TokenError();
      throw OtherError();
    }
  }

  Future<void> _heartbeat() async {
    try {
      await _rpc.send("ping", params: {"interval": 5000}, hasResult: true);
    } catch (e) {
      _dispatchEvent(Event.error, {"error": NetworkError()});
    }

    Future<void> loop() async {
      while (_active) {
        await Future.delayed(Duration(seconds: 4));
        if (!_active) break;

        try {
          await _rpc.send("ping", hasResult: true);
        } catch (e) {
          _dispatchEvent(Event.error, {"error": NetworkError()});
        }
      }
    }

    loop();
  }

  void _dispatchEvent(Event event, Map<String, dynamic> params) {
    if (event == Event.error) _active = false;
    if (!_handlers.containsKey(event)) return;
    final handler = _handlers[event];
    if (handler != null) handler(params);
  }

  void _addAlreadyInRoomConnections(Map<String, dynamic> model) {
    if (!model.containsKey("value")) return;
    final list = model["value"] as List<dynamic>;
    list.forEach((c) => _addRemoteConnection(c));
  }

  void _addRemoteConnection(Map<String, dynamic> model) {
    final id = model["id"];
    String userName = _getUserName(model);
    if (userName == _userName) return;
    final connection = RemoteConnection(id, _token, _rpc);
    _remoteConnections[id] = connection;
    _dispatchEvent(Event.userJoined, {"id": id, "userName": userName});

    if (model["streams"] != null) {
      _dispatchEvent(Event.userPublished, {"id": id, "userName": userName});
    }
  }

  void _onRpcMessage(Map<String, dynamic> message) {
    if (!_active) return;
    if (!message.containsKey("method")) return;
    final method = message["method"];
    final params = message["params"];

    switch (method) {
      case "participantJoined":
        _addRemoteConnection(params);
        break;

      case "participantPublished":
        final id = params["id"];
        _dispatchEvent(Event.userPublished, {"id": id});
        break;
      case "participantJoined":
        _addRemoteConnection(params);
        break;
      case "participantLeft":
        final id = params["connectionId"];

        if (_remoteConnections.containsKey(id)) {
          try {
            var connection = _remoteConnections[id];
            connection?.close();
            _remoteConnections.remove(id);
          } catch (e) {}

          _dispatchEvent(Event.removeStream, {"id": id});
        }

        break;
      case "streamPropertyChanged":
        final eventStr = params["reason"];
        final id = params["connectionId"];
        final value = params["newValue"];
        final event = Event.values.firstWhere((e) => e.toString() == eventStr);
        _dispatchEvent(event, {"id": id, "value": value});
        break;
      default:
    }
  }

  String _getUserName(Map<String, dynamic> params) {
    var userName;

    try {
      if (params["metadata"] != null) {
        final clientData = json.decode(params["metadata"]);
        userName = clientData["clientData"];
      }
    } catch (e) {}

    return userName;
  }
}
