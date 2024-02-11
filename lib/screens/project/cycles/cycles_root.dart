// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/constants/cycles.contant.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/loading_widget.dart';
import 'active-cycle/cycle_active_card.dart';
import 'widgets/cycles_list.dart';

class CyclesRoot extends ConsumerStatefulWidget {
  const CyclesRoot({super.key});

  @override
  ConsumerState<CyclesRoot> createState() => _CyclesRootState();
}

class _CyclesRootState extends ConsumerState<CyclesRoot> {
  final TABS = ['All', 'Active', 'Upcoming', 'Completed', 'Draft'];
  int selectedTab = 0;
  bool isFetchingActiveCycle = false;

  void onTabClick(int index) {
    setState(() => selectedTab = index);
    final cyclesState = ref.read(ProviderList.cycleProvider);
    if (index == 1 && cyclesState.cycles[CycleType.active] == null) {
      final cycleNotifier = ref.read(ProviderList.cycleProvider.notifier);
      setState(() => isFetchingActiveCycle = true);
      cycleNotifier.fetchActiveCycle().whenComplete(() {
        setState(() => isFetchingActiveCycle = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
    final activeCycle = ref.watch(ProviderList.cycleProvider
        .select((value) => value.cycles[CycleType.active]?.values.first));
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 15, 15, 15),
          height: 45,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: TABS.length,
              itemBuilder: (ctx, index) => GestureDetector(
                    onTap: () => onTabClick(index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: selectedTab == index
                                  ? Colors.blueAccent
                                  : themeManager.borderSubtle01Color),
                          color: selectedTab == index
                              ? themeManager.primaryColour
                              : themeManager.primaryBackgroundDefaultColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: CustomText(
                            TABS[index],
                            height: 1,
                            color: selectedTab == index
                                ? Colors.white
                                : themeManager.primaryTextColor,
                            type: FontStyle.Small,
                            overrride: true,
                          ),
                        ),
                      ),
                    ),
                  )),
        ),
        Expanded(
            child: stringToCycleType(TABS[selectedTab]) == CycleType.active
                ? LoadingWidget(
                    loading: isFetchingActiveCycle || activeCycle == null,
                    widgetClass: activeCycle == null
                        ? Container()
                        : CycleActiveCard(activeCycle: activeCycle),
                  )
                : CyclesList(
                    type: stringToCycleType(TABS[selectedTab]),
                  ))
      ],
    );
  }
}
