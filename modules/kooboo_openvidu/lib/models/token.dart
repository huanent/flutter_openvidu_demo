class Token {
  final String url;

  String _host;
  String _sessionId;
  String _token;
  String _role;
  String _version;
  String _coturnIp;
  String _turnUsername;
  String _turnCredential;

  String get host => _host;
  String get sessionId => _sessionId;
  String get token => _token;
  String get role => _role;
  String get version => _version;
  String get coturnIp => _coturnIp;
  String get turnUsername => _turnUsername;
  String get turnCredential => _turnCredential;

  Token(this.url) {
    final uri = Uri.parse(url);
    _host = uri.host;
    _sessionId = uri.queryParameters["sessionId"];
    _token = uri.queryParameters["token"];
    _role = uri.queryParameters["role"];
    _version = uri.queryParameters["version"];
    _coturnIp = uri.queryParameters["coturnIp"];
    _turnUsername = uri.queryParameters["turnUsername"];
    _turnCredential = uri.queryParameters["turnCredential"];
  }
}
