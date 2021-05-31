import 'package:flutter/material.dart';

import 'ctrl/actionBar.dart';
import 'ctrl/floatBtn.dart';

class CtrlPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(children: [
        FloatBtn(),
        ActionBar(),
      ]),
      bottom: false,
    );
  }
}
