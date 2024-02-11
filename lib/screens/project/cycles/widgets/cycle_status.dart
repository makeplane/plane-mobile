import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/models/cycle/cycle_detail.model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class CycleStatus extends ConsumerWidget {
  const CycleStatus({required this.cycle, super.key});
  final CycleDetailModel cycle;

  String get checkStatus {
    final DateTime now = DateTime.now();
    if (cycle.start_date == null ||
        cycle.end_date == null ||
        cycle.start_date!.isEmpty ||
        cycle.end_date!.isEmpty) {
      return 'Draft';
    } else {
      if (DateTime.parse(cycle.start_date!).isAfter(now)) {
        final Duration difference =
            DateTime.parse(cycle.start_date!).difference(now);
        if (difference.inDays == 0) {
          return 'Today';
        } else {
          return '${difference.inDays.abs() + 1} Days Left';
        }
      }
      if (DateTime.parse(cycle.start_date!).isBefore(now) &&
          DateTime.parse(cycle.end_date!).isAfter(now)) {
        final Duration difference =
            DateTime.parse(cycle.end_date!).difference(now);
        if (difference.inDays == 0) {
          return 'Today';
        } else {
          return '${difference.inDays.abs() + 1} Days Left';
        }
      } else {
        return 'Completed';
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
    final cycleStatus = checkStatus;
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: cycleStatus == 'Draft'
              ? themeManager.tertiaryBackgroundDefaultColor
              : cycleStatus == 'Completed'
                  ? themeManager.secondaryBackgroundActiveColor
                  : themeManager.successBackgroundColor,
          borderRadius: BorderRadius.circular(2)),
      child: CustomText(
        cycleStatus,
        color: cycleStatus == 'Draft'
            ? themeManager.tertiaryTextColor
            : cycleStatus == 'Completed'
                ? themeManager.primaryColour
                : themeManager.textSuccessColor,
        type: FontStyle.Small,
        height: 1,
      ),
    );
  }
}
