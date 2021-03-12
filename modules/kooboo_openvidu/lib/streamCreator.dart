import 'package:flutter_webrtc/flutter_webrtc.dart';

class StreamCreator {
  static MediaStream _stream;

  static Future<MediaStream> create(
    StreamMode mode, {
    VideoParams videoParams,
  }) async {
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
    (await _stream).dispose();
  }
}

enum StreamMode {
  frontCamera,
  backCamera,
  srceen,
  audio,
}

class VideoParams {
  final int frameRate;
  final int width;
  final int height;

  VideoParams(this.frameRate, this.width, this.height);

  static VideoParams low = VideoParams(30, 480, 640);
  static VideoParams middle = VideoParams(30, 640, 960);
  static VideoParams high = VideoParams(30, 1080, 1920);
}
