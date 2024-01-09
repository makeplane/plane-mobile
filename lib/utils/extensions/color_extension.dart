import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color lighten([double factor = 0.1]) {
    final hslColor = HSLColor.fromColor(this);
    final lightenedColor =
        hslColor.withLightness((hslColor.lightness + factor).clamp(0.0, 1.0));
    return lightenedColor.toColor();
  }

  Color darken([double factor = 0.1]) {
    final hslColor = HSLColor.fromColor(this);
    final darkenedColor =
        hslColor.withLightness((hslColor.lightness - factor).clamp(0.0, 1.0));
    return darkenedColor.toColor();
  }
}
