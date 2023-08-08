import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/enums.dart';
import '../utils/theme_manager.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider(ChangeNotifierProviderRef<ThemeProvider> this.ref);
  Ref ref;
  BuildContext? context;
  late SharedPreferences prefs;
  bool isDarkThemeEnabled = false;
  THEME theme = THEME.light;
  late ThemeManager themeManager;
  //function to change theme and stor the theme in shared preferences
  void clear() {
    isDarkThemeEnabled = false;
  }

  Future<void> changeTheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (isDarkThemeEnabled) {
      isDarkThemeEnabled = false;
      theme = THEME.dark;
      themeManager = ThemeManager(theme);
      notifyListeners();
      await pref.setBool('isDarkThemeEnabled', isDarkThemeEnabled);
    } else {
      isDarkThemeEnabled = true;
      theme = THEME.light;
      themeManager = ThemeManager(theme);
      notifyListeners();
      await pref.setBool('isDarkThemeEnabled', isDarkThemeEnabled);
    }
  }

  Future<void> getTheme() async {
    if (!prefs.containsKey('selected-theme')) {
      await prefs.setString('selected-theme', 'L');
    } else {
      theme = themeParser(theme: prefs.getString('selected-theme')!);
    }
    themeManager = ThemeManager(theme);
    // print(themeManager);
  }
}
