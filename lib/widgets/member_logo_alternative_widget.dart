import 'package:flutter/material.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class MemeberLogoAlternativeWidget extends StatelessWidget {
  const MemeberLogoAlternativeWidget(this.imageUrl, this.color, {super.key});
  final String imageUrl;
  final Color color;
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
