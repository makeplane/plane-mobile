import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/extensions/string_extensions.dart';
import 'package:plane/widgets/custom_text.dart';

class SelectIssuePriority extends ConsumerStatefulWidget {
  const SelectIssuePriority({required this.onselectPriority, super.key});
  final Function(String priority) onselectPriority;
  @override
  ConsumerState<SelectIssuePriority> createState() =>
      _SelectIssuePriorityState();
}

class _SelectIssuePriorityState extends ConsumerState<SelectIssuePriority> {
  int selectedPriority = 4;
  String? issueDetailSelectedPriorityItem;
  List priorities = [
    {
      'name': 'Urgent',
      'icon': const Icon(Icons.error_outline_rounded),
      'color': '#EF4444',
    },
    {
      'name': 'High',
      'icon': const Icon(Icons.signal_cellular_alt_outlined),
      'color': '#F59E0B'
    },
    {
      'name': 'Medium',
      'icon': const Icon(Icons.signal_cellular_alt_2_bar_outlined),
      'color': '#F59E0B'
    },
    {
      'name': 'Low',
      'icon': const Icon(Icons.signal_cellular_alt_1_bar_outlined),
      'color': '#22C55E'
    },
    {'name': 'None', 'icon': const Icon(Icons.block), 'color': '#A3A3A3'}
  ];

  @override
  void initState() {
    super.initState();
    // selectedPriority = priorities.indexWhere((element) =>
    //     element['name'] ==
    //     ref.read(ProviderList.issuesProvider).createIssuedata['priority']
    //         ['name']);

    for (int i = 0; i < priorities.length; i++) {
      //change color of all icon according to theme
      priorities[i]['icon'] = Icon(priorities[i]['icon'].icon,
          color: priorities[i]['color'].toString().toColor());
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      padding: bottomSheetConstPadding,
      decoration: BoxDecoration(
        color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      width: double.infinity,
      child: Stack(
        children: [
          Wrap(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    'Select Priority',
                    type: FontStyle.H4,
                    fontWeight: FontWeightt.Semibold,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close,
                          color: themeProvider
                              .themeManager.placeholderTextColor))
                ],
              ),
              Container(
                height: 15,
              ),
              ListView.builder(
                  itemCount: priorities.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        widget.onselectPriority(priorities[index]);
                      },
                      child: Container(
                        //height: 40,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
    
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    //   color: const Color.fromRGBO(55, 65, 81, 1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  alignment: Alignment.center,
                                  child: priorities[index]['icon'] as Widget,
                                ),
                                Container(
                                  width: 10,
                                ),
                                CustomText(
                                    priorities[index]['name'].toString(),
                                    type: FontStyle.Medium,
                                    fontWeight: FontWeightt.Regular,
                                    color: themeProvider
                                        .themeManager.primaryTextColor),
                                const Spacer(),
                                // widget.createIssue
                                //     ? createIssueSelectedPriority(index)
                                //     : issueDetailSelectedPriority(index),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                                height: 1,
                                width: width,
                                color: themeProvider
                                    .themeManager.borderDisabledColor),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget createIssueSelectedPriority(int idx) {
    return selectedPriority == idx
        ? const Icon(
            Icons.done,
            color: Color.fromRGBO(8, 171, 34, 1),
          )
        : const SizedBox();
  }

  Widget issueDetailSelectedPriority(int idx) {
    final issueProvider = ref.watch(ProviderList.issueProvider);
    String? nameOfThisPriority = priorities[idx]['name'].toString().replaceAll(
        priorities[idx]['name'].toString()[0],
        priorities[idx]['name'].toString()[0].toLowerCase());
    if (idx == 4) nameOfThisPriority = null;

    return issueProvider.issueDetails['priority'] == nameOfThisPriority
        ? const Icon(
            Icons.done,
            color: Color.fromRGBO(8, 171, 34, 1),
          )
        : issueProvider.updateIssueState == StateEnum.loading &&
                issueDetailSelectedPriorityItem == priorities[idx]['name']
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: greyColor,
                ),
              )
            : const SizedBox();
  }
}
