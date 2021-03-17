import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'models/streamMode.dart';
import 'models/videoParams.dart';

class StreamCreator {
  static MediaStream _stream;
  static StreamMode _mode;
  static VideoParams _videoParams;

  static MediaStream get stream => _stream;
  static StreamMode get mode => _mode;
  static VideoParams get videoParams => _videoParams;

  static Future<MediaStream> create(
    StreamMode mode, {
    VideoParams videoParams,
  }) async {
    if (_stream != null) await _stream.dispose();
    _mode = mode;
    _videoParams = videoParams;

    if (mode == StreamMode.srceen) {
      _stream = await navigator.mediaDevices.getDisplayMedia({
        "audio": true,
        "video": true,
      });
    } else {
      final video = mode == StreamMode.audio
          ? false
          : {
              "width": videoParams.width,
              "height": videoParams.height,
              "frameRate": videoParams.frameRate,
              "facingMode": mode == StreamMode.frontCamera ? "user" : null,
            };

      _stream = await navigator.mediaDevices.getUserMedia({
        "audio": true,
        "video": video,
      });
    }

    return _stream;
  }

  static Future<void> dispose() async {
    await _stream?.dispose();
    _stream = null;
    _mode = null;
    _videoParams = null;
  }
}
