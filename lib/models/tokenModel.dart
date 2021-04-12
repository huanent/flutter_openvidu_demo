import 'dart:io';

import 'package:flutter/foundation.dart';

class TokenModel extends ChangeNotifier {
  //String server = "http://117.28.236.91:5000";
  String server = "http://192.168.10.235:5000";
  String session = "abc";
  String userName = Platform.isAndroid ? "android_user" : "iphone_user";
}
