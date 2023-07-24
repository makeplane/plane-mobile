import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrenceServices {
  static SharedPreferences? sharedPreferences;
  static Future init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
  static Future setDarkMode(bool value) async {
    await sharedPreferences!.setBool('dark_mode', value);
  }
  static bool getTheme() {
    return sharedPreferences!.getBool('dark_mode') ?? false;
  }
}
