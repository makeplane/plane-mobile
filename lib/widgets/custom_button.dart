import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';

import '../utils/enums.dart';
import 'custom_text.dart';

class Button extends ConsumerStatefulWidget {
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
      this.borderColor,
      super.key});
  final String text;
  final bool filledButton;
  final bool disable;
  final bool removeStroke;
  final VoidCallback? ontap;
  final Color? textColor;
  final double? width;
  final Color? color;
  final Widget? widget;
  final Color? borderColor;

  @override
  ConsumerState<Button> createState() => _ButtonState();
}

class _ButtonState extends ConsumerState<Button> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.ontap,
        child: Container(
          alignment: Alignment.center,
          height: 48,
          width: widget.width ?? MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: widget.filledButton
                ? const Border()
                : widget.removeStroke
                    ? const Border()
                    : Border.all(
                        color: widget.borderColor ??
                            themeProvider.themeManager.borderSubtle01Color),
            borderRadius: BorderRadius.circular(buttonBorderRadiusLarge),
            color: widget.color ??
                ((widget.filledButton && !widget.disable)
                    ? themeProvider.themeManager.primaryColour
                    : widget.disable
                        ? lightGreeyColor
                        : Colors.transparent),
          ),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.widget ?? Container(),
                CustomText(
                  widget.text,
                  type: FontStyle.Medium,
                  color: widget.textColor ??
                      ((widget.filledButton && !widget.disable)
                          ? Colors.white
                          : themeProvider.themeManager.textonColor),
                  overrride: true,
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
