import 'package:flutter/material.dart';

class BottomSheetHelper {
  static void showBottomSheet(
    BuildContext context,
    Widget child, {
    BoxConstraints? constraints,
    Color? barrierColor,
    ShapeBorder? shape,
    bool? isScrollControlled = true,
    bool? isDismissible = true,
    bool? enableDrag = true,
  }) {
    showModalBottomSheet(
        constraints: constraints ??
            BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.8),
        shape: shape ??
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
        isScrollControlled: isScrollControlled ?? true,
        isDismissible: isDismissible ?? true,
        enableDrag: enableDrag ?? true,
        context: context,
        builder: (BuildContext context) {
          return child;
        });
  }
}
