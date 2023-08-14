import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plane_startup/utils/constants.dart';

enum ToastType { defult, success, failure }

class CustomToast {
  void showSimpleToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: lightPrimaryBackgroundActiveColor,
      textColor: darkPrimaryTextColor,
      fontSize: 16.0,
    );
  }

  void showToast(BuildContext context, String message,
      {int duration = 2,
      ToastType toastType = ToastType.defult,
      Color? backgroundColor,
      Color? textColor}) {
    FToast fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      decoration: BoxDecoration(
        color: backgroundColor ??
            (toastType == ToastType.defult
                ? lightPrimaryBackgroundActiveColor
                : toastType == ToastType.success
                    ? lightTextSuccessColor
                    : lightPrimaryButtonDangerColor),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          //const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                fToast.removeCustomToast();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
    fToast.showToast(
      child: toast,
      toastDuration: Duration(seconds: duration),
      gravity: ToastGravity.BOTTOM,
    );
  }

  void showToastWithCustomChild(
      BuildContext context, String message, Widget child,
      {int duration = 1}) {
    FToast fToast = FToast();
    fToast.init(context);

    fToast.showToast(
      child: child,
      toastDuration: Duration(seconds: duration),
      gravity: ToastGravity.BOTTOM,
    );
  }
}
