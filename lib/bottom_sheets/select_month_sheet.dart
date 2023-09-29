import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_divider.dart';
import 'package:plane/widgets/custom_text.dart';

class SelectMonthSheet extends ConsumerStatefulWidget {
  const SelectMonthSheet({super.key});

  @override
  ConsumerState<SelectMonthSheet> createState() => _SelectMonthSheetState();
}

class _SelectMonthSheetState extends ConsumerState<SelectMonthSheet> {
  List<String> monthList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  @override
  Widget build(BuildContext context) {
    final dashboardProvider = ref.watch(ProviderList.dashboardProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
      decoration: BoxDecoration(
        color: themeProvider.themeManager.primaryBackgroundDefaultColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CustomText(
                'Select Month',
                type: FontStyle.H4,
                fontWeight: FontWeightt.Semibold,
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: themeProvider.themeManager.primaryTextColor,
                  ))
            ],
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) =>
                  CustomDivider(themeProvider: themeProvider),
              itemCount: monthList.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () async {
                  await dashboardProvider.getIssuesClosedByMonth(index + 1);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: CustomText(
                    monthList[index],
                    type: FontStyle.H6,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
