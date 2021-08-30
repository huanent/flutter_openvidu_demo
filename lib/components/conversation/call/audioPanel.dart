import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AudioPanel extends StatelessWidget {
  const AudioPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //语音通话不需要进行stream渲染动作,只需要添加一张背景
    return Stack(
      children: [
        Container(
          color: Colors.black45,
          child: Center(
            child: Text(
              "语音通话,替换为项目背景图",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
