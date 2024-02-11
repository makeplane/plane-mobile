import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/timezone_manager.dart';
import 'package:plane/widgets/custom_divider.dart';
import 'package:plane/widgets/custom_text.dart';

class TimeZoneSelectorSheet extends ConsumerStatefulWidget {
  const TimeZoneSelectorSheet({super.key});

  @override
  ConsumerState<TimeZoneSelectorSheet> createState() =>
      _TimeZoneSelectorSheetState();
}

class _TimeZoneSelectorSheetState extends ConsumerState<TimeZoneSelectorSheet> {
  late List<Map<String, String>> filteredTimeZones;

  @override
  void initState() {
    super.initState();
    filteredTimeZones = TimeZoneManager.timeZones;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomText(
                'Time Zone',
                type: FontStyle.H4,
                fontWeight: FontWeightt.Semibold,
                color: themeProvider.themeManager.primaryTextColor,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
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
          const SizedBox(height: 10),
          TextField(
            decoration: themeProvider.themeManager.textFieldDecoration.copyWith(
                hintText: 'Search for Time Zone...',
                hintStyle: TextStyle(
                    color: themeProvider.themeManager.placeholderTextColor)),
            onChanged: (value) {
              setState(() {
                filteredTimeZones = TimeZoneManager.timeZones
                    .where((element) => element['value']!
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList();
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: bottomSheetConstBottomPadding),
              itemCount: filteredTimeZones.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    profileProvider.selectedTimeZone =
                        filteredTimeZones[index]['value'] ?? 'UTC';
                    profileProvider.setState();
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CustomText(
                      filteredTimeZones[index]['label'] ?? '',
                      type: FontStyle.Small,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const CustomDivider(),
            ),
          ),
        ],
      ),
    );
  }
}
