import 'package:flutter/material.dart';
import 'package:plane/provider/theme_provider.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider(
      {super.key,
      required this.themeProvider,
      this.margin = const EdgeInsets.only(top: 10, bottom: 10)});

  final ThemeProvider themeProvider;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: 1,
      color: themeProvider.themeManager.borderSubtle01Color,
    );
  }
}
