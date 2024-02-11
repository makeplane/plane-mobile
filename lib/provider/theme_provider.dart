import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/plane_keys.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/shared_preference_service.dart';
import '../utils/enums.dart';
import '../utils/theme_manager.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider(ChangeNotifierProviderRef<ThemeProvider> this.ref);
  Ref ref;
  BuildContext? context;
  THEME theme = THEME.light;
  ThemeManager themeManager = ThemeManager(THEME.light);

  void notify() {
    notifyListeners();
  }

  Future<void> toggleTheme(THEME theme) async {
    this.theme = theme;
    themeManager = ThemeManager(theme);
    CustomToast(manager: themeManager);
    AppTheme.setUiOverlayStyle(theme: theme, themeManager: themeManager);
    notifyListeners();
  }

  Future<void> changeTheme({
    required Map data,
    required BuildContext? context,
    bool fromLogout = false,
  }) async {
    final profileProvider = ref.read(ProviderList.profileProvider);
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
    themeManager = ThemeManager(theme);
    CustomToast(manager: themeManager);

    if (!fromLogout) {
      final profileProv = ref.read(ProviderList.profileProvider);
      profileProv.updateProfile(data: data).then((value) {
        if (profileProv.updateProfileState == DataState.success &&
            context != null) {
          CustomToast.showToast(context,
              message: 'Theme updated!', toastType: ToastType.success);
        } else {}
      });
    }

    AppTheme.setUiOverlayStyle(
        theme: themeParser(theme: data['theme']['theme']),
        themeManager: themeManager);
    await SharedPrefrenceServices.instance
        .setString(PlaneKeys.SELECTED_THEME, fromTHEME(theme: theme));
    notifyListeners();
  }

  Future<void> getTheme() async {
    final SharedPreferences sharedPreferences =
        SharedPrefrenceServices.instance;
    if (!sharedPreferences.containsKey(PlaneKeys.SELECTED_THEME)) {
      await sharedPreferences.setString(
          PlaneKeys.SELECTED_THEME, PlaneKeys.LIGHT_THEME);
    } else {
      theme = themeParser(
          theme: sharedPreferences.getString(PlaneKeys.SELECTED_THEME)!);
    }

    if (theme == THEME.custom) {
      if (!sharedPreferences.containsKey('primary')) {
        theme = THEME.light;
      } else {
        customAccentColor = Color(int.parse(
            sharedPreferences
                .getString('primary')
                .toString()
                .replaceFirst('#', 'FF'),
            radix: 16));
        customBackgroundColor = Color(int.parse(
            sharedPreferences
                .getString('background')
                .toString()
                .replaceFirst('#', 'FF'),
            radix: 16));
        customTextColor = Color(int.parse(
            sharedPreferences
                .getString('text')
                .toString()
                .replaceFirst('#', 'FF'),
            radix: 16));
        customNavBarColor = Color(int.parse(
            sharedPreferences
                .getString('sidebarBackground')
                .toString()
                .replaceFirst('#', 'FF'),
            radix: 16));
        customNavBarTextColor = Color(int.parse(
            sharedPreferences
                .getString('sidebarText')
                .toString()
                .replaceFirst('#', 'FF'),
            radix: 16));
      }
    }

    themeManager = ThemeManager(theme);
    CustomToast(manager: themeManager);
    notifyListeners();
  }
}
