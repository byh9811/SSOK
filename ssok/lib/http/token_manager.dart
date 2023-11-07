import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  late SharedPreferences _prefs;
  String? _accessToken;

  static final TokenManager _instance = TokenManager._internal();

  factory TokenManager() {
    return _instance;
  }

  TokenManager._internal();

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs.getString('accessToken');
  }

  String? get accessToken => _accessToken;

  Future<void> setAccessToken(String? token) async {
    _accessToken = token;
    await _prefs.setString('accessToken', token ?? '');
  }
}
