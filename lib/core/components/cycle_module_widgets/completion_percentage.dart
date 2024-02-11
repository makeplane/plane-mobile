import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class CompletionPercentage extends StatefulWidget {
  const CompletionPercentage(
      {super.key, required this.value, required this.totalValue});

  final int? value;
  final int? totalValue;

  @override
  State<CompletionPercentage> createState() => _CompletionPercentageState();
}

class _CompletionPercentageState extends State<CompletionPercentage> {
  Widget completionPercentageWidget(int? value, int? totalValue) {
    double? completionPercentage;
    if (value == null || totalValue == null) {
      completionPercentage = null;
    } else if (totalValue == 0) {
      completionPercentage = 0;
    } else {
      completionPercentage = ((value * 100) / totalValue);
    }
    return Row(
      children: [
        CircularPercentIndicator(
            radius: 10,
            lineWidth: 2,
            progressColor: primaryColor,
            percent:
                completionPercentage == null ? 0 : completionPercentage / 100),
        const SizedBox(width: 8),
        CustomText(
          completionPercentage == null
              ? 'error'
              : '${completionPercentage.toString().split('.').first}% of $totalValue',
              type: FontStyle.Small,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return completionPercentageWidget(widget.value, widget.totalValue);
  }
}
