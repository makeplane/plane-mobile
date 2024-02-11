import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/core/components/issues/issue-card/issue_card_root.dart';
import 'package:plane/kanban/models/inputs.dart';
import 'package:plane/models/project/issue/issue_model.dart';
import 'package:plane/provider/issues/base-classes/base_issues_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/issues/issues_group_title_leading.dart';
import 'package:plane/utils/theme_manager.dart';
import 'package:plane/widgets/custom_text.dart';

class KanbanBoardHelper {
  Ref ref;
  Map<String, List<IssueModel>> issues;
  GroupBY groupBY;
  OrderBY orderBY;
  late ThemeManager themeManager;
  ABaseIssuesProvider issuesProvider;

  KanbanBoardHelper({
    required this.ref,
    required this.issuesProvider,
    required this.issues,
    required this.groupBY,
    required this.orderBY,
  }) {
    themeManager = ref.read(ProviderList.themeProvider).themeManager;
  }

  List<BoardListsData> organizeBoardIssues() {
    return _initializeBoard(issues);
  }

  static bool isCardDragable(
      {required GroupBY groupBY, required Role memberRole}) {
    return (groupBY == GroupBY.state || groupBY == GroupBY.priority) &&
        (memberRole == Role.admin || memberRole == Role.member);
  }

  static Future<void> reorderIssue(
      {required int newCardIndex,
      required int oldCardIndex,
      required int newListIndex,
      required int oldListIndex,
      required GroupBY groupBY,
      required OrderBY orderBY,
      required BuildContext context,
      required Map<String, List<IssueModel>> currentLayoutIssues,
      required ABaseIssuesProvider issuesProvider}) async {
    final newListID = currentLayoutIssues.keys.elementAt(newListIndex);
    final oldListID = currentLayoutIssues.keys.elementAt(oldListIndex);
    final draggedIssue = currentLayoutIssues[oldListID]![oldCardIndex];

    /// if [oldListIndex] and [newListIndex] are same then no need to update
    if (oldListIndex == newListIndex) {
      return;
    }

    /// update issue position in the current layout
    currentLayoutIssues[newListID]!.insert(
        newCardIndex, currentLayoutIssues[oldListID]!.removeAt(oldCardIndex));
    late IssueModel issuePayload;
    if (groupBY == GroupBY.state) {
      issuePayload = draggedIssue.copyWith(state_id: newListID);
    } else if (groupBY == GroupBY.priority) {
      issuePayload = draggedIssue.copyWith(priority: newListID);
    }

    /// update the issue in the backend
    final response = await issuesProvider.updateIssue(issuePayload);

    response.fold((err) {
      /// if update fails then revert the changes
      (currentLayoutIssues[oldListID] as List).insert(
          oldCardIndex, currentLayoutIssues[newListID]!.removeAt(newCardIndex));
      issuesProvider.updateCurrentLayoutIssues(currentLayoutIssues);

      /// show error toast
      CustomToast.showToast(context,
          message: 'Failed to update issue', toastType: ToastType.failure);
    }, (updatedIssue) {
      currentLayoutIssues[newListID]![newCardIndex] = updatedIssue;

      /// sort the issues based on the order_by property
      if (orderBY != OrderBY.manual) {
        currentLayoutIssues[newListID]!.sort((a, b) {
          if (orderBY == OrderBY.priority) {
            return priorityParser(a.priority)
                .compareTo(priorityParser(b.priority));
          } else if (orderBY == OrderBY.lastCreated) {
            return DateTime.parse(b.created_at)
                .compareTo(DateTime.parse(a.created_at));
          } else if (orderBY == OrderBY.lastUpdated) {
            return DateTime.parse(a.updated_at)
                .compareTo(DateTime.parse(b.updated_at));
          } else {
            return 0;
          }
        });
      }

      /// update the current layout issues
      issuesProvider.updateCurrentLayoutIssues(currentLayoutIssues);
    });
  }

  List<BoardListsData> _initializeBoard(Map<String, List<IssueModel>> issues) {
    List<BoardListsData> boardGroups = [];
    for (final issueGroup in issues.keys) {
      List<Widget> groupCards = [];
      final groupID = issueGroup;
      for (final issue in issues[issueGroup]!) {
        groupCards.add(
          IssueCard(
            issue: issue,
            issuesProvider: issuesProvider,
          ),
        );
      }
      final leadingIcon = getIssueGroupLeadingIcon(
          groupID: groupID, groupBY: groupBY, ref: ref);
      final groupTitle =
          getIssuesGroupTitle(groupID: groupID, groupBY: groupBY, ref: ref);
      boardGroups.add(BoardListsData(
        title: groupTitle,
        leading: leadingIcon,
        id: groupID,
        items: groupCards,
        index: issues.keys.toList().indexOf(issueGroup),
        header: _getListHeader(
            leadingIcon: leadingIcon,
            listLength: groupCards.length,
            title: groupTitle),
        backgroundColor: themeManager.secondaryBackgroundDefaultColor,
      ));
    }
    return boardGroups;
  }

  Widget _getListHeader({
    required Widget leadingIcon,
    required int listLength,
    required String title,
  }) {
    return SizedBox(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leadingIcon,
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            child: CustomText(
              title,
              type: FontStyle.Large,
              fontWeight: FontWeightt.Semibold,
              textAlign: TextAlign.start,
              fontSize: 20,
              maxLines: 1,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
              left: 15,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: themeManager.tertiaryBackgroundDefaultColor),
            height: 25,
            width: 35,
            child: CustomText(
              listLength.toString(),
              type: FontStyle.Small,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.zoom_in_map,
              color: themeManager.placeholderTextColor,
              size: 20,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          ref.read(ProviderList.projectProvider).role == Role.admin ||
                  ref.read(ProviderList.projectProvider).role == Role.member
              ? GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     Const.globalKey.currentContext!,
                    //     MaterialPageRoute(
                    //         builder: (ctx) => const CreateIssue()));
                  },
                  child: Icon(
                    Icons.add,
                    color: themeManager.placeholderTextColor,
                  ))
              : Container(),
        ],
      ),
    );
  }
}
