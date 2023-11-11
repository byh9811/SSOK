import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  late SharedPreferences _prefs;
  String? _accessToken;
  String? _refreshToken;
  String? _loginId;
  String? _memberName;

  static final TokenManager _instance = TokenManager._internal();

  factory TokenManager() {
    return _instance;
  }

  TokenManager._internal();

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs.getString('accessToken');
    _refreshToken = _prefs.getString('refreshToken');
    _loginId = _prefs.getString('loginId');
    _memberName = _prefs.getString('memberName');
  }

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  String? get loginId => _loginId;
  String? get memberName => _memberName;

  Future<void> setAccessToken(String? accesstoken) async {
    _accessToken = accesstoken;
    await _prefs.setString('accessToken', accesstoken ?? '');
  }

  Future<void> setRefreshToken(String? refreshToken) async {
    _refreshToken = refreshToken;
    await _prefs.setString('refreshToken', refreshToken ?? '');
  }
  Future<void> setLoginId(String? loginId) async {
    _loginId = loginId;
    await _prefs.setString('loginId', loginId ?? '');
  }

  Future<void> setMemberName(String? memberName) async {
    _memberName = memberName;
    await _prefs.setString('memberName', memberName ?? '');
  }

  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _loginId = null;
    _memberName = null;
    await _prefs.remove('accessToken');
    await _prefs.remove('refreshToken');
    await _prefs.remove('memberName');
    await _prefs.remove('loginId');
    print("logout");
  }
}
