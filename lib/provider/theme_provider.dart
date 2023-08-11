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
  ThemeManager themeManager=ThemeManager(THEME.light);
  //function to change theme and stor the theme in shared preferences
  void clear() {
    isDarkThemeEnabled = false;
  }

  Future<void> toggleTheme(THEME theme) async {
    this.theme = theme;
    themeManager = ThemeManager(theme);
    notifyListeners();
  }

  Future<void> changeTheme(THEME theme) async {
    this.theme = theme;
    themeManager = ThemeManager(theme);
    await prefs.setString('selected-theme', fromTHEME(theme: theme));
    notifyListeners();
  }

  Future<void> getTheme() async {
    if (!prefs.containsKey('selected-theme')) {
      await prefs.setString('selected-theme', 'L');
    } else {
      theme = themeParser(theme: prefs.getString('selected-theme')!);
    }
    if (theme == THEME.dark) {
      isDarkThemeEnabled = true;
    } else {
      isDarkThemeEnabled = false;
    }
    themeManager = ThemeManager(theme);
    // print(themeManager);
  }
}
