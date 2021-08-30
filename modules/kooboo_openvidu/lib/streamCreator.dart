import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'models/streamMode.dart';
import 'models/videoParams.dart';

class StreamCreator {
  static MediaStream? _stream;
  static StreamMode? _mode;
  static VideoParams? _videoParams;

  static MediaStream? get stream => _stream;
  static StreamMode get mode => _mode ?? StreamMode.frontCamera;
  static VideoParams get videoParams => _videoParams ?? VideoParams.middle;

  static Future<MediaStream?> create(
    StreamMode mode, {
    VideoParams? videoParams,
  }) async {
    if (_stream != null) await _stream!.dispose();
    _mode = mode;
    _videoParams = videoParams ?? VideoParams.middle;

    if (_mode == StreamMode.screen) {
      _stream = await navigator.mediaDevices.getDisplayMedia({
        "audio": true,
        "video": true,
      });
    } else {
      final video = _mode == StreamMode.audio
          ? false
          : {
              "width": _videoParams!.width,
              "height": _videoParams!.height,
              "frameRate": _videoParams!.frameRate,
              "facingMode": _mode == StreamMode.frontCamera ? "user" : null,
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
