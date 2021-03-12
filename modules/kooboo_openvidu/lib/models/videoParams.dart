class VideoParams {
  final int frameRate;
  final int width;
  final int height;

  VideoParams(this.frameRate, this.width, this.height);

  static VideoParams low = VideoParams(30, 480, 640);
  static VideoParams middle = VideoParams(30, 640, 960);
  static VideoParams high = VideoParams(30, 1080, 1920);
}
