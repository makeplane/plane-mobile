// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/models/project_detail_models.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class ProjectDetailTabs extends ConsumerWidget {
  const ProjectDetailTabs(
      {required this.TABS,
      required this.selectedTab,
      required this.onTabChange,
      super.key});
  final List<ProjectDetailTab> TABS;
  final int selectedTab;
  final void Function(int) onTabChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: TABS.map((tab) {
        final tabIndex = TABS.indexOf(tab);
        return tab.show
            ? Expanded(
                child: InkWell(
                  onTap: () {
                    onTabChange(tabIndex);
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: CustomText(
                          tab.title,
                          color: tabIndex == selectedTab
                              ? themeProvider.themeManager.primaryColour
                              : themeProvider.themeManager.placeholderTextColor,
                          overrride: true,
                          type: FontStyle.Medium,
                          fontWeight: tabIndex == selectedTab
                              ? FontWeightt.Medium
                              : null,
                        ),
                      ),
                      selectedTab == TABS.indexOf(tab) &&
                              TABS.elementAt(tabIndex).show
                          ? Container(
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: themeProvider.themeManager.primaryColour,
                              ),
                            )
                          : Container(
                              height: 6,
                            )
                    ],
                  ),
                ),
              )
            : Container();
      }).toList(),
    );
  }
}
