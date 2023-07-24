import 'package:flutter/material.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/text_styles.dart';

class StautsWidget extends StatelessWidget {
  const StautsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5)),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: '⚈',
            style: TextStylingWidget.description
                .copyWith(color: Colors.orange, fontSize: 14)),
        TextSpan(
            text: 'To Do',
            style: TextStylingWidget.description
                .copyWith(color: greyColor, fontSize: 14)),
      ])),
    );
  }
}
