import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/custom_toast.dart';
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
  ThemeManager themeManager = ThemeManager(THEME.light);

  //function to change theme and stor the theme in shared preferences
  void clear() {
    isDarkThemeEnabled = false;
  }

  Future<void> toggleTheme(THEME theme) async {
    this.theme = theme;
    themeManager = ThemeManager(theme);
    notifyListeners();
  }

  Future<void> changeTheme(
      {required Map data, required BuildContext context}) async {
    var profileProvider = ref.read(ProviderList.profileProvider);
    if (data['theme']['theme'] == 'custom' &&
        ((profileProvider.userProfile.theme == null ||
                profileProvider.userProfile.theme!.length <= 1) &&
            data['background'] == null &&
            profileProvider.userProfile.theme!['background'] == null)) {
      theme = THEME.light;
    } else {
      if (data['theme']['theme'] == 'custom') {
        log("CUSTOM THEMING");
        customAccentColor = Color(int.parse(
            data['theme']['primary'].toString().replaceFirst('#', 'FF'),
            radix: 16));
        customBackgroundColor = Color(int.parse(
            data['theme']['background'].toString().replaceFirst('#', 'FF'),
            radix: 16));
        customTextColor = Color(int.parse(
            data['theme']['text'].toString().replaceFirst('#', 'FF'),
            radix: 16));
        customNavBarColor = Color(int.parse(
            data['theme']['sidebarBackground']
                .toString()
                .replaceFirst('#', 'FF'),
            radix: 16));
        customNavBarTextColor = Color(int.parse(
            data['theme']['sidebarText'].toString().replaceFirst('#', 'FF'),
            radix: 16));
      }
      theme = themeParser(theme: data['theme']['theme']);
    }
    log(theme.toString());
    themeManager = ThemeManager(theme);
    var profileProv = ref.read(ProviderList.profileProvider);
    profileProv.updateProfile(data: data).then((value) {
      if (profileProv.updateProfileState == StateEnum.success) {
        CustomToast().showToast(context, 'Theme updated!',
            backgroundColor: themeManager.secondaryBackgroundDefaultColor);
      } else {}
    });
    await prefs.setString('selected-theme', fromTHEME(theme: theme));
    notifyListeners();
  }

  Future<void> getTheme() async {
    if (!prefs.containsKey('selected-theme')) {
      await prefs.setString('selected-theme', 'light');
    } else {
      theme = themeParser(theme: prefs.getString('selected-theme')!);
    }

    if (theme == THEME.custom) {
      if (!prefs.containsKey('primary')) {
        theme = THEME.light;
      } else {
        customAccentColor = Color(int.parse(
            prefs.getString('primary').toString().replaceFirst('#', 'FF'),
            radix: 16));
        customBackgroundColor = Color(int.parse(
            prefs.getString('background').toString().replaceFirst('#', 'FF'),
            radix: 16));
        customTextColor = Color(int.parse(
            prefs.getString('text').toString().replaceFirst('#', 'FF'),
            radix: 16));
        customNavBarColor = Color(int.parse(
            prefs
                .getString('sidebarBackground')
                .toString()
                .replaceFirst('#', 'FF'),
            radix: 16));
        customNavBarTextColor = Color(int.parse(
            prefs.getString('sidebarText').toString().replaceFirst('#', 'FF'),
            radix: 16));
      }
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
