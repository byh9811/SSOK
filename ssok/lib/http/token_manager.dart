import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  late SharedPreferences _prefs;
  String? _accessToken;
  String? _refreshToken;

  static final TokenManager _instance = TokenManager._internal();

  factory TokenManager() {
    return _instance;
  }

  TokenManager._internal();

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs.getString('accessToken');
    _refreshToken = _prefs.getString('refreshToken');
  }

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  Future<void> setAccessToken(String? token) async {
    _accessToken = token;
    await _prefs.setString('accessToken', token ?? '');
  }

    Future<void> setRefreshToken(String? token) async {
    _refreshToken = token;
    await _prefs.setString('retreshToken', token ?? '');
  }
}
