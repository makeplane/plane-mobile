import 'package:flutter/material.dart';

class BottomSheetHelper {
  static void showBottomSheet(
    BuildContext context,
    Widget child, {
    BoxConstraints? constraints,
    Color? barrierColor,
    ShapeBorder? shape,
    bool? isScrollControlled = false,
    bool? isDismissible = true,
    bool? enableDrag = true,
  }) {
    showModalBottomSheet(
        constraints: constraints ??
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
        shape: shape ??
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
        isScrollControlled: isScrollControlled ?? false,
        isDismissible: isDismissible ?? true,
        enableDrag: enableDrag ?? true,
        context: context,
        builder: (BuildContext context) {
          return child;
        });
  }
}
