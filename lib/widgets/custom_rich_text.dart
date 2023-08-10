import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/provider/theme_provider.dart';
import 'package:plane_startup/utils/enums.dart';
import 'custom_text.dart';

class CustomRichText extends ConsumerWidget {
  const CustomRichText({
    this.maxLines,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.overflow,
    this.textAlign = TextAlign.center,
    this.type = FontStyle.Medium,
    required this.widgets,
    final Key? key,
  }) : super(key: key);
  final int? maxLines;
  final TextStyle? style;
  final TextAlign? textAlign;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final FontStyle? type;
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

  TextStyle getStyle(FontStyle? type, ThemeProvider themeProvider) {
    return GoogleFonts.inter(
        height: type!=null? lineHeight[type] : null,
        fontSize: fontSize ?? (type != null ? fontSIZE[type] : 18),
        fontWeight:
            fontWeight != null ? fontWEIGHT[fontWeight] : FontWeight.normal,
        color: color ?? themeProvider.themeManager.primaryTextColor);

  }
}
