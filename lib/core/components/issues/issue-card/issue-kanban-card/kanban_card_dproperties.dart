import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane/core/components/issues/issue-card/display-properties/assignee_dproperty.dart';
import 'package:plane/core/components/issues/issue-card/display-properties/attachment_count_dproperty.dart';
import 'package:plane/core/components/issues/issue-card/display-properties/due_date_dproperty.dart';
import 'package:plane/core/components/issues/issue-card/display-properties/estimate_dproperty.dart';
import 'package:plane/core/components/issues/issue-card/display-properties/labels_dproperty.dart';
import 'package:plane/core/components/issues/issue-card/display-properties/link_count_dproperty.dart';
import 'package:plane/core/components/issues/issue-card/display-properties/start_date_dproperty.dart';
import 'package:plane/core/icons/priority_icon.dart';
import 'package:plane/models/project/issue-filter-properties-and-view/issue_filter_and_properties.dart';
import 'package:plane/models/project/issue/issue_model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class KanbanCardDProperties extends ConsumerStatefulWidget {
  const KanbanCardDProperties(
      {required this.appliedDProperties, required this.issue, super.key});
  final DisplayPropertiesModel appliedDProperties;
  final IssueModel issue;

  @override
  ConsumerState<KanbanCardDProperties> createState() =>
      _KanbanCardDPropertiesState();
}

class _KanbanCardDPropertiesState extends ConsumerState<KanbanCardDProperties> {
  @override
  Widget build(BuildContext context) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
    final projectProvider = ref.read(ProviderList.projectProvider);
    return Container(
      width: 300,
      height: 55,
      padding: const EdgeInsets.only(bottom: 15, top: 10),
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          widget.appliedDProperties.priority
              ? Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color:
                          widget.issue.priority == 'urgent' ? Colors.red : null,
                      border:
                          Border.all(color: themeManager.borderSubtle01Color),
                      borderRadius: BorderRadius.circular(5)),
                  margin: const EdgeInsets.only(right: 5),
                  height: 30,
                  width: 30,
                  child: priorityIcon(widget.issue.priority))
              : const SizedBox(
                  width: 0,
                ),
          widget.appliedDProperties.assignee
              ? AssigneeDProperty(assignee_ids: widget.issue.assignee_ids)
              : const SizedBox(),
          (widget.appliedDProperties.labels &&
                  widget.issue.label_ids.isNotEmpty)
              ? LabelsDProperty(label_ids: widget.issue.label_ids)
              : Container(),
          widget.appliedDProperties.due_date == true
              ? DueDateDProperties(
                dueDate:widget.issue.target_date ,
              )
              : const SizedBox(),
          widget.appliedDProperties.due_date
              ? StartDateDProperty(
                  startDate: widget.issue.start_date,
              )
              : const SizedBox(),
          widget.appliedDProperties.sub_issue_count
              ? Container(
                  margin: const EdgeInsets.only(right: 5),
                  height: 30,
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: themeManager.borderSubtle01Color,
                      ),
                      borderRadius: BorderRadius.circular(4)),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SvgPicture.asset('assets/svg_images/issues_icon.svg',
                          width: 16,
                          height: 16,
                          colorFilter: ColorFilter.mode(
                              themeManager.tertiaryTextColor, BlendMode.srcIn)),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomText(
                        widget.issue.sub_issues_count.toString(),
                        type: FontStyle.XSmall,
                        height: 1,
                        color: themeManager.tertiaryTextColor,
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          widget.appliedDProperties.link == true
              ? LinkCountDProperty(linkCount: widget.issue.link_count)
              : const SizedBox(),
          widget.appliedDProperties.attachment_count == true
              ? AttachmentCountDProperty(
                  attachmentCount: widget.issue.attachment_count)
              : const SizedBox(),
          (widget.appliedDProperties.estimate &&
                  projectProvider.currentProject['estimate'] != null)
              ? EstimateDProperty(
                  estimate_point: widget.issue.estimate_point
              )
              : const SizedBox(),
        ],
      ),
    );
  }
}
