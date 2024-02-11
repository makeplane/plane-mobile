import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/core/icons/priority_icon.dart';
import 'package:plane/core/icons/state_group_icon.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/core/extensions/string_extensions.dart';
import 'package:plane/widgets/custom_text.dart';

String getIssuesGroupTitle({
  required String groupID,
  required GroupBY groupBY,
  required Ref ref,
}) {
  switch (groupBY) {
    case GroupBY.priority:
      return groupID.capitalize();
    case GroupBY.labels:
      return ref
              .read(ProviderList.labelProvider.notifier)
              .getLabelById(groupID)
              ?.name ??
          'None';
    case GroupBY.assignees:
      return '';
    case GroupBY.createdBY:
      {
        final workspaceMembers =
            ref.read(ProviderList.workspaceProvider.notifier).workspaceMembers;
        final member = workspaceMembers.where(
          (member) => member['member']['id'] == groupID,
        );
        return member.first['member']['display_name'] ?? '';
      }
    case GroupBY.state:
      return ref
              .read(ProviderList.statesProvider.notifier)
              .getStateById(groupID)
              ?.name ??
          '';
    case GroupBY.stateGroups:
      return ref
              .read(ProviderList.statesProvider.notifier)
              .getStateById(groupID)
              ?.name ??
          '';
    default:
      return '';
  }
}

Widget getIssueGroupLeadingIcon({
  required String groupID,
  required GroupBY groupBY,
  required Ref ref,
}) {
  final label =
      ref.read(ProviderList.labelProvider.notifier).getLabelById(groupID);

  return groupBY == GroupBY.priority
      ? PriorityIcon(groupID)
      : groupBY == GroupBY.createdBY || groupBY == GroupBY.assignees
          ? Container(
              height: 22,
              alignment: Alignment.center,
              width: 22,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(55, 65, 81, 1),
              ),
              child: const CustomText(
                'M',
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeightt.Medium,
              ),
            )
          : groupBY == GroupBY.labels
              ? Container(
                  margin: const EdgeInsets.only(top: 3),
                  height: 15,
                  alignment: Alignment.center,
                  width: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          label == null ? Colors.black : label.color.toColor()),
                )
              : groupBY == GroupBY.state
                  ? StateGroupIcon(ref
                      .read(ProviderList.statesProvider.notifier)
                      .getStateById(groupID)
                      ?.group)
                  : groupBY == GroupBY.stateGroups
                      ? StateGroupIcon(groupID)
                      : Container();
}
