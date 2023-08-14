import 'package:flutter/material.dart';
import 'package:plane_startup/provider/theme_provider.dart';
import 'package:plane_startup/utils/constants.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key, required this.themeProvider});

  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      height: 1,
      color: themeProvider.themeManager.borderDisabledColor,
    );
  }
}
