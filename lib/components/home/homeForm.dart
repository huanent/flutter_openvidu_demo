import 'package:flutter/material.dart';
import 'package:flutter_openvidu_demo/models/tokenModel.dart';
import 'package:provider/provider.dart';

class HomeForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TokenModel>(context, listen: false);

    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: "Server 地址"),
            initialValue: model.server,
            onChanged: (val) => model.server = val,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "房间号"),
            initialValue: model.session,
            onChanged: (val) => model.session = val,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "用户名"),
            initialValue: model.userName,
            onChanged: (val) => model.userName = val,
          )
        ],
      ),
    );
  }
}
