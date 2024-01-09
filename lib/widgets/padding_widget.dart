import 'package:flutter/material.dart';

Widget horizontalPaddingWidget({required Widget child}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: child,
  );
}
