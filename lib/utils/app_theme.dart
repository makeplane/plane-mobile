import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/theme_manager.dart';

class AppTheme {
  static ThemeData getThemeData(ThemeManager themeManager) {
    return ThemeData(
      textTheme: TextTheme(
        titleMedium: TextStyle(
          color: themeManager.primaryTextColor,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
          cursorColor: themeManager.primaryColour,
          selectionColor: themeManager.primaryColour.withOpacity(0.2),
          selectionHandleColor: themeManager.primaryColour),
      primaryColor: themeManager.primaryBackgroundDefaultColor,
      scaffoldBackgroundColor: themeManager.primaryBackgroundDefaultColor,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: themeManager.primaryBackgroundDefaultColor,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: themeManager.primaryBackgroundDefaultColor,
      ),
      unselectedWidgetColor: themeManager.primaryTextColor,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return themeManager.primaryColour;
          }
          return null;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return themeManager.primaryColour;
          }
          return null;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return themeManager.primaryColour;
          }
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return themeManager.primaryColour;
          }
          return null;
        }),
      ),
      colorScheme: ColorScheme.fromSwatch(
          primarySwatch: const MaterialColor(
        0xFFFFFFFF,
        <int, Color>{
          50: Color(0xFFFFFFFF),
          100: Color(0xFFFFFFFF),
          200: Color(0xFFFFFFFF),
          300: Color(0xFFFFFFFF),
          400: Color(0xFFFFFFFF),
          500: Color(0xFFFFFFFF),
          600: Color(0xFFFFFFFF),
          700: Color(0xFFFFFFFF),
          800: Color(0xFFFFFFFF),
          900: Color(0xFFFFFFFF),
        },
      )).copyWith(
        background: themeManager.primaryBackgroundDefaultColor,
      ),
    );
  }

  static ThemeMode getThemeMode(THEME theme) {
    if (theme == THEME.light || theme == THEME.lightHighContrast) {
      return ThemeMode.light;
    } else if (theme == THEME.dark || theme == THEME.darkHighContrast) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  static void setUiOverlayStyle(
      {required THEME theme, required ThemeManager themeManager}) {
    if (theme == THEME.light ||
        theme == THEME.lightHighContrast ||
        (theme == THEME.systemPreferences &&
            SchedulerBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.light)) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.white,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ));
    } else if (theme == THEME.dark ||
        theme == THEME.darkHighContrast ||
        (theme == THEME.systemPreferences &&
            SchedulerBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark)) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarDividerColor: Colors.black,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ));
    } else if (theme == THEME.custom) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: themeManager.primaryBackgroundDefaultColor,
        systemNavigationBarDividerColor:
            themeManager.primaryBackgroundDefaultColor,
      ));
    }
  }
}
