import 'package:flutter/material.dart';

extension StringExtension on String {
  String fistLetterToUpper() {
    final String value = this;
    return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
  }

  String lastNCharecters(int n) {
    final String value = this;
    return value.substring(value.length - n);
  }

  Color toColor() {
    const Color colorToReturnOnApiError = Color.fromARGB(255, 200, 80, 80);
    final String colorData = this;
    return (!isValidHexaCode(colorData))
        ? colorToReturnOnApiError
        : Color(int.parse("FF${colorData.replaceAll('#', '')}", radix: 16));
  }

  static bool isValidHexaCode(String str) {
    final RegExp hexaCode = RegExp(r"^#([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$");
    return hexaCode.hasMatch(str);
  }
}
