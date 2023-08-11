import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';

class ThemeManager {
  final THEME theme;
  // TEXT COLORS ///
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
  late Color disabledButtonColor;

  // TextField Decoration
  late InputDecoration textFieldDecoration;
  late TextStyle textFieldTextStyle;

  ///BACKGROUND COLORS///
  late Color primaryColour;
  late Color primaryBackgroundDefaultColor;
  late Color secondaryBackgroundDefaultColor;
  late Color tertiaryBackgroundDefaultColor;
  late Color borderSubtle00Color;
  late Color borderSubtle01Color;
  late Color borderStrong01Color;
  late Color borderDisabledColor;

  ThemeManager(this.theme) {
    placeholderTextColor = theme == THEME.light
        ? lightPlaceholderTextColor
        : theme == THEME.dark
            ? darkPlaceholderTextColor
            : theme == THEME.lightHighContrast
                ? lightContrastPlaceholderTextColor
                : lightContrastPlaceholderTextColor;
    borderSubtle01Color = theme == THEME.light
        ? lightBorderSubtle01Color
        : theme == THEME.dark
            ? darkBorderSubtle01Color
            : theme == THEME.lightHighContrast
                ? darkBorderSubtle01Color
                : lightBorderSubtle01Color;

                    borderSubtle00Color = theme == THEME.light
        ? lightBorderSubtle00Color
        : theme == THEME.dark
            ? darkBorderSubtle00Color
            : theme == THEME.lightHighContrast
                ? darkBorderSubtle00Color
                : lightBorderSubtle00Color;

                borderStrong01Color= theme == THEME.light
        ? lightBorderStrong01Color
        : theme == THEME.dark
            ? darkBorderStrong01Color
            : theme == THEME.lightHighContrast
                ? darkBorderStrong01Color
                : lightBorderStrong01Color;
    borderDisabledColor = theme == THEME.light
        ? lightBorderDisabledColor
        : theme == THEME.dark
            ? darkBorderDisabledColor
            : theme == THEME.lightHighContrast
                ? darkBorderDisabledColor
                : lightBorderDisabledColor;
    textFieldTextStyle = GoogleFonts.inter(
      fontSize: 14,
      height: 1.428,
      color: placeholderTextColor,
    );
    textFieldDecoration = InputDecoration(
      errorStyle: GoogleFonts.lato(
          fontSize: 14, color: Colors.red, fontWeight: FontWeight.w400),
      //contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      labelStyle: const TextStyle(
        color: Color(0xFFA3A3A3),
      ),
      alignLabelWithHint: true,
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 253, 17, 0)),
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.shade600, width: 2.0),
        borderRadius: BorderRadius.circular(6
            // topRight: Radius.circular(6),
            // bottomRight: Radius.circular(6),
            ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: borderSubtle01Color, width: 1.0),
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderSubtle01Color, width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderSubtle01Color, width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
    );
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
    primaryBackgroundDefaultColor = theme == THEME.light
        ? lightPrimaryBackgroundDefaultColor
        : theme == THEME.dark
            ? darkPrimaryBackgroundDefaultColor
            : theme == THEME.lightHighContrast
                ? lightPrimaryBackgroundDefaultColor
                : darkPrimaryBackgroundDefaultColor;
    secondaryBackgroundDefaultColor = theme == THEME.light
        ? lightSecondaryBackgroundDefaultColor
        : theme == THEME.dark
            ? darkSecondaryBackgroundDefaultColor
            : theme == THEME.lightHighContrast
                ? lightSecondaryBackgroundDefaultColor
                : darkSecondaryBackgroundDefaultColor;

    tertiaryBackgroundDefaultColor = theme == THEME.light
        ? lightTertiaryBackgroundDefaultColor
        : theme == THEME.dark
            ? darkTertiaryBackgroundDefaultColor
            : theme == THEME.lightHighContrast
                ? lightTertiaryBackgroundDefaultColor
                : darkTertiaryBackgroundDefaultColor;
    disabledButtonColor = theme == THEME.light
        ? lightdisabledButtonColor
        : theme == THEME.dark
            ? darkdisabledButtonColor
            : theme == THEME.lightHighContrast
                ? lightdisabledButtonColor
                : darkdisabledButtonColor;
  }
}
