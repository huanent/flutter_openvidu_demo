import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/models/chatModel.dart';
import 'package:provider/provider.dart';

class SwitchCamera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ChatModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 30, 0),
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          icon: Icon(
            Icons.switch_camera,
            color: Colors.white,
          ),
          onPressed: () => model.switchCamera(),
        ),
      ),
    );
  }
}
