import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:plane/models/cycle/cycle_detail.model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/project/cycles/cycle-detail/cycle_detail.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/member_logo_widget.dart';
import 'package:plane/widgets/profile_circle_avatar_widget.dart';

class ACycleCardDetailSection extends ConsumerStatefulWidget {
  const ACycleCardDetailSection({required this.activeCycle, super.key});
  final CycleDetailModel activeCycle;
  @override
  ConsumerState<ACycleCardDetailSection> createState() =>
      _ACycleCardDetailSectionState();
}

class _ACycleCardDetailSectionState
    extends ConsumerState<ACycleCardDetailSection> {
  void viewCycleDetail() {
    //TODO: set current cycle
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CycleDetail(
                  cycleId: widget.activeCycle.id,
                )));
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
    final ownedBy = ref
        .read(ProviderList.workspaceProvider)
        .workspaceMembers
        .where(
            (member) => member['member']['id'] == widget.activeCycle.owned_by)
        .first['member'];

    return Container(
      color: themeManager.primaryBackgroundDefaultColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: themeManager.placeholderTextColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        CustomText(
                          DateFormat("MMM d, yyyy").format(DateTime.parse(
                            widget.activeCycle.start_date!,
                          )),
                          type: FontStyle.Small,
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          CupertinoIcons.arrow_right,
                          size: 18,
                          color: themeManager.placeholderTextColor,
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ownedBy['avatar'].toString().isNotEmpty
                              ? CircleAvatar(
                                  radius: 10,
                                  child: MemberLogoWidget(
                                    size: 20,
                                    padding: EdgeInsets.zero,
                                    boarderRadius: 100,
                                    imageUrl: ownedBy['avatar'],
                                    colorForErrorWidget: themeManager
                                        .tertiaryBackgroundDefaultColor,
                                    memberNameFirstLetterForErrorWidget:
                                        ownedBy['first_name'][0].toUpperCase(),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.amber,
                                  child: CustomText(
                                    ownedBy['first_name'][0].toUpperCase(),
                                    type: FontStyle.Small,
                                    height: 1,
                                    color: Colors.white,
                                  ),
                                ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: width * 0.3,
                            child: CustomText(
                              ownedBy['display_name'],
                              type: FontStyle.Medium,
                              maxLines: 1,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset('assets/svg_images/issues_icon.svg',
                            height: 18,
                            width: 18,
                            colorFilter: const ColorFilter.mode(
                                greyColor, BlendMode.srcIn)),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          widget.activeCycle.total_issues.toString(),
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: themeManager.placeholderTextColor,
                        ),
                        const SizedBox(width: 5),
                        CustomText(
                          DateFormat("MMM d, yyyy").format(DateTime.parse(
                            widget.activeCycle.end_date!,
                          )),
                          type: FontStyle.Small,
                        ),
                      ],
                    ),
                    widget.activeCycle.assignees.isNotEmpty
                        ? Row(
                            children: [
                              ProfileCircleAvatarsWidget(
                                  details: widget.activeCycle.assignees),
                              const SizedBox(
                                width: 5,
                              ),
                              widget.activeCycle.assignees.length > 3
                                  ? CustomText(
                                      '+ ${widget.activeCycle.assignees.length - 3}',
                                      type: FontStyle.Small,
                                    )
                                  : Container()
                            ],
                          )
                        : Icon(Icons.groups_3_outlined,
                            size: 18, color: themeManager.placeholderTextColor),
                    Row(
                      children: [
                        SvgPicture.asset('assets/svg_images/done.svg',
                            height: 18,
                            width: 18,
                            colorFilter: const ColorFilter.mode(
                                Colors.blue, BlendMode.srcIn)),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          widget.activeCycle.completed_issues.toString(),
                          type: FontStyle.Small,
                          height: 1,
                        ),
                      ],
                    )
                  ],
                ),
                const Flexible(child: SizedBox(width: 8)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: InkWell(
              onTap: viewCycleDetail,
              child: Container(
                padding: const EdgeInsets.only(
                    left: 0, right: 7, top: 0, bottom: 14),
                child: Row(
                  children: [
                    CustomText(
                      'View Cycle',
                      color: themeManager.primaryColour,
                      type: FontStyle.Medium,
                      fontWeight: FontWeightt.Semibold,
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      CupertinoIcons.arrow_right,
                      color: themeManager.primaryColour,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
