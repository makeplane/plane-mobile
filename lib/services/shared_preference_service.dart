import 'package:plane/config/const.dart';
import 'package:plane/config/plane_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrenceServices {
  static late SharedPreferences instance;
  static Future<void> init() async {
    instance = await SharedPreferences.getInstance();
  }

  static Future<Map<String, String>> setTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    Const.accessToken = accessToken;
    Const.refreshToken = refreshToken;
    await instance.setString(PlaneKeys.ACCESS_TOKEN, accessToken);
    await instance.setString(PlaneKeys.REFRESH_TOKEN, refreshToken);
    return {
      PlaneKeys.ACCESS_TOKEN: Const.accessToken!,
      PlaneKeys.REFRESH_TOKEN: Const.refreshToken!,
    };
  }

  static Map<String, String?> getTokens() {
    Const.accessToken = instance.getString(PlaneKeys.ACCESS_TOKEN);
    Const.refreshToken = instance.getString(PlaneKeys.REFRESH_TOKEN);
    return {
      PlaneKeys.ACCESS_TOKEN: Const.accessToken,
      PlaneKeys.REFRESH_TOKEN: Const.refreshToken,
    };
  }

  static String? getUserID() {
    Const.userId = instance.getString(PlaneKeys.USER_ID);
    return Const.userId;
  }

  static Future<String> setUserID(String userId) async {
    Const.userId = userId;
    await instance.setString(PlaneKeys.USER_ID, userId);
    return Const.userId!;
  }

  static Future setDarkMode(bool value) async {
    await instance.setBool('dark_mode', value);
  }

  static bool getTheme() {
    return instance.getBool('dark_mode') ?? false;
  }
}
