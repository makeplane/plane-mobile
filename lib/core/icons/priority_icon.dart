// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';

Icon PriorityIcon(String priority) {
  priority = priority.toLowerCase();
  switch (priority) {
    case 'urgent':
      return Icon(
        Icons.error_outline,
        size: 18,
        color:
            Color(int.parse("FF${"#EF4444".replaceAll('#', '')}", radix: 16)),
      );
    case 'high':
      return Icon(
        Icons.signal_cellular_alt,
        size: 18,
        color:
            Color(int.parse("FF${"#F59E0B".replaceAll('#', '')}", radix: 16)),
      );
    case 'medium':
      return Icon(
        Icons.signal_cellular_alt_2_bar,
        color:
            Color(int.parse("FF${"#F59E0B".replaceAll('#', '')}", radix: 16)),
        size: 18,
      );
    case 'low':
      return Icon(
        Icons.signal_cellular_alt_1_bar,
        color:
            Color(int.parse("FF${"#22C55E".replaceAll('#', '')}", radix: 16)),
        size: 18,
      );
    case 'none':
      return Icon(
        Icons.do_disturb_alt_outlined,
        color:
            Color(int.parse("FF${"#A3A3A3".replaceAll('#', '')}", radix: 16)),
        size: 18,
      );
    default:
      return Icon(
        Icons.do_disturb_alt_outlined,
        color:
            Color(int.parse("FF${"#A3A3A3".replaceAll('#', '')}", radix: 16)),
        size: 18,
      );
  }
}
