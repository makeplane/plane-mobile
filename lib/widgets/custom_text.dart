// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/provider/theme_provider.dart';
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

};
var lineHeight = {
  FontStyle.H1: 44,
  FontStyle.H2: 40,
  FontStyle.H3: 36,
  FontStyle.H4: 32,
  FontStyle.H5: 28,
  FontStyle.H6: 24,
  FontStyle.Large: 26,
  FontStyle.Medium: 24,
  FontStyle.Small: 20,
  FontStyle.XSmall: 20,
};
var fontWEIGHT = {
  FontWeightt.Regular: FontWeight.w400,
  FontWeightt.Medium: FontWeight.w500,
  FontWeightt.Semibold: FontWeight.w600,
  FontWeightt.Bold: FontWeight.w700,
  FontWeightt.ExtraBold: FontWeight.w800,
};

Color APP_TEXT_GREY = const Color.fromRGBO(135, 135, 135, 1);
String APP_FONT = 'Inter';

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
    this.type = FontStyle.Medium,
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
    return TextStyle(
        fontSize: fontSize ?? (type != null ? fontSIZE[type] : 18),
        fontWeight:
            fontWeight != null ? fontWEIGHT[fontWeight] : FontWeight.normal,
        fontFamily: APP_FONT,
        color: color ?? themeProvider.themeManager.primaryTextColor);
  }
}
