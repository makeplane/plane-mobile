import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';

class CustomDivider extends ConsumerWidget {
  const CustomDivider(
      {super.key,
      this.margin = const EdgeInsets.only(top: 0, bottom: 0),
      this.color,
      this.width});
  final EdgeInsets margin;
  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
    return Container(
      margin: margin,
      height: width ?? 1,
      color: color ?? themeManager.borderDisabledColor,
    );
  }
}
