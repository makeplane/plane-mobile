import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';

import '../utils/enums.dart';
import 'custom_text.dart';

class Button extends ConsumerStatefulWidget {
  final String text;
  final bool filledButton;
  final bool disable;
  final bool removeStroke;
  final VoidCallback? ontap;
  final Color? textColor;
  final double? width;
  final Color? color;
  final Widget? widget;
  const Button(
      {required this.text,
      this.filledButton = true,
      this.ontap,
      this.disable = false,
      this.width,
      this.removeStroke = false,
      this.textColor,
      this.color,
      this.widget,
      super.key});

  @override
  ConsumerState<Button> createState() => _ButtonState();
}

class _ButtonState extends ConsumerState<Button> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.ontap,
        child: Container(
          alignment: Alignment.center,
          height: 48,
          // padding: const EdgeInsets.symmetric(vertical: 16),
          width: widget.width ?? MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: widget.filledButton
                ? const Border()
                : widget.removeStroke
                    ? const Border()
                    : Border.all(color:themeProvider.themeManager.borderSubtle01Color ),
            borderRadius: BorderRadius.circular(8),
            color: widget.color ??
                ((widget.filledButton && !widget.disable)
                    ? primaryColor
                    : widget.disable
                        ? lightGreeyColor
                        : Colors.transparent),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.widget ?? Container(),
                CustomText(
                  widget.text,
                  type: FontStyle.Medium,
                  color: widget.textColor ?? Colors.white,
                  fontWeight: FontWeightt.Semibold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
