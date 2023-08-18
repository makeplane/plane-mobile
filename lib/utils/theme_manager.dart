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

  //late Color borderStrong01Color;
  late Color secondaryIcon;
  late Color primaryBackgroundSelectedColour;
  late Color secondaryBackgroundSelectedColor;
  late Color secondaryBackgroundActiveColor;

  late Color primaryToastBackgroundColor;
  late Color successBackgroundColor;

  Color convertHexToSpecificShade({required int shade, required Color color}) {
    if (shade <= 100) {
      var decimalValue = (100 - shade) / 100;
      var newR = (color.red + (255 - color.red) * decimalValue).floor();
      var newG = (color.green + (255 - color.green) * decimalValue).floor();
      var newB = (color.blue + (255 - color.blue) * decimalValue).floor();
      return Color.fromRGBO(newR, newG, newB, 1);
    } else {
      var decimalValue = 1 - ((shade - 100) / 100) / 10;

      var newR = (color.red * decimalValue).ceil();
      var newG = (color.green * decimalValue).ceil();
      var newB = (color.blue * decimalValue).ceil();

      return Color.fromRGBO(newR, newG, newB, 1);
    }
  }

  ThemeManager(this.theme) {
    primaryTextColor = theme == THEME.light
        ? lightPrimaryTextColor
        : theme == THEME.dark
            ? darkPrimaryTextColor
            : theme == THEME.lightHighContrast
                ? lightContrastPrimaryTextColor
                : theme == THEME.darkHighContrast
                    ? darkContrastPrimaryTextColor
                    : customTextColor;
    placeholderTextColor = theme == THEME.light
        ? lightPlaceholderTextColor
        : theme == THEME.dark
            ? darkPlaceholderTextColor
            : theme == THEME.lightHighContrast
                ? lightContrastPlaceholderTextColor
                : theme == THEME.darkHighContrast
                    ? lightContrastPlaceholderTextColor
                    : customTextColor;
    borderSubtle01Color = theme == THEME.light
        ? lightBorderSubtle01Color
        : theme == THEME.dark
            ? darkBorderSubtle01Color
            : theme == THEME.lightHighContrast
                ? darkBorderSubtle01Color
                : theme == THEME.darkHighContrast
                    ? lightBorderSubtle01Color
                    : convertHexToSpecificShade(
                        shade: 200, color: customBackgroundColor);

    // borderSubtle00Color = theme == THEME.light
    //     ? lightBorderSubtle00Color
    //     : theme == THEME.dark
    //         ? darkBorderSubtle00Color
    //         : theme == THEME.lightHighContrast
    //             ? darkBorderSubtle00Color
    //             : theme == THEME.darkHighContrast
    //                 ? lightBorderSubtle00Color
    //                 : convertHexToSpecificShade(
    //                     shade: 100, color: customBackgroundColor);

    borderStrong01Color = theme == THEME.light
        ? lightBorderStrong01Color
        : theme == THEME.dark
            ? darkBorderStrong01Color
            : theme == THEME.lightHighContrast
                ? darkBorderStrong01Color
                : theme == THEME.darkHighContrast
                    ? lightBorderStrong01Color
                    : convertHexToSpecificShade(
                        shade: 300, color: customBackgroundColor);

    borderDisabledColor = theme == THEME.light
        ? lightBorderDisabledColor
        : theme == THEME.dark
            ? darkBorderDisabledColor
            : theme == THEME.lightHighContrast
                ? darkBorderDisabledColor
                : theme == THEME.darkHighContrast
                    ? lightBorderDisabledColor
                    : convertHexToSpecificShade(
                        shade: 150, color: customBackgroundColor);

    textFieldTextStyle = GoogleFonts.inter(
        fontSize: 14,
        height: 1.428,
        color: primaryTextColor,
        fontWeight: FontWeight.w500);
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

    secondaryTextColor = theme == THEME.light
        ? lightSecondaryTextColor
        : theme == THEME.dark
            ? darkSecondaryTextColor
            : theme == THEME.lightHighContrast
                ? lightContrastSecondaryTextColor
                : theme == THEME.darkHighContrast
                    ? darkContrastSecondaryTextColor
                    : customTextColor;
    tertiaryTextColor = theme == THEME.light
        ? lightTertiaryTextColor
        : theme == THEME.dark
            ? darkTertiaryTextColor
            : theme == THEME.lightHighContrast
                ? lightContrastTertiaryTextColor
                : theme == THEME.darkHighContrast
                    ? darkContrastTertiaryTextColor
                    : customTextColor;

    textonColor = lightTextOnColorColor;
    textOnColorDisabled = theme == THEME.light
        ? lightTextOnColorDisabledColor
        : theme == THEME.dark
            ? darkContrastTextOnColorDisabledColor
            : theme == THEME.lightHighContrast
                ? lightTextOnColorDisabledColor
                : theme == THEME.darkHighContrast
                    ? darkContrastTextOnColorDisabledColor
                    : customTextColor;
    textErrorColor = theme == THEME.light
        ? lightTextErrorColor
        : theme == THEME.dark
            ? darkTextErrorColor
            : theme == THEME.lightHighContrast
                ? lightTextErrorColor
                : theme == THEME.darkHighContrast
                    ? darkTextErrorColor
                    : customTextColor;
    textWarningColor = theme == THEME.light
        ? lightTextWarningColor
        : theme == THEME.dark
            ? darkTextWarningColor
            : theme == THEME.lightHighContrast
                ? lightTextWarningColor
                : theme == THEME.darkHighContrast
                    ? darkTextWarningColor
                    : customTextColor;
    textSuccessColor = theme == THEME.light
        ? lightTextSuccessColor
        : theme == THEME.dark
            ? darkTextSuccessColor
            : theme == THEME.lightHighContrast
                ? lightTextSuccessColor
                : theme == THEME.darkHighContrast
                    ? darkTextSuccessColor
                    : customTextColor;
    textdisabledColor = theme == THEME.light
        ? lightTextDisabledColor
        : theme == THEME.dark
            ? darkTextDisabledColor
            : theme == THEME.lightHighContrast
                ? lightTextDisabledColor
                : theme == THEME.darkHighContrast
                    ? darkTextDisabledColor
                    : customTextColor;

    primaryColour = theme == THEME.light
        ? primaryColor
        : theme == THEME.dark
            ? primaryColor
            : theme == THEME.lightHighContrast
                ? primaryColor
                : theme == THEME.darkHighContrast
                    ? primaryColor
                    : customAccentColor;
    primaryBackgroundDefaultColor = theme == THEME.light
        ? lightPrimaryBackgroundDefaultColor
        : theme == THEME.dark
            ? darkPrimaryBackgroundDefaultColor
            : theme == THEME.lightHighContrast
                ? lightPrimaryBackgroundDefaultColor
                : theme == THEME.darkHighContrast
                    ? darkPrimaryBackgroundDefaultColor
                    : convertHexToSpecificShade(
                        shade: 100, color: customBackgroundColor);

    secondaryBackgroundDefaultColor = theme == THEME.light
        ? lightSecondaryBackgroundDefaultColor
        : theme == THEME.dark
            ? darkSecondaryBackgroundDefaultColor
            : theme == THEME.lightHighContrast
                ? lightSecondaryBackgroundDefaultColor
                : theme == THEME.darkHighContrast
                    ? darkSecondaryBackgroundDefaultColor
                    : convertHexToSpecificShade(
                        shade: 90, color: customBackgroundColor);

    tertiaryBackgroundDefaultColor = theme == THEME.light
        ? lightTertiaryBackgroundDefaultColor
        : theme == THEME.dark
            ? darkTertiaryBackgroundDefaultColor
            : theme == THEME.lightHighContrast
                ? lightTertiaryBackgroundDefaultColor
                : theme == THEME.darkHighContrast
                    ? darkTertiaryBackgroundDefaultColor
                    : convertHexToSpecificShade(
                        shade: 80, color: customBackgroundColor);
    disabledButtonColor = theme == THEME.light
        ? lightdisabledButtonColor
        : theme == THEME.dark
            ? darkdisabledButtonColor
            : theme == THEME.lightHighContrast
                ? lightdisabledButtonColor
                : darkdisabledButtonColor;
    secondaryIcon = theme == THEME.light
        ? lightSecondaryIconColor
        : theme == THEME.dark
            ? darkSecondaryIconColor
            : theme == THEME.lightHighContrast
                ? lightSecondaryIconColor
                : darkSecondaryIconColor;
    primaryBackgroundSelectedColour = theme == THEME.light
        ? lightPrimaryBackgroundSelectedColor
        : theme == THEME.dark
            ? darkPrimaryBackgroundSelectedColor
            : theme == THEME.lightHighContrast
                ? lightPrimaryBackgroundSelectedColor
                : theme == THEME.darkHighContrast
                    ? darkPrimaryBackgroundSelectedColor
                    : convertHexToSpecificShade(
                        shade: 90, color: customBackgroundColor);
    borderStrong01Color = theme == THEME.light
        ? lightBorderStrongColor
        : theme == THEME.dark
            ? darkBorderStrongColor
            : theme == THEME.lightHighContrast
                ? lightContrastBorderStrongColor
                : darkContrastBorderStrongColor;
    secondaryBackgroundSelectedColor = theme == THEME.light
        ? lightSecondaryBackgroundSelectedColor
        : theme == THEME.dark
            ? darkSecondaryBackgroundSelectedColor
            : theme == THEME.lightHighContrast
                ? lightSecondaryBackgroundSelectedColor
                : darkSecondaryBackgroundSelectedColor;

    primaryToastBackgroundColor = theme == THEME.light
        ? lightToastBackgroundColor
        : theme == THEME.dark
            ? darkToastBackgroundColor
            : theme == THEME.lightHighContrast
                ? lightToastBackgroundColor
                : theme == THEME.darkHighContrast
                    ? darkToastBackgroundColor
                    : customBackgroundColor;

    successBackgroundColor = theme == THEME.light
        ? lightSucessBackground
        : theme == THEME.dark
            ? darkSucessBackground
            : theme == THEME.lightHighContrast
                ? lightSucessBackground
                : darkSucessBackground;
    secondaryBackgroundActiveColor = theme == THEME.light
        ? lightSecondaryBackgroundActiveColor
        : theme == THEME.dark
            ? darkSecondaryBackgroundActiveColor
            : theme == THEME.lightHighContrast
                ? lightSecondaryBackgroundActiveColor
                : theme == THEME.darkHighContrast
                    ? darkSecondaryBackgroundActiveColor
                    : convertHexToSpecificShade(
                        shade: 10,
                        color: convertHexToSpecificShade(
                            shade: 100, color: primaryColour));
  }
}
