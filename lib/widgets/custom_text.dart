import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:plane_startup/provider/theme_provider.dart';
import 'package:plane_startup/utils/constants.dart';

// ignore: constant_identifier_names
// const APP_FONT = 'Lexend';
const appFont = 'Poppins';

enum FontStyle {
  heading,
  heading2,
  subheading,
  title,
  subtitle,
  boldTitle,
  boldSubtitle,
  appbarTitle,
  buttonText,
  mainHeading,
  description,
  text,
  smallText,
  secondaryText,
}

// ignore: non_constant_identifier_names
Color APP_TEXT_GREY = const Color.fromRGBO(135, 135, 135, 1);

class CustomText extends ConsumerWidget {
  const CustomText(
    this.text, {
    this.maxLines = 4,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.overflow,
    this.textAlign = TextAlign.start,
    this.type = FontStyle.title,
    final Key? key,
  }) : super(key: key);
  final String text;
  final int? maxLines;
  final TextStyle? style;
  final TextAlign? textAlign;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final FontStyle? type;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var style = getStyle(type, themeProvider);

    return Text(
      text.toString(),
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: style.merge(style),
    );
  }

  TextStyle getStyle(FontStyle? type, ThemeProvider themeProvider) {
    switch (type) {
      case FontStyle.mainHeading:
        return TextStyle(
            fontSize: fontSize ?? 24,
            fontWeight: fontWeight ?? FontWeight.w600,
            fontFamily: 'SF Pro Display',
            // color: color ?? themeProvider.primaryTextColor,
            color: color ??
                (themeProvider.isDarkThemeEnabled
                    ? darkPrimaryTextColor
                    : Colors.black));

      case FontStyle.description:
        return TextStyle(
            fontSize: fontSize ?? 16,
            fontWeight: fontWeight ?? FontWeight.w400,
            fontFamily: 'SF Pro Display',
            // color: color ?? themeProvider.primaryTextColor,
            color: color ??
                (themeProvider.isDarkThemeEnabled
                    ? darkPrimaryTextColor
                    : Colors.black));

      case FontStyle.smallText:
        return TextStyle(
          fontSize: fontSize ?? 13,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : Colors.black),
        );

      case FontStyle.text:
        return TextStyle(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',

          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : Colors.black),
          overflow: overflow ?? TextOverflow.visible,
        );

      case FontStyle.secondaryText:
        return TextStyle(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.secondaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkSecondaryTextColor
                  : Colors.black),
        );

      case FontStyle.heading:
        // return GoogleFonts.getFont(APP_FONT).copyWith(
        //     fontSize: fontSize ?? 24,
        //     color: color ?? Colors.blacklack,
        //     fontWeight: fontWeight ?? FontWeight.bold);
        return TextStyle(
          overflow: overflow ?? TextOverflow.visible,
          fontSize: fontSize ?? 26,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : Colors.black),
        );
      case FontStyle.heading2:
        // return GoogleFonts.getFont(APP_FONT).copyWith(
        //     fontSize: fontSize ?? 19,
        //     color: color ?? Colors.blacklack,
        //     letterSpacing: 0.8,
        //     fontWeight: fontWeight ?? FontWeight.bold);
        return TextStyle(
            fontSize: fontSize ?? 18,
            fontWeight: fontWeight ?? FontWeight.w500,
            fontFamily: 'SF Pro Display',
            // color: color ?? themeProvider.primaryTextColor,
            color: color ??
                (themeProvider.isDarkThemeEnabled
                    ? darkPrimaryTextColor
                    : Colors.black));
      case FontStyle.title:
        // return GoogleFonts.getFont(APP_FONT).copyWith(
        //     fontSize: fontSize ?? 16,
        //     color: color ?? themeProvider.secondaryTextColor,
        //     fontWeight: fontWeight ?? FontWeight.w500);
        return TextStyle(
            fontSize: fontSize ?? 16,
            fontWeight: fontWeight ?? FontWeight.w400,
            fontFamily: 'SF Pro Display',
            // color: color ?? themeProvider.secondaryTextColor,
            color: color ??
                (themeProvider.isDarkThemeEnabled
                    ? darkSecondaryTextColor
                    : lightSecondaryTextColor));
      case FontStyle.subheading:
        // return GoogleFonts.getFont(APP_FONT).copyWith(
        //     fontSize: fontSize ?? 18,
        //     color: color ??
        //         (themeProvider.isDarkThemeEnabled
        //             ? darkSecondaryTextColor
        //             : lightPrimaryTextColor),
        //     fontWeight: fontWeight ?? FontWeight.w500);
        return TextStyle(
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.secondaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkSecondaryTextColor
                  : lightSecondaryTextColor),
          overflow: overflow ?? TextOverflow.visible,
        );
      case FontStyle.boldTitle:
        // return GoogleFonts.getFont(APP_FONT).copyWith(
        //     fontSize: fontSize ?? 18,
        //     color: color ?? Colors.blacklack,
        //     fontWeight: fontWeight ?? FontWeight.bold);
        return TextStyle(
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          overflow: overflow ?? TextOverflow.visible,
          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : Colors.black),
        );
      case FontStyle.subtitle:
        // return GoogleFonts.getFont(APP_FONT).copyWith(
        //     fontSize: fontSize ?? 14,
        //     color: color ?? const Color(0xff222222),
        //     fontWeight: fontWeight ?? FontWeight.normal);
        return TextStyle(
            fontSize: fontSize ?? 14,
            fontWeight: fontWeight ?? FontWeight.w400,
            fontFamily: 'SF Pro Display',
            // color: color ?? themeProvider.strokeColor,
            color: color ??
                (themeProvider.isDarkThemeEnabled
                    ? darkStrokeColor
                    : Colors.black));
      case FontStyle.boldSubtitle:
        // return GoogleFonts.getFont(APP_FONT).copyWith(
        //     fontSize: fontSize ?? 16,
        //     color: color ?? const Color(0xff222222),
        //     fontWeight: fontWeight ?? FontWeight.bold);
        return TextStyle(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : Colors.black),
        );
      case FontStyle.buttonText:
        // return GoogleFonts.getFont(APP_FONT).copyWith(
        //     fontSize: fontSize ?? 17,
        //     color: color ?? Colors.white,
        //     fontWeight: fontWeight ?? FontWeight.w500);
        return TextStyle(
          fontSize: fontSize ?? 17,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontFamily: 'SF Pro Display',
          color: color ?? Colors.white,
        );
      case FontStyle.appbarTitle:
        // return GoogleFonts.getFont(APP_FONT).copyWith(
        //     fontSize: fontSize ?? 18,
        //     color: color ?? const Color(0xff222222),
        //     fontWeight: fontWeight ?? FontWeight.bold);
        return TextStyle(
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : Colors.black),
        );
      default:
        return TextStyle(
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled ? Colors.white : Colors.black),
          fontWeight: fontWeight ?? FontWeight.normal,
          fontSize: fontSize ?? 17,
        );
    }
  }
}
