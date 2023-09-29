import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plane/bottom_sheets/delete_cycle_sheet.dart';
import 'package:plane/provider/cycles_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/provider/theme_provider.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

// ignore: must_be_immutable
class CycleCardWidget extends ConsumerStatefulWidget {
  CycleCardWidget({required this.cycleData, super.key});
  Map<String, dynamic> cycleData;

  @override
  ConsumerState<CycleCardWidget> createState() => _CycleCardWidgetState();
}

class _CycleCardWidgetState extends ConsumerState<CycleCardWidget> {
  late String cycleId;
  late String cycleName;
  late bool isFavorite;
  String? startDate;
  String? endDate;

  @override
  Widget build(BuildContext context) {
    cycleId = widget.cycleData['id'];
    cycleName = widget.cycleData['name'];
    isFavorite = widget.cycleData['is_favorite'];
    startDate = widget.cycleData['start_date'];
    endDate = widget.cycleData['end_date'];
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 35, child: cycleIcon(themeProvider)),
            cycleNameText(),
            const Spacer(),
            favoritingButton(cyclesProvider, themeProvider),
            const SizedBox(width: 10),
            deleteButton(context, themeProvider),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(width: 35),
            cycleType(themeProvider),
          ],
        ),
      ],
    );
  }

  InkWell deleteButton(BuildContext context, ThemeProvider themeProvider) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          enableDrag: true,
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.50),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          context: context,
          builder: (ctx) {
            return DeleteCycleSheet(
              id: cycleId,
              name: cycleName,
              type: 'Cycle',
            );
          },
        );
      },
      child: Container(
        height: 25,
        alignment: Alignment.center,
        child: Icon(
          LucideIcons.trash2,
          color: themeProvider.themeManager.textErrorColor,
          size: 20,
        ),
      ),
    );
  }

  SizedBox favoritingButton(
      CyclesProvider cyclesProvider, ThemeProvider themeProvider) {
    return SizedBox(
      child: cyclesProvider.loadingCycleId.contains(cycleId)
          ? SizedBox(
              width: 25,
              height: 25,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(2),
                child: CircularProgressIndicator(
                  color: themeProvider.themeManager.placeholderTextColor,
                  strokeWidth: 2,
                ),
              )),
            )
          : isFavorite
              ? InkWell(
                  onTap: () {
                    cyclesProvider.updateCycle(
                        method: CRUD.update,
                        disableLoading: true,
                        slug: ref
                            .read(ProviderList.workspaceProvider)
                            .selectedWorkspace
                            .workspaceSlug,
                        projectId: ref
                            .read(ProviderList.projectProvider)
                            .currentProject['id'],
                        cycleId: cycleId,
                        isFavorite: true,
                        query: 'all',
                        data: {
                          'cycle': cycleId,
                        },
                        ref: ref);
                  },
                  child: Icon(
                    size: 25,
                    Icons.star,
                    color: themeProvider.themeManager.tertiaryTextColor,
                  ),
                )
              : InkWell(
                  onTap: () {
                    cyclesProvider.updateCycle(
                        method: CRUD.update,
                        disableLoading: true,
                        slug: ref
                            .read(ProviderList.workspaceProvider)
                            .selectedWorkspace
                            .workspaceSlug,
                        projectId: ref
                            .read(ProviderList.projectProvider)
                            .currentProject['id'],
                        cycleId: cycleId,
                        isFavorite: false,
                        query: 'all',
                        data: {
                          'cycle': cycleId,
                        },
                        ref: ref);
                  },
                  child: Icon(
                    size: 25,
                    Icons.star_border,
                    color: themeProvider.themeManager.tertiaryTextColor,
                  ),
                ),
    );
  }

  SizedBox cycleNameText() {
    return SizedBox(
      width: width * 0.6,
      child: CustomText(
        cycleName,
        maxLines: 2,
        type: FontStyle.H6,
        fontWeight: FontWeightt.Medium,
      ),
    );
  }

  SizedBox cycleType(ThemeProvider themeProvider) {
    return SizedBox(
      child: startDate == null || endDate == null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color:
                    themeProvider.themeManager.tertiaryBackgroundDefaultColor,
              ),
              child: const CustomText('Draft'),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: checkDate(startDate: startDate, endDate: endDate) ==
                          'Completed'
                      ? themeProvider
                          .themeManager.secondaryBackgroundActiveColor
                      : themeProvider.themeManager.successBackgroundColor,
                  borderRadius: BorderRadius.circular(5)),
              child: CustomText(
                checkDate(
                  startDate: startDate,
                  endDate: endDate,
                ),
                color: checkDate(
                          startDate: startDate,
                          endDate: endDate,
                        ) ==
                        'Draft'
                    ? themeProvider.themeManager.tertiaryTextColor
                    : checkDate(
                              startDate: startDate,
                              endDate: endDate,
                            ) ==
                            'Completed'
                        ? themeProvider.themeManager.primaryColour
                        : themeProvider.themeManager.textSuccessColor,
              ),
            ),
    );
  }

  SvgPicture cycleIcon(ThemeProvider themeProvider) {
    return SvgPicture.asset(
      'assets/svg_images/cycles_icon.svg',
      height: 25,
      width: 25,
      colorFilter: ColorFilter.mode(
          checkDate(
                    startDate: startDate,
                    endDate: endDate,
                  ) ==
                  'Draft'
              ? themeProvider.themeManager.placeholderTextColor
              : checkDate(
                        startDate: startDate,
                        endDate: endDate,
                      ) ==
                      'Completed'
                  ? themeProvider.themeManager.primaryColour
                  : themeProvider.themeManager.textSuccessColor,
          BlendMode.srcIn),
    );
  }

  String checkDate({String? startDate, String? endDate}) {
    final DateTime now = DateTime.now();
    if ((startDate == null) || (endDate == null)) {
      return 'Draft';
    } else {
      if (DateTime.parse(startDate).isAfter(now)) {
        final Duration difference = DateTime.parse(startDate).difference(now);
        if (difference.inDays == 0) {
          return 'Today';
        } else {
          return '${difference.inDays.abs() + 1} Days Left';
        }
      }
      if (DateTime.parse(startDate).isBefore(now) &&
          DateTime.parse(endDate).isAfter(now)) {
        final Duration difference = DateTime.parse(endDate).difference(now);
        if (difference.inDays == 0) {
          return 'Today';
        } else {
          return '${difference.inDays.abs() + 1} Days Left';
        }
      } else {
        return 'Completed';
      }
    }
  }
}
