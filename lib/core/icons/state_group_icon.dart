import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget stateGroupIcon(String? group) {
  switch (group) {
    case 'backlog':
      return SvgPicture.asset(
        'assets/svg_images/circle.svg',
        height: 22,
        width: 22,
        colorFilter: ColorFilter.mode(
            Color(int.parse("FF${"#A3A3A3".replaceAll('#', '')}", radix: 16)),
            BlendMode.srcIn),
      );
    case 'unstarted':
      return SvgPicture.asset(
        'assets/svg_images/unstarted.svg',
        height: 22,
        width: 22,
        colorFilter: ColorFilter.mode(
            Color(int.parse("FF${"#3A3A3A".replaceAll('#', '')}", radix: 16)),
            BlendMode.srcIn),
      );
    case 'started':
      return SvgPicture.asset(
        'assets/svg_images/in_progress.svg',
        height: 22,
        width: 22,
        colorFilter: ColorFilter.mode(
            Color(int.parse("FF${"#F59E0B".replaceAll('#', '')}", radix: 16)),
            BlendMode.srcIn),
      );
    case 'completed':
      return SvgPicture.asset(
        'assets/svg_images/done.svg',
        height: 22,
        width: 22,
        colorFilter: ColorFilter.mode(
            Color(int.parse("FF${"#16A34A".replaceAll('#', '')}", radix: 16)),
            BlendMode.srcIn),
      );

    case 'cancelled':
      return SvgPicture.asset(
        'assets/svg_images/cancelled.svg',
        height: 22,
        width: 22,
        colorFilter: ColorFilter.mode(
            Color(int.parse("FF${"#DC2626".replaceAll('#', '')}", radix: 16)),
            BlendMode.srcIn),
      );
    default:
      return SvgPicture.asset(
        'assets/svg_images/circle.svg',
        height: 22,
        width: 22,
        colorFilter: ColorFilter.mode(
            Color(int.parse("FF${"#A3A3A3".replaceAll('#', '')}", radix: 16)),
            BlendMode.srcIn),
      );
  }
}
