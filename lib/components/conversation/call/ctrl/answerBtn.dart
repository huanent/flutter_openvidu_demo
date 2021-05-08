import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/models/callModel.dart';
import 'package:provider/provider.dart';

class AnswerBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final float = context.select<CallModel, bool>((value) => value.float);

    return FloatingActionButton(
      heroTag: "answer",
      child: Icon(Icons.call),
      onPressed: context.read<CallModel>().enter,
      backgroundColor: Colors.green.shade300,
      mini: float,
    );
  }
}
