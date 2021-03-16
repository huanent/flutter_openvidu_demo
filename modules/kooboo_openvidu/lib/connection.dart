import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'jsonRpc.dart';
import 'models/token.dart';

abstract class Connection {
  final String id;
  final Token token;
  final JsonRpc rpc;
  MediaStream stream;
  String streamId;
  Future<RTCPeerConnection> peerConnection;

  final Map<String, dynamic> constraints = {
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': true,
    },
    'optional': [],
  };

  String get sdpSemantics =>
      WebRTC.platformIsWindows ? 'plan-b' : 'unified-plan';

  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ]
  };

  Connection(this.id, this.token, this.rpc) {
    peerConnection = _getPeerConnection();
  }

  Future<RTCPeerConnection> _getPeerConnection() async {
    final connection = await createPeerConnection(_getConfiguration(), _config);

    connection.onIceCandidate = (candidate) {
      Map<String, dynamic> iceCandidateParams = {
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMlineIndex,
        'candidate': candidate.candidate,
        "endpointName": id
      };

      rpc.send("onIceCandidate", params: iceCandidateParams);
    };

    return connection;
  }

  Map<String, dynamic> _getConfiguration() {
    final stun = "stun:$token.coturnIp:3478";
    final turn1 = "turn:$token.coturnIp:3478";
    final turn2 = "$turn1?transport=tcp";

    return {
      "sdpSemantics": sdpSemantics,
      'iceServers': [
        {
          "urls": [stun]
        },
        {
          "urls": [turn1, turn2],
          "username": token.turnUsername,
          "credential": token.turnCredential
        },
      ]
    };
  }

  Future<void> close() async {
    final connection = await peerConnection;
    connection?.close();
    connection?.dispose();
    stream?.dispose();
  }

  void enableVideo(bool enable) {
    if (stream == null) return;
    stream.getVideoTracks().forEach((track) {
      track.enabled = enable;
    });
  }

  void enableAudio(bool enable) {
    if (stream == null) return;

    stream.getAudioTracks().forEach((track) {
      track.enabled = enable;
    });
  }

  void enableSpeakerphone(bool enable) {
    if (stream == null) return;

    stream.getAudioTracks().forEach((track) {
      track.enableSpeakerphone(enable);
    });
  }
}
