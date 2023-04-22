import 'package:shared_preferences/shared_preferences.dart';

class TokenProvider {
  static const String KEY_ACCESS_TOKEN = "access_token";
  static const String KEY_REFRESH_TOKEN = "refresh_token";

  late SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> setAccessToken(String accessToken) async {
    await prefs.setString(KEY_ACCESS_TOKEN, accessToken);
  }

  Future<String?> getAccessToken() async {
    return prefs.getString(KEY_ACCESS_TOKEN);
  }

  Future<void> setRefreshToken(String refreshToken) async {
    await prefs.setString(KEY_REFRESH_TOKEN, refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return prefs.getString(KEY_REFRESH_TOKEN);
  }
}