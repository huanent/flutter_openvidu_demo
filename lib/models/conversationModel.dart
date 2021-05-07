import 'package:flutter/widgets.dart';

class ConversationModel extends ChangeNotifier {
  CallMode _callMode = CallMode.None;

  CallMode get callMode => _callMode;

  void startCall(CallMode mode) {
    _callMode = mode;
    notifyListeners();
  }

  void stopCall() {
    _callMode = CallMode.None;
    notifyListeners();
  }
}

enum CallMode { None, Audio, Video }
