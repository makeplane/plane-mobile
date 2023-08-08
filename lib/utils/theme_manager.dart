import 'package:flutter/material.dart';

import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';

class ThemeManager {
  final THEME theme;
  late Color primaryTextColor;
  late Color secondaryTextColor;
  late Color tertiaryTextColor;
  late Color placeholderTextColor;
  late Color textonColor;
  late Color textOnColorDisabled;
  late Color textErrorColor;
  late Color textWarningColor;
  late Color textSuccessColor;
  late Color textdisabledColor;
  late Color primaryColour;

  ThemeManager(this.theme) {
    primaryTextColor = theme == THEME.light
        ? lightPrimaryTextColor
        : theme == THEME.dark
            ? darkPrimaryTextColor
            : theme == THEME.lightHighContrast
                ? lightContrastPrimaryTextColor
                : darkContrastPrimaryTextColor;
    secondaryTextColor = theme == THEME.light
        ? lightSecondaryTextColor
        : theme == THEME.dark
            ? darkSecondaryTextColor
            : theme == THEME.lightHighContrast
                ? lightContrastSecondaryTextColor
                : darkContrastSecondaryTextColor;
    tertiaryTextColor = theme == THEME.light
        ? lightTertiaryTextColor
        : theme == THEME.dark
            ? darkTertiaryTextColor
            : theme == THEME.lightHighContrast
                ? lightContrastTertiaryTextColor
                : darkContrastTertiaryTextColor;
    placeholderTextColor = theme == THEME.light
        ? lightPlaceholderTextColor
        : theme == THEME.dark
            ? darkPlaceholderTextColor
            : theme == THEME.lightHighContrast
                ? lightContrastPlaceholderTextColor
                : lightContrastPlaceholderTextColor;
    textonColor = lightTextOnColorColor;
    textOnColorDisabled = theme == THEME.light
        ? lightTextOnColorDisabledColor
        : theme == THEME.dark
            ? darkContrastTextOnColorDisabledColor
            : theme == THEME.lightHighContrast
                ? lightTextOnColorDisabledColor
                : darkContrastTextOnColorDisabledColor;
    textErrorColor = theme == THEME.light
        ? lightTextErrorColor
        : theme == THEME.dark
            ? darkTextErrorColor
            : theme == THEME.lightHighContrast
                ? lightTextErrorColor
                : darkTextErrorColor;
    textWarningColor = theme == THEME.light
        ? lightTextWarningColor
        : theme == THEME.dark
            ? darkTextWarningColor
            : theme == THEME.lightHighContrast
                ? lightTextWarningColor
                : darkTextWarningColor;
    textSuccessColor = theme == THEME.light
        ? lightTextSuccessColor
        : theme == THEME.dark
            ? darkTextSuccessColor
            : theme == THEME.lightHighContrast
                ? lightTextSuccessColor
                : darkTextSuccessColor;
    textdisabledColor = theme == THEME.light
        ? lightTextDisabledColor
        : theme == THEME.dark
            ? darkTextDisabledColor
            : theme == THEME.lightHighContrast
                ? lightTextDisabledColor
                : darkTextDisabledColor;
    primaryColour = theme == THEME.light
        ? primaryColor
        : theme == THEME.dark
            ? primaryColor
            : theme == THEME.lightHighContrast
                ? primaryColor
                : primaryColor;
  }
}
