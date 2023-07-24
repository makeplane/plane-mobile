import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/provider/theme_provider.dart';
import 'package:plane_startup/utils/constants.dart';


enum RichFontStyle {
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

class CustomRichText extends ConsumerWidget {
  const CustomRichText(
   {
    this.maxLines,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.overflow,
    this.textAlign = TextAlign.center,
    this.type = RichFontStyle.title,
    required this.widgets,
    final Key? key,
  }) : super(key: key);
  final int? maxLines;
  final TextStyle? style;
  final TextAlign? textAlign;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final RichFontStyle? type;
  final TextOverflow? overflow;
  final List<InlineSpan> widgets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var style = getStyle(type, themeProvider);

    return RichText(
      text: TextSpan(children: widgets, style: style.merge(style)),
    );
  }

  TextStyle getStyle(RichFontStyle? type, ThemeProvider themeProvider) {
    switch (type) {
      case RichFontStyle.mainHeading:
        return TextStyle(
          fontSize: fontSize ?? 24,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: themeProvider.isDarkThemeEnabled
              ? darkPrimaryTextColor
              : lightPrimaryTextColor,
        );

      case RichFontStyle.description:
        return TextStyle(
            fontSize: fontSize ?? 16,
            fontWeight: fontWeight ?? FontWeight.w400,
            fontFamily: 'SF Pro Display',
            // color: color ?? themeProvider.primaryTextColor,
            color: color ??
                (themeProvider.isDarkThemeEnabled
                    ? darkPrimaryTextColor
                    : lightPrimaryTextColor));

      case RichFontStyle.smallText:
        return TextStyle(
          fontSize: fontSize ?? 13,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: themeProvider.isDarkThemeEnabled
              ? darkPrimaryTextColor
              : lightPrimaryTextColor,
        );

      case RichFontStyle.text:
        return TextStyle(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : lightPrimaryTextColor),
        );

      case RichFontStyle.secondaryText:
        return TextStyle(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.secondaryTextColor,
          color: themeProvider.isDarkThemeEnabled
              ? darkSecondaryTextColor
              : lightSecondaryTextColor,
        );

      case RichFontStyle.heading:
        // return GoogleFonts.getFont(APP_FONT).copyWith(
        //     fontSize: fontSize ?? 24,
        //     color: color ?? Colors.black,
        //     fontWeight: fontWeight ?? FontWeight.bold);
        return TextStyle(
          fontSize: fontSize ?? 26,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : lightPrimaryTextColor),
        );
      case RichFontStyle.heading2:
        // return GoogleFonts.getFont(APP_FONT).copyWith(
        //     fontSize: fontSize ?? 19,
        //     color: color ?? Colors.black,
        //     letterSpacing: 0.8,
        //     fontWeight: fontWeight ?? FontWeight.bold);
        return TextStyle(
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: themeProvider.isDarkThemeEnabled
              ? darkPrimaryTextColor
              : lightPrimaryTextColor,
        );
      case RichFontStyle.title:
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
      case RichFontStyle.subheading:
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
          color: themeProvider.isDarkThemeEnabled
              ? darkSecondaryTextColor
              : lightSecondaryTextColor,
        );
      case RichFontStyle.boldTitle:
        // return GoogleFonts.getFont(APP_FONT).copyWith(
        //     fontSize: fontSize ?? 18,
        //     color: color ?? Colors.black,
        //     fontWeight: fontWeight ?? FontWeight.bold);
        return TextStyle(
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : lightPrimaryTextColor),
        );
      case RichFontStyle.subtitle:
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
                    : lightStrokeColor));
      case RichFontStyle.boldSubtitle:
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
                  : lightPrimaryTextColor),
        );
      case RichFontStyle.buttonText:
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
      case RichFontStyle.appbarTitle:
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
                  : lightPrimaryTextColor),
        );
      default:
        return TextStyle(
          fontFamily: 'SF Pro Display',
          color: color ?? Colors.black,
          fontWeight: fontWeight ?? FontWeight.normal,
          fontSize: fontSize ?? 17,
        );
    }
  }


}
