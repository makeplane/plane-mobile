import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';

import '../utils/enums.dart';

class SnoozeTimeSheet extends ConsumerStatefulWidget {
  const SnoozeTimeSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SnoozeTimeSheetState();
}

class _SnoozeTimeSheetState extends ConsumerState<SnoozeTimeSheet> {
  @override
  Widget build(BuildContext context) {
    var notificationProvider = ref.watch(ProviderList.notificationProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 23, left: 23, right: 23),
      child: Wrap(
        children: [
          Row(
            children: [
              const CustomText(
                'Snooze until...',
                type: FontStyle.H6,
                fontWeight: FontWeightt.Semibold,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  //add 1 day to date time now
                  notificationProvider.snoozedDate = null;

                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  size: 27,
                  color: themeProvider.themeManager.placeholderTextColor,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                notificationProvider.snoozedDate = DateTime.now().add(
                  const Duration(days: 1),
                );
                Navigator.pop(context);
              },
              child: const CustomText(
                '1 day',
                type: FontStyle.Small,
              ),
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Container(
              color: themeProvider.themeManager.borderSubtle01Color,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                notificationProvider.snoozedDate = DateTime.now().add(
                  const Duration(days: 2),
                );
                Navigator.pop(context);
              },
              child: const CustomText(
                '2 days',
                type: FontStyle.Small,
              ),
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Container(
              color: themeProvider.themeManager.borderSubtle01Color,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                notificationProvider.snoozedDate = DateTime.now().add(
                  const Duration(days: 5),
                );
                Navigator.pop(context);
              },
              child: const CustomText(
                '5 days',
                type: FontStyle.Small,
              ),
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Container(
              color: themeProvider.themeManager.borderSubtle01Color,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                notificationProvider.snoozedDate = DateTime.now().add(
                  const Duration(days: 7),
                );
                Navigator.pop(context);
              },
              child: const CustomText(
                '1 week',
                type: FontStyle.Small,
              ),
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Container(
              color: themeProvider.themeManager.borderSubtle01Color,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                notificationProvider.snoozedDate = DateTime.now().add(
                  const Duration(days: 14),
                );
                Navigator.pop(context);
              },
              child: const CustomText(
                '2 weeks',
                type: FontStyle.Small,
              ),
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Container(
              color: themeProvider.themeManager.borderSubtle01Color,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () async {
                //show date time picker
                var date = await showDatePicker(
                  builder: (context, child) => Theme(
                    data: themeProvider.themeManager.datePickerThemeData,
                    child: child!,
                  ),
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2025),
                );

                notificationProvider.snoozedDate = date;
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const CustomText(
                'Custom',
                type: FontStyle.Small,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
