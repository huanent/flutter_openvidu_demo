import 'dart:io';

import 'package:flutter/foundation.dart';

class TokenModel extends ChangeNotifier {
  String server = "http://192.168.10.236:5000";
  String session = "abc";
  String userName = Platform.isAndroid ? "android_user" : "iphone_user";
}
