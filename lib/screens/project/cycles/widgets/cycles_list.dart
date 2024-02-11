import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/constants/cycles.contant.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_divider.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/empty.dart';
import 'package:plane/widgets/loading_widget.dart';
import '../index.dart';
import 'cycle_card_widget.dart';

class CyclesList extends ConsumerStatefulWidget {
  const CyclesList({required this.type, super.key});
  final CycleType type;
  @override
  ConsumerState<CyclesList> createState() => _CyclesListState();
}

class _CyclesListState extends ConsumerState<CyclesList> {
  bool isFetchingCycles = false;

  void onCardClick(String cycleId) {
    // Fetch cycleDetail
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CycleDetail(cycleId: cycleId),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant CyclesList oldWidget) {
    final cyclesState = ref.read(ProviderList.cycleProvider);
    if (oldWidget.type != widget.type &&
        cyclesState.cycles[widget.type] == null) {
      final cycleNotifier = ref.read(ProviderList.cycleProvider.notifier);
      setState(() => isFetchingCycles = true);
      cycleNotifier.fetchCycles().whenComplete(() {
        setState(() => isFetchingCycles = false);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
    final cycles = ref.watch(ProviderList.cycleProvider
        .select((value) => value.cycles[widget.type]?.values ?? []));
    final favoriteCycles =
        cycles.where((cycle) => cycle.is_favorite == true).toList();
    final unFavoriteCycles =
        cycles.where((cycle) => !cycle.is_favorite).toList();

    return LoadingWidget(
      loading: isFetchingCycles,
      widgetClass: cycles.isEmpty
          ? EmptyPlaceholder.emptyCycles(context, ref)
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  favoriteCycles.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                              child: CustomText(
                                'Favourite',
                                type: FontStyle.Medium,
                                fontWeight: FontWeightt.Medium,
                                color: themeManager.placeholderTextColor,
                              ),
                            ),
                            ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const CustomDivider(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 15),
                                    ),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                itemCount: favoriteCycles.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () =>
                                          onCardClick(favoriteCycles[index].id),
                                      child: CycleCardWidget(
                                          favoriteCycles[index]));
                                }),
                          ],
                        )
                      : const SizedBox.shrink(),
                  unFavoriteCycles.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            favoriteCycles.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 0, 10),
                                    child: CustomText(
                                      'All Cycles',
                                      type: FontStyle.Medium,
                                      fontWeight: FontWeightt.Medium,
                                      color: themeManager.placeholderTextColor,
                                    ),
                                  )
                                : const SizedBox(
                                    height: 10,
                                  ),
                            ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const CustomDivider(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 15),
                                    ),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                itemCount: unFavoriteCycles.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () => onCardClick(
                                          unFavoriteCycles[index].id),
                                      child: CycleCardWidget(
                                          unFavoriteCycles[index]));
                                }),
                          ],
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }
}
