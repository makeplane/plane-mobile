import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class CycleDetailTabs extends ConsumerStatefulWidget {
  const CycleDetailTabs(
      {this.cycleName,
      required this.selectedTab,
      required this.pageController,
      required this.onTabChange,
      super.key});
  final PageController pageController;
  final String? cycleName;
  final int selectedTab;
  final Function (int tabIndex) onTabChange;
  @override
  ConsumerState<CycleDetailTabs> createState() => _CycleDetailTabsState();
}

class _CycleDetailTabsState extends ConsumerState<CycleDetailTabs> {
  @override
  Widget build(BuildContext context) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, top: 20),
          child: CustomText(
            widget.cycleName ?? '',
            maxLines: 1,
            type: FontStyle.H5,
            fontWeight: FontWeightt.Semibold,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                  child: InkWell(
                onTap: () {
                  widget.onTabChange(0);
                  widget.pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CustomText(
                        overrride: true,
                        'Issues',
                        type: FontStyle.Large,
                        fontWeight: FontWeightt.Medium,
                        color: widget.selectedTab == 1
                            ? themeManager.placeholderTextColor
                            : themeManager.primaryColour,
                      ),
                    ),
                    Container(
                      height: 7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: widget.selectedTab == 0
                            ? themeManager.primaryColour
                            : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              )),
              Expanded(
                  child: InkWell(
                onTap: () {
                  widget.onTabChange(1);
                  widget.pageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CustomText(
                        'Details',
                        overrride: true,
                        type: FontStyle.Large,
                        fontWeight: FontWeightt.Medium,
                        color: widget.selectedTab == 0
                            ? themeManager.placeholderTextColor
                            : themeManager.primaryColour,
                      ),
                    ),
                    Container(
                      height: 7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: widget.selectedTab == 1
                            ? themeManager.primaryColour
                            : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}
