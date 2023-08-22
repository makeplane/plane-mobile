import 'dart:math';

import 'package:flutter/material.dart';

class ColorManager {
  static List<Color> listOfColors = const [
    //From figma
    Color.fromRGBO(99, 88, 236, 1),
    Color.fromRGBO(105, 26, 188, 1),
    Color.fromRGBO(174, 63, 202, 1),
    Color.fromRGBO(82, 171, 159, 1),
    Color.fromRGBO(60, 118, 105, 1),
    Color.fromRGBO(134, 123, 98, 1),
    Color.fromRGBO(162, 103, 101, 1),
    Color.fromRGBO(195, 79, 93, 1),
    Color.fromRGBO(218, 136, 74, 1),
  ];

  static Color getColorWithIndex(int index) {
    index = index % listOfColors.length;
    Color colorToReturn = listOfColors[index];
    return colorToReturn;
  }

  static Color getColorRandomly() {
    Random randomIndex = Random();
    Color colorToReturn =
        listOfColors[randomIndex.nextInt(listOfColors.length - 1)];
    return colorToReturn;
  }

  static Color getColorFromHexaDecimal(String value) {
    Color colorToReturnOnApiError = const Color.fromARGB(255, 200, 80, 80);
    String? colorData = value;

    return (colorData == null || colorData[0] != '#')
        ? colorToReturnOnApiError
        : Color(int.parse("FF${colorData.replaceAll('#', '')}", radix: 16));
  }
}
