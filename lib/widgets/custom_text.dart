// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/provider/theme_provider.dart';
import 'package:plane/utils/constants.dart';
import '../utils/enums.dart';

Map<FontStyle, double> fontSIZE = {
  FontStyle.H1: 36,
  FontStyle.H2: 32,
  FontStyle.H3: 28,
  FontStyle.H4: 24,
  FontStyle.H5: 20,
  FontStyle.H6: 18,
  FontStyle.Large: 18,
  FontStyle.Medium: 16,
  FontStyle.Small: 14,
  FontStyle.XSmall: 12,
  FontStyle.overline: 12
};
Map<FontStyle, double> lineHeight = {
  FontStyle.H1: 1.222,
  FontStyle.H2: 1.25,
  FontStyle.H3: 1.285,
  FontStyle.H4: 1.333,
  FontStyle.H5: 1.4,
  FontStyle.H6: 1.333,
  FontStyle.Large: 1.444,
  FontStyle.Medium: 1.5,
  FontStyle.Small: 1.42,
  FontStyle.XSmall: 1.66,
  FontStyle.overline: 1
};
Map fontWEIGHT = {
  FontWeightt.Regular: FontWeight.w400,
  FontWeightt.Medium: FontWeight.w500,
  FontWeightt.Semibold: FontWeight.w600,
  FontWeightt.Bold: FontWeight.w700,
  FontWeightt.ExtraBold: FontWeight.w800,
};
Map<FontStyle, double> fontTRACKING = {
  FontStyle.H1: -1,
  FontStyle.H2: -1,
  FontStyle.H3: -1,
  FontStyle.H4: -1,
  FontStyle.H5: -1,
  FontStyle.H6: -1,
  FontStyle.Large: 0,
  FontStyle.Medium: 0,
  FontStyle.Small: 0,
  FontStyle.XSmall: 0,
  FontStyle.overline: 0
};

Color APP_TEXT_GREY = const Color.fromRGBO(135, 135, 135, 1);
String APP_FONT = 'Inter';

class CustomText extends ConsumerWidget {
  const CustomText(
    this.text, {
    this.maxLines = 4,
    this.overrride,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.overflow,
    this.textAlign = TextAlign.start,
    this.type = FontStyle.Medium,
    this.letterSpacing,
    final Key? key,
  }) : super(key: key);
  final String text;
  final int? maxLines;
  final TextStyle? style;
  final TextAlign? textAlign;
  final double? fontSize;
  final FontWeightt? fontWeight;
  final Color? color;
  final FontStyle? type;
  final TextOverflow? overflow;
  final bool? overrride;
  final double? letterSpacing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final style = getStyle(type, themeProvider, letterSpacing);

    return Text(
      text.toString(),
      maxLines: maxLines ?? 1,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: style.merge(style),
    );
  }

  TextStyle getStyle(
      FontStyle? type, ThemeProvider themeProvider, double? letterSpacing) {
    // log(customTextColor.toString());
    return GoogleFonts.inter(
        letterSpacing:
            letterSpacing ?? ((type != null) ? -(fontSIZE[type]! * 0.02) : 0),
        height: type != null ? lineHeight[type] : null,
        fontSize: fontSize ?? (type != null ? fontSIZE[type] : 18),
        fontWeight:
            fontWeight != null ? fontWEIGHT[fontWeight] : FontWeight.normal,
        color: overrride == true
            ? color
            : themeProvider.theme == THEME.custom
                ? customTextColor
                : (color ?? themeProvider.themeManager.primaryTextColor));
  }
}
