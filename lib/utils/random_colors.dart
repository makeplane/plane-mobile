import 'dart:math';

import 'package:flutter/material.dart';

class RandomColors {
  List<Color> listOfColors = const [
    //From figma
    Color.fromRGBO(247, 174, 89, 1),
    Color.fromRGBO(255, 83, 83, 1),
    Color.fromRGBO(5, 195, 255, 1),
    Color.fromRGBO(9, 169, 83, 1),

    //Some random colors
    Color.fromRGBO(9, 150, 169, 1),
    Color.fromRGBO(134, 169, 9, 1),
    Color.fromRGBO(198, 101, 222, 1),
    Color.fromRGBO(78, 9, 169, 1),
    Color.fromRGBO(164, 9, 169, 1),
    Color.fromRGBO(169, 9, 70, 1),
    Color.fromRGBO(169, 65, 9, 1),
    Color.fromRGBO(142, 158, 123, 1),
    Color.fromRGBO(88, 22, 109, 1),
    Color.fromRGBO(47, 45, 167, 1),

    //From some other class
    Color.fromRGBO(48, 0, 240, 1),
    Color.fromRGBO(209, 88, 0, 1),
    Color.fromRGBO(167, 0, 209, 1),
  ];
  Color getRandomColor() {
    Random randomIndex = Random();
    Color colorToReturn =
        listOfColors[randomIndex.nextInt(listOfColors.length - 1)];
    return colorToReturn;
  }
}
