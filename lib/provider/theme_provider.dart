import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:plane_startup/config/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  BuildContext? context;
  SharedPreferences? prefs;
  bool isDarkThemeEnabled = false;
  // Color primaryTextColor = lightPrimaryTextColor;
  // Color secondaryTextColor = lightSecondaryTextColor;
  // Color strokeColor = lightStrokeColor;
  // Color backgroundColor = lightBackgroundColor;
  // Color secondaryBackgroundColor = lightSecondaryBackgroundColor;
  // Color buttonColor = primaryColor;

  //function to change theme and stor the theme in shared preferences

  void clear(){
    isDarkThemeEnabled = false;
  }
  Future<void> changeTheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (isDarkThemeEnabled) {
      isDarkThemeEnabled = false;
      Const.dark = false;
      // primaryTextColor = lightPrimaryTextColor;
      // secondaryTextColor = lightSecondaryTextColor;
      // strokeColor = lightStrokeColor;
      // backgroundColor = lightBackgroundColor;
      // secondaryBackgroundColor = lightSecondaryBackgroundColor;

      notifyListeners();
      await pref.setBool('isDarkThemeEnabled', isDarkThemeEnabled);
    } else {
      isDarkThemeEnabled = true;
   Const.dark = true;
      // primaryTextColor = darkPrimaryTextColor;
      // secondaryTextColor = darkSecondaryTextColor;
      // strokeColor = darkStrokeColor;
      // backgroundColor = darkBackgroundColor;
      // secondaryBackgroundColor = darkSecondaryBackgroundColor;

      notifyListeners();
      await pref.setBool('isDarkThemeEnabled', isDarkThemeEnabled);
    }
  }

  Future<void> getTheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isDarkThemeEnabled = pref.getBool('isDarkThemeEnabled') ?? false;
    if (isDarkThemeEnabled) {
      // primaryTextColor = darkPrimaryTextColor;
      // secondaryTextColor = darkSecondaryTextColor;
      // strokeColor = darkStrokeColor;
      // backgroundColor = darkBackgroundColor;
      // secondaryBackgroundColor = darkSecondaryBackgroundColor;
    }
    log('isDarkThemeEnabled: $isDarkThemeEnabled');
    notifyListeners();
  }

  //function to get the theme data
}
