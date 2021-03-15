import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/io.dart';

class JsonRpc {
  int _internalId = 0;
  IOWebSocketChannel _channel;
  final Map<int, Completer> _completers = {};
  Function(Map<String, dynamic> params) _onMessage;

  JsonRpc({Function(Map<String, dynamic> params) onMessage}) {
    _onMessage = onMessage;
  }

  void connect(String url) {
    _channel = IOWebSocketChannel.connect(url);
    _channel.stream.listen((event) {
      final response = json.decode(event) as Map<String, dynamic>;
      _onMessage?.call(response);
      if (response.containsKey("id")) {
        final id = response["id"];
        final completer = _completers[id];
        _completers.remove(id);
        if (response.containsKey("error")) {
          completer?.completeError(response["error"]);
        } else {
          completer?.complete(response["result"]);
        }
      }
    });
  }

  Future<dynamic> disconnect() => _channel.sink.close();

  Future<dynamic> send(
    String method, {
    Map<String, dynamic> params,
    bool hasResult,
  }) {
    final _id = _internalId++;
    Map<String, dynamic> dict = <String, dynamic>{};
    dict["method"] = method;
    dict["id"] = _id;
    dict['jsonrpc'] = '2.0';
    if (params != null) dict["params"] = params;
    String jsonString = json.encode(dict);

    _channel.sink.add(jsonString);
    if (!(hasResult ?? false)) return null;

    final completer = Completer<Map<String, dynamic>>();
    _completers[_id] = completer;

    return completer.future.timeout(Duration(seconds: 10), onTimeout: () {
      if (_completers.containsKey(_id)) _completers.remove(_id);
      return Future.error({"code": 1, "message": "Rpc time out"});
    });
  }
}
