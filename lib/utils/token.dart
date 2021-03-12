import 'package:dio/dio.dart';

class Token {
  Dio _dio = Dio();
  String _server;
  String _session;

  Token(this._server, this._session);

  Future<Map<String, dynamic>> _getSession() async {
    var response = await _dio.get("$_server/api/Session/list");
    final sessions = response.data["content"] as List<dynamic>;
    if (sessions.length > 0) {
      return sessions[0];
    } else {
      response = await _dio.post("$_server/api/Session",
          data: {"id": _session, "record": false});
      return response.data["result"];
    }
  }

  Future<Map<String, dynamic>> _getConnection(String sessionId) async {
    final response =
        await _dio.post("$_server/api/Connection?sessionId=$sessionId");
    return response.data;
  }

  Future<String> getToken() async {
    final session = await _getSession();
    final sessionId = session["id"];
    final connection = await _getConnection(sessionId);
    return connection['token'];
  }
}
