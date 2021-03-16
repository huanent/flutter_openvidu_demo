import 'jsonRpc.dart';
import 'models/token.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'connection.dart';
import 'models/event.dart';

class RemoteConnection extends Connection {
  RemoteConnection(String id, Token token, JsonRpc rpc) : super(id, token, rpc);

  Future<void> subscribeStream(
    Function(Event event, Map<String, dynamic> params) dispatchEvent,
    bool video,
    bool audio,
    bool speakerphone,
  ) async {
    final connection = await peerConnection;

    connection.onAddStream = (stream) {
      this.stream = stream;
      enableVideo(video);
      enableAudio(audio);
      enableSpeakerphone(speakerphone);
      dispatchEvent(Event.addStream, {"id": id, "stream": stream});
    };

    connection.onRemoveStream = (stream) {
      this.stream = stream;
      dispatchEvent(Event.removeStream, {"id": id, "stream": stream});
    };

    final offer = await connection.createOffer(constraints);
    connection.setLocalDescription(offer);

    var result = await rpc.send(
      "receiveVideoFrom",
      params: {'sender': id, 'sdpOffer': offer.sdp},
      hasResult: true,
    );

    final answer = RTCSessionDescription(result['sdpAnswer'], 'answer');
    await connection.setRemoteDescription(answer);
  }
}
