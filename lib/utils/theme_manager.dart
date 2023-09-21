import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';

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

  late Color shadowColorXS;
  late List<BoxShadow> shadowXXS;
  late List<BoxShadow> shadowBottomControlButtons;

  late ThemeData datePickerThemeData;
  late ThemeData timePickerThemeData;

  Color toastDefaultColor = const Color.fromRGBO(236, 241, 255, 1);
  Color toastSuccessColor = const Color.fromRGBO(240, 253, 244, 1);
  Color toastWarningColor = const Color.fromRGBO(255, 251, 235, 1);
  Color toastErrorColor = const Color.fromRGBO(254, 242, 242, 1);
  Color toastDefaultBorderColor = const Color.fromRGBO(63, 118, 255, 1);
  Color toastSuccessBorderColor = const Color.fromRGBO(34, 197, 94, 1);
  Color toastWarningBorderColor = const Color.fromRGBO(245, 158, 11, 1);
  Color toastErrorBorderColor = const Color.fromRGBO(220, 38, 38, 1);
  // Color toastDefaultColor = Color.fromRGBO(236, 241, 255, 1);

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
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
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
    shadowColorXS = theme == THEME.light
        ? lightShadowColorXS
        : theme == THEME.dark
            ? darkShadowColorXS
            : theme == THEME.lightHighContrast
                ? lightShadowColorXS
                : theme == THEME.darkHighContrast
                    ? darkShadowColorXS
                    : Colors.transparent;

    datePickerThemeData = theme == THEME.light
        ? ThemeData.light().copyWith(
            dialogBackgroundColor: lightPrimaryBackgroundDefaultColor,
            colorScheme: const ColorScheme.light(
                brightness: Brightness.light,
                primary: primaryColor, // primary
                surface: primaryColor,
                onPrimary:
                    lightPrimaryBackgroundDefaultColor, // primary text color
                onSurface: lightPrimaryTextColor))
        : theme == THEME.dark
            ? ThemeData.light().copyWith(
                dialogBackgroundColor: tertiaryBackgroundDefaultColor,
                colorScheme: const ColorScheme.light(
                    brightness: Brightness.dark,
                    primary: primaryColor, // primary
                    onPrimary:
                        darkPrimaryBackgroundDefaultColor, // primary text color
                    surface: primaryColor,
                    onSurface: darkPrimaryTextColor))
            : theme == THEME.lightHighContrast
                ? ThemeData.light().copyWith(
                    dialogBackgroundColor: lightPrimaryBackgroundDefaultColor,
                    colorScheme: const ColorScheme.light(
                        brightness: Brightness.light,
                        primary: primaryColor, // primary
                        onPrimary:
                            lightPrimaryBackgroundDefaultColor, // primary text color
                        surface: primaryColor,
                        onSurface: lightContrastPrimaryTextColor))
                : theme == THEME.darkHighContrast
                    ? ThemeData.light().copyWith(
                        dialogBackgroundColor:
                            darkPrimaryBackgroundDefaultColor,
                        colorScheme: const ColorScheme.light(
                            brightness: Brightness.dark,
                            primary: primaryColor, // primary
                            onPrimary:
                                darkPrimaryBackgroundDefaultColor, // primary text color
                            surface: primaryColor,
                            onSurface: darkContrastPrimaryTextColor))
                    : theme == THEME.custom
                        ? ThemeData.light().copyWith(
                            dialogBackgroundColor: customBackgroundColor,
                            colorScheme: ColorScheme.light(
                                primary: customAccentColor, // primary
                                onPrimary:
                                    customBackgroundColor, // primary text color
                                surface: customAccentColor,
                                onSurface: customTextColor))
                        : ThemeData.light().copyWith(
                            dialogBackgroundColor: customBackgroundColor,
                            colorScheme: ColorScheme.light(
                                primary: customAccentColor, // primary
                                onPrimary:
                                    customBackgroundColor, // primary text color
                                surface: customAccentColor,
                                onSurface: customTextColor));

    timePickerThemeData = theme == THEME.light
        ? ThemeData.light().copyWith(
            dialogBackgroundColor: lightPrimaryBackgroundDefaultColor,
            colorScheme: const ColorScheme.light(
                brightness: Brightness.light,
                primary: primaryColor, // primary
                onPrimary:
                    lightPrimaryBackgroundDefaultColor, // primary text color
                surface: lightPrimaryBackgroundDefaultColor,
                onSurface: lightPrimaryTextColor))
        : theme == THEME.dark
            ? ThemeData.light().copyWith(
                dialogBackgroundColor: darkPrimaryBackgroundDefaultColor,
                colorScheme: const ColorScheme.light(
                    brightness: Brightness.dark,
                    primary: primaryColor, // primary
                    onPrimary:
                        darkPrimaryBackgroundDefaultColor, // primary text color
                    surface: darkPrimaryBackgroundDefaultColor,
                    onSurface: darkPrimaryTextColor))
            : theme == THEME.lightHighContrast
                ? ThemeData.light().copyWith(
                    dialogBackgroundColor: lightPrimaryBackgroundDefaultColor,
                    colorScheme: const ColorScheme.light(
                        brightness: Brightness.light,
                        primary: primaryColor, // primary
                        onPrimary:
                            lightPrimaryBackgroundDefaultColor, // primary text color
                        surface: lightPrimaryBackgroundDefaultColor,
                        onSurface: lightContrastPrimaryTextColor))
                : theme == THEME.darkHighContrast
                    ? ThemeData.light().copyWith(
                        dialogBackgroundColor:
                            darkPrimaryBackgroundDefaultColor,
                        colorScheme: const ColorScheme.light(
                            brightness: Brightness.dark,
                            primary: primaryColor, // primary
                            onPrimary:
                                darkPrimaryBackgroundDefaultColor, // primary text color
                            surface: darkPrimaryBackgroundDefaultColor,
                            onSurface: darkContrastPrimaryTextColor))
                    : theme == THEME.custom
                        ? ThemeData.light().copyWith(
                            dialogBackgroundColor: customBackgroundColor,
                            colorScheme: ColorScheme.light(
                                primary: customAccentColor, // primary
                                onPrimary:
                                    customBackgroundColor, // primary text color
                                surface: customBackgroundColor,
                                onSurface: customTextColor))
                        : ThemeData.light().copyWith(
                            dialogBackgroundColor: customBackgroundColor,
                            colorScheme: ColorScheme.light(
                                primary: customAccentColor, // primary
                                onPrimary:
                                    customBackgroundColor, // primary text color
                                surface: customBackgroundColor,
                                onSurface: customTextColor));

    shadowXXS = theme == THEME.light
        ? [
            const BoxShadow(
                color: Color.fromRGBO(23, 23, 23, 0.06),
                offset: Offset(0, 0),
                blurRadius: 1,
                spreadRadius: 0),
            const BoxShadow(
                color: Color.fromRGBO(23, 23, 23, 0.06),
                offset: Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0),
            const BoxShadow(
                color: Color.fromRGBO(23, 23, 23, 0.14),
                offset: Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0),
          ]
        : theme == THEME.dark
            ? [
                const BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    offset: Offset(0, 0),
                    blurRadius: 1,
                    spreadRadius: 0),
                const BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    offset: Offset(0, 1),
                    blurRadius: 3,
                    spreadRadius: 0),
              ]
            : theme == THEME.lightHighContrast
                ? [
                    const BoxShadow(
                        color: Color.fromRGBO(23, 23, 23, 0.06),
                        offset: Offset(0, 0),
                        blurRadius: 1,
                        spreadRadius: 0),
                    const BoxShadow(
                        color: Color.fromRGBO(23, 23, 23, 0.06),
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        spreadRadius: 0),
                    const BoxShadow(
                        color: Color.fromRGBO(23, 23, 23, 0.14),
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        spreadRadius: 0),
                  ]
                : theme == THEME.darkHighContrast
                    ? [
                        const BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.15),
                            offset: Offset(0, 0),
                            blurRadius: 1,
                            spreadRadius: 0),
                        const BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            spreadRadius: 0),
                      ]
                    : [];

    shadowBottomControlButtons = theme == THEME.light
        ? [
            const BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                offset: Offset(0, -2),
                blurRadius: 4,
                spreadRadius: 0),
          ]
        : theme == THEME.dark
            ? [
                const BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    offset: Offset(0, -2),
                    blurRadius: 4,
                    spreadRadius: 0),
              ]
            : theme == THEME.lightHighContrast
                ? [
                    const BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        offset: Offset(0, -2),
                        blurRadius: 4,
                        spreadRadius: 0),
                  ]
                : theme == THEME.darkHighContrast
                    ? [
                        const BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            offset: Offset(0, -2),
                            blurRadius: 4,
                            spreadRadius: 0),
                      ]
                    : [];
  }
}
