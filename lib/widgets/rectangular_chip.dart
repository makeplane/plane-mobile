import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';

import 'custom_text.dart';

class RectangularChip extends StatelessWidget {
  const RectangularChip(
      {required this.ref,
      required this.icon,
      required this.text,
      this.color,
      required this.selected,
      super.key});
  final WidgetRef ref;
  final Widget icon;
  final String text;
  final Color? color;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.read(ProviderList.themeProvider);
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //set max width to 150
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          blurRadius: 0.6,
          color: themeProvider.themeManager.borderSubtle01Color,
          spreadRadius: 0,
        )
      ], borderRadius: BorderRadius.circular(5), color: color),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 5),
          Container(
            constraints: const BoxConstraints(maxWidth: 200),
            child: CustomText(
              text.isNotEmpty
                  ? text.replaceFirst(text[0], text[0].toUpperCase())
                  : text,
              color: selected
                  ? Colors.white
                  : themeProvider.themeManager.secondaryTextColor,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}
