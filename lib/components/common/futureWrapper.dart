import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'loading.dart';

class FutureWrapper extends StatelessWidget {
  final Future future;
  final Widget Function(BuildContext context) builder;

  const FutureWrapper({Key key, this.future, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            child: Loading(),
            color: Colors.white,
          );
        } else {
          return builder(context);
        }
      },
    );
  }
}
