import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class JsonRpc {
  int _internalId = 0;
  bool _active = true;
  IOWebSocketChannel _channel;
  final Map<int, Completer> _completers = {};
  Function(Map<String, dynamic> params) _onMessage;

  JsonRpc({Function(Map<String, dynamic> params) onMessage}) {
    _onMessage = onMessage;
  }

  void connect(String url) {
    _channel = IOWebSocketChannel.connect(url);
    _channel.stream.listen((event) {
      final _rsp = json.decode(event) as Map<String, dynamic>;
      _onMessage?.call(_rsp);
      if (_rsp.containsKey("id")) {
        final _completer = _completers[_rsp["id"]];
        _completers.remove(_rsp["id"]);
        if (_rsp.containsKey("error")) {
          _completer?.completeError(_rsp["error"]);
        } else {
          _completer?.complete(_rsp["result"]);
        }
      }
    });
  }

  Future<dynamic> disconnect() async {
    _active = false;
    return _channel.sink.close();
  }

  Future<dynamic> send(
    String method, {
    Map<String, dynamic> params,
    bool hasResult,
  }) {
    if (!_active) return null;
    final _id = _internalId++;

    Map<String, dynamic> dict = <String, dynamic>{};
    dict["method"] = method;
    dict["id"] = _id;
    dict['jsonrpc'] = '2.0';
    if (params != null) dict["params"] = params;
    String jsonString = json.encode(dict);

    _channel.sink.add(jsonString);
    if (!(hasResult ?? false)) return null;

    final _completer = Completer<Map<String, dynamic>>();
    _completers[_id] = _completer;

    return _completer.future.timeout(Duration(seconds: 10), onTimeout: () {
      if (_completers.containsKey(_id)) _completers.remove(_id);
      return Future.error("rpc time out");
    });
  }
}
