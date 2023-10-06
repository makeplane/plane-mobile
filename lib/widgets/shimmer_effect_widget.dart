import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/extensions/color_extension.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffectWidget extends ConsumerStatefulWidget {
  const ShimmerEffectWidget({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.padding,
    this.margin,
  });
  final double height;
  final double width;
  final double? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  ConsumerState<ShimmerEffectWidget> createState() =>
      _ShimmerEffectWidgetState();
}

class _ShimmerEffectWidgetState extends ConsumerState<ShimmerEffectWidget> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Shimmer.fromColors(
      baseColor: widget.baseColor ??
          themeProvider.themeManager.tertiaryBackgroundDefaultColor
              .darken(0.025),
      highlightColor: widget.highlightColor ??
          themeProvider.themeManager.tertiaryBackgroundDefaultColor
              .lighten(0.025),
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: widget.padding,
        margin: widget.margin,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
            color: themeProvider.themeManager.tertiaryBackgroundDefaultColor),
      ),
    );
  }
}
