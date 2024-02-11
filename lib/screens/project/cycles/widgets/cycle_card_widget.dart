import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plane/bottom-sheets/delete-leave-sheets/delete_cycle_sheet.dart';
import 'package:plane/models/cycle/cycle_detail.model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/project/cycles/widgets/cycle_status.dart';
import 'package:plane/utils/bottom_sheet.helper.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

// ignore: must_be_immutable
class CycleCardWidget extends ConsumerStatefulWidget {
  const CycleCardWidget(this.cycle, {super.key});
  final CycleDetailModel cycle;

  @override
  ConsumerState<CycleCardWidget> createState() => _CycleCardWidgetState();
}

class _CycleCardWidgetState extends ConsumerState<CycleCardWidget> {
  Future<void> handleCycleFavorite() async {
    final cycleNotifier = ref.read(ProviderList.cycleProvider.notifier);
    cycleNotifier.updateCycle(
        widget.cycle.copyWith(is_favorite: !widget.cycle.is_favorite));
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ref.watch(ProviderList.themeProvider).themeManager;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 35,
                child: SvgPicture.asset(
                  'assets/svg_images/cycles_icon.svg',
                  height: 25,
                  width: 25,
                  colorFilter: ColorFilter.mode(
                      widget.cycle.status == 'DRAFT'
                          ? themeManager.placeholderTextColor
                          : widget.cycle.status == 'COMPLETED'
                              ? themeManager.primaryColour
                              : themeManager.textSuccessColor,
                      BlendMode.srcIn),
                )),
            SizedBox(
              width: width * 0.6,
              child: CustomText(
                widget.cycle.name,
                maxLines: 1,
                type: FontStyle.Medium,
                fontWeight: FontWeightt.Medium,
              ),
            ),
            const Spacer(),
            SizedBox(
                child: InkWell(
              onTap: handleCycleFavorite,
              child: Icon(
                size: 20,
                widget.cycle.is_favorite ? Icons.star : Icons.star_border,
                color: themeManager.tertiaryTextColor,
              ),
            )),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                BottomSheetHelper.showBottomSheet(
                    context, DeleteCycleSheet(cycle: widget.cycle));
              },
              child: Container(
                alignment: Alignment.center,
                child: Icon(
                  LucideIcons.trash2,
                  color: themeManager.textErrorColor,
                  size: 18,
                ),
              ),
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 30,top: 10),
          child: CycleStatus(cycle: widget.cycle),
        ),
      ],
    );
  }
}
