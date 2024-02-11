// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
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
  int selectedMonth = 0;

  @override
  void initState() {
    super.initState();
    selectedMonth = ref
            .read(ProviderList.dashboardProvider)
            .selectedMonthForissuesClosedByMonthWidget -
        1; // Month start from 1. but in list view index its start from 0
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = ref.watch(ProviderList.dashboardProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      padding: const EdgeInsets.only(top: 25),
      decoration: BoxDecoration(
        color: themeProvider.themeManager.primaryBackgroundDefaultColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Material(
        color: themeProvider.themeManager.primaryBackgroundDefaultColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
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
                      color: themeProvider.themeManager.placeholderTextColor,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(bottom: bottomSheetConstBottomPadding),
                separatorBuilder: (context, index) => CustomDivider(),
                itemCount: monthList.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    selectedMonth = index;
                    await dashboardProvider.getIssuesClosedByMonth(index + 1);
                    if (dashboardProvider.getIssuesClosedThisMonthState ==
                        DataState.error) {
                      CustomToast.showToast(context,
                          message: 'Something went wrong!',
                          toastType: ToastType.failure);
                    } else {
                      if (context.mounted) Navigator.maybePop(context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          monthList[index],
                          type: FontStyle.H6,
                        ),
                        index == selectedMonth
                            ? const Icon(
                                Icons.done,
                                color: Color.fromRGBO(9, 169, 83, 1),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
