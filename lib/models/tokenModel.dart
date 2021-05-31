import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_openvidu_demo/utils/token.dart';

class TokenModel extends ChangeNotifier {
  String server = "http://xmoffice.kooboo.cn:5000";
  String session = "abc";
  String userName = Platform.isAndroid ? "android_user" : "iphone_user";

  Future<String> getToken() async {
    final token = await Token(server, session).getToken();
    return token;
  }
}
