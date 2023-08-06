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
  headingH1Regular,
  headingH1Medium,
  headingH1SemiBold,
  headingH1Bold,
  headingH1ExtraBold,
  headingH2Regular,
  headingH2Medium,
  headingH2SemiBold,
  headingH2Bold,
  headingH2ExtraBold,
  headingH3Regular,
  headingH3Medium,
  headingH3SemiBold,
  headingH3Bold,
  headingH3ExtraBold,
  headingH4Regular,
  headingH4Medium,
  headingH4SemiBold,
  headingH4Bold,
  headingH4ExtraBold,
  headingH5Regular,
  headingH5Medium,
  headingH5SemiBold,
  headingH5Bold,
  headingH5ExtraBold,
  headingH6Regular,
  headingH6Medium,
  headingH6SemiBold,
  headingH6Bold,
  headingH6ExtraBold,
  paragraphLargeRegular,
  paragraphLargeMedium,
  paragraphLargeSemiBold,
  paragraphMediumRegular,
  paragraphMediumMedium,
  paragraphMediumSemiBold,
  paragraphSmallRegular,
  paragraphSmallMedium,
  paragraphSmallSemiBold,
  paragraphXSmallRegular,
  paragraphXSmallMedium,
  paragraphXSmallSemiBold,
  paragraphOverlineLargeRegular,
  paragraphOverlineLargeMedium,
  paragraphOverlineLargeSemiBold,
  paragraphOverlineSmallRegular,
  paragraphOverlineSmallMedium,
  paragraphOverlineSmallSemiBold,
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
                    : lightPrimaryTextColor));

      case FontStyle.description:
        return TextStyle(
            fontSize: fontSize ?? 16,
            fontWeight: fontWeight ?? FontWeight.w400,
            fontFamily: 'SF Pro Display',
            // color: color ?? themeProvider.primaryTextColor,
            color: color ??
                (themeProvider.isDarkThemeEnabled
                    ? darkPrimaryTextColor
                    : lightPrimaryTextColor));

      case FontStyle.smallText:
        return TextStyle(
          fontSize: fontSize ?? 13,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : lightPrimaryTextColor),
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
                  : lightPrimaryTextColor),
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
                  : lightPrimaryTextColor),
        );

      case FontStyle.heading:
        // return GoogleFonts.getFont(APP_FONT).copyWith(
        //     fontSize: fontSize ?? 24,
        //     color: color ?? lightPrimaryTextColorlack,
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
                  : lightPrimaryTextColor),
        );
      case FontStyle.heading2:
        // return GoogleFonts.getFont(APP_FONT).copyWith(
        //     fontSize: fontSize ?? 19,
        //     color: color ?? lightPrimaryTextColorlack,
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
                    : lightPrimaryTextColor));
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
        //     color: color ?? lightPrimaryTextColorlack,
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
                  : lightPrimaryTextColor),
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
                    : lightPrimaryTextColor));
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
                  : lightPrimaryTextColor),
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
                  : lightPrimaryTextColor),
        );

      case FontStyle.headingH1Regular:
        return TextStyle(
          fontSize: fontSize ?? 36,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH1Medium:
        return TextStyle(
          fontSize: fontSize ?? 36,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH1SemiBold:
        return TextStyle(
          fontSize: fontSize ?? 36,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH1Bold:
        return TextStyle(
          fontSize: fontSize ?? 36,
          fontWeight: fontWeight ?? FontWeight.w700,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH1ExtraBold:
        return TextStyle(
          fontSize: fontSize ?? 36,
          fontWeight: fontWeight ?? FontWeight.w800,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH2Regular:
        return TextStyle(
          fontSize: fontSize ?? 32,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH2Medium:
        return TextStyle(
          fontSize: fontSize ?? 32,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH2SemiBold:
        return TextStyle(
          fontSize: fontSize ?? 32,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH2Bold:
        return TextStyle(
          fontSize: fontSize ?? 32,
          fontWeight: fontWeight ?? FontWeight.w700,
          fontFamily: 'SF Pro Display',
          // color: color ?? themeProvider.primaryTextColor,
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH2ExtraBold:
        return TextStyle(
          fontSize: fontSize ?? 32,
          fontWeight: fontWeight ?? FontWeight.w800,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH3Regular:
        return TextStyle(
          fontSize: fontSize ?? 28,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH3Medium:
        return TextStyle(
          fontSize: fontSize ?? 28,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH3SemiBold:
        return TextStyle(
          fontSize: fontSize ?? 28,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH3Bold:
        return TextStyle(
          fontSize: fontSize ?? 28,
          fontWeight: fontWeight ?? FontWeight.w700,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH3ExtraBold:
        return TextStyle(
          fontSize: fontSize ?? 28,
          fontWeight: fontWeight ?? FontWeight.w800,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH4Regular:
        return TextStyle(
          fontSize: fontSize ?? 24,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH4Medium:
        return TextStyle(
          fontSize: fontSize ?? 24,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH4SemiBold:
        return TextStyle(
          fontSize: fontSize ?? 24,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH4Bold:
        return TextStyle(
          fontSize: fontSize ?? 24,
          fontWeight: fontWeight ?? FontWeight.w700,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH4ExtraBold:
        return TextStyle(
          fontSize: fontSize ?? 24,
          fontWeight: fontWeight ?? FontWeight.w800,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH5Regular:
        return TextStyle(
          fontSize: fontSize ?? 20,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH5Medium:
        return TextStyle(
          fontSize: fontSize ?? 20,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH5SemiBold:
        return TextStyle(
          fontSize: fontSize ?? 20,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH5Bold:
        return TextStyle(
          fontSize: fontSize ?? 20,
          fontWeight: fontWeight ?? FontWeight.w700,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH5ExtraBold:
        return TextStyle(
          fontSize: fontSize ?? 20,
          fontWeight: fontWeight ?? FontWeight.w800,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH6Regular:
        return TextStyle(
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH6Medium:
        return TextStyle(
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH6SemiBold:
        return TextStyle(
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH6Bold:
        return TextStyle(
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w700,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.headingH6ExtraBold:
        return TextStyle(
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w800,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkTextHeadingColor
                  : lightTextHeadingColor),
        );

      case FontStyle.paragraphLargeRegular:
        return TextStyle(
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : lightPrimaryTextColor),
        );

      case FontStyle.paragraphLargeMedium:
        return TextStyle(
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : lightPrimaryTextColor),
        );

      case FontStyle.paragraphLargeSemiBold:
        return TextStyle(
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : lightPrimaryTextColor),
        );

      case FontStyle.paragraphMediumRegular:
        return TextStyle(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : lightPrimaryTextColor),
        );

      case FontStyle.paragraphMediumMedium:
        return TextStyle(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : lightPrimaryTextColor),
        );

      case FontStyle.paragraphMediumSemiBold:
        return TextStyle(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : lightPrimaryTextColor),
        );

      case FontStyle.paragraphSmallRegular:
        return TextStyle(
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : lightPrimaryTextColor),
        );

      case FontStyle.paragraphSmallMedium:
        return TextStyle(
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : lightPrimaryTextColor),
        );

      case FontStyle.paragraphSmallSemiBold:
        return TextStyle(
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : lightPrimaryTextColor),
        );

      case FontStyle.paragraphXSmallRegular:
        return TextStyle(
          fontSize: fontSize ?? 13,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : lightPrimaryTextColor),
        );

      case FontStyle.paragraphXSmallMedium:
        return TextStyle(
          fontSize: fontSize ?? 13,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : lightPrimaryTextColor),
        );

      case FontStyle.paragraphXSmallSemiBold:
        return TextStyle(
          fontSize: fontSize ?? 13,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : lightPrimaryTextColor),
        );

      case FontStyle.paragraphOverlineLargeRegular:
        return TextStyle(
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : lightPrimaryTextColor),
        );

      case FontStyle.paragraphOverlineLargeMedium:
        return TextStyle(
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontFamily: 'SF Pro Display',
          color: color ?? lightPrimaryTextColor,
        );

      case FontStyle.paragraphOverlineLargeSemiBold:
        return TextStyle(
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          color: color ?? lightPrimaryTextColor,
        );

      case FontStyle.paragraphOverlineSmallRegular:
        return TextStyle(
          fontSize: fontSize ?? 12,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: 'SF Pro Display',
          color: color ?? lightPrimaryTextColor,
        );

      case FontStyle.paragraphOverlineSmallMedium:
        return TextStyle(
          fontSize: fontSize ?? 12,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontFamily: 'SF Pro Display',
          color: color ?? lightPrimaryTextColor,
        );

      case FontStyle.paragraphOverlineSmallSemiBold:
        return TextStyle(
          fontSize: fontSize ?? 12,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: 'SF Pro Display',
          color: color ?? lightPrimaryTextColor,
        );

      default:
        return TextStyle(
          fontFamily: 'SF Pro Display',
          color: color ??
              (themeProvider.isDarkThemeEnabled
                  ? darkPrimaryTextColor
                  : lightPrimaryTextColor),
          fontWeight: fontWeight ?? FontWeight.normal,
          fontSize: fontSize ?? 17,
        );
    }
  }
}
