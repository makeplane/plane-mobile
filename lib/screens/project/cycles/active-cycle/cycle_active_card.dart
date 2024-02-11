import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane/constants/cycles.contant.dart';
import 'package:plane/core/components/cycle_module_widgets/index.dart';
import 'package:plane/models/cycle/cycle_detail.model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_divider.dart';
import 'package:plane/widgets/custom_text.dart';
import '/utils/enums.dart';
import '../widgets/cycle_status.dart';
import 'widgets/detail_section.dart';

class CycleActiveCard extends ConsumerStatefulWidget {
  const CycleActiveCard({required this.activeCycle, super.key});
  final CycleDetailModel activeCycle;

  @override
  ConsumerState<CycleActiveCard> createState() => _CycleActiveCardState();
}

class _CycleActiveCardState extends ConsumerState<CycleActiveCard> {
  void handleFavorite() {
    final cycleNotifier = ref.read(ProviderList.cycleProvider.notifier);
    cycleNotifier.updateCycle(widget.activeCycle
        .copyWith(is_favorite: !widget.activeCycle.is_favorite));
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ref.watch(ProviderList.themeProvider).themeManager;
    final activeCycle = ref
        .watch(ProviderList.cycleProvider)
        .cycles[CycleType.active]!
        .values
        .first;
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
        decoration: BoxDecoration(
            color: themeManager.secondaryBackgroundDefaultColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: themeManager.borderSubtle01Color,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // card header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: SvgPicture.asset(
                            'assets/svg_images/cycles_icon.svg',
                            height: 25,
                            width: 25,
                            colorFilter: ColorFilter.mode(
                                themeManager.textSuccessColor, BlendMode.srcIn)),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: CustomText(
                          activeCycle.name,
                          maxLines: 1,
                          type: FontStyle.Large,
                          fontWeight: FontWeightt.Medium,
                        ),
                      ),
                      InkWell(
                          onTap: handleFavorite,
                          child: activeCycle.is_favorite == true
                              ? Icon(Icons.star,
                                  color: themeManager.tertiaryTextColor)
                              : Icon(
                                  Icons.star_outline,
                                  color: themeManager.placeholderTextColor,
                                )),
                    ],
                  ),
                  const SizedBox(height: 15),
                  CycleStatus(cycle: activeCycle)
                ],
              ),
            ),
            ACycleCardDetailSection(activeCycle: activeCycle),
            CustomDivider(
              color: themeManager.borderSubtle01Color,
            ),
            ACycleCardProgressSection(activeCycle: activeCycle),
            CustomDivider(
              color: themeManager.borderSubtle01Color,
            ),
            ACycleCardAssigneesSection(activeCycle: activeCycle),
            CustomDivider(
              color: themeManager.borderSubtle01Color,
            ),
            ACycleCardLabelsSection(activeCycle: activeCycle),
            CustomDivider(
              color: themeManager.borderSubtle01Color,
            ),
            ACycleCardPendingIssuesChart(activeCycle: activeCycle),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
