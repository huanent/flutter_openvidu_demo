import 'dart:io';

import 'package:flutter/material.dart';
import 'utils/globalHttpOverrides.dart';

import 'pages/chat.dart';
import 'pages/home.dart';

void main() {
  /////关闭https证书验证/////
  HttpOverrides.global = GlobalHttpOverrides();
  /////关闭https证书验证/////

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Home.routeName,
      routes: {
        Home.routeName: (ctx) => Home(),
        Chat.routeName: (ctx) => Chat(),
      },
    );
  }
}
