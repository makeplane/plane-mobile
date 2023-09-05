import 'package:flutter/material.dart';
import 'package:plane_startup/utils/color_manager.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class MemeberLogoAlternativeWidget extends StatelessWidget {
  MemeberLogoAlternativeWidget(this.imageUrl, this.color, {super.key});
  String imageUrl;
  Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
      child: Center(
        child: CustomText(
          imageUrl.toString().toUpperCase(),
          color: Colors.white,
          type: FontStyle.Medium,
          fontWeight: FontWeightt.Semibold,
        ),
      ),
    );
  }
}
