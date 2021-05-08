import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/models/callModel.dart';
import 'package:flutter_openvidu_demo/models/conversationModel.dart';
import 'package:provider/provider.dart';

class CloseBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final float = context.select<CallModel, bool>((value) => value.float);
    return FloatingActionButton(
      heroTag: "close",
      child: Icon(Icons.close),
      onPressed: context.read<ConversationModel>().stopCall,
      backgroundColor: Colors.red.shade300,
      mini: float,
    );
  }
}
