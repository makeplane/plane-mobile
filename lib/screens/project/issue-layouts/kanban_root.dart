import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/kanban/custom/board.dart';
import 'package:plane/kanban/models/inputs.dart';
import 'package:plane/provider/issues/base-classes/base_issue_state.dart';
import 'package:plane/provider/issues/base-classes/base_issues_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/issues/kanban_board.helper.dart';

class KanbanLayoutRoot extends ConsumerStatefulWidget {
  const KanbanLayoutRoot(
      {required this.issuesState, required this.issuesProvider, super.key});
  final ABaseIssuesProvider issuesProvider;
  final ABaseIssuesState issuesState;
  @override
  ConsumerState<KanbanLayoutRoot> createState() => _KanbanLayoutRootState();
}

class _KanbanLayoutRootState extends ConsumerState<KanbanLayoutRoot> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    return KanbanBoard(
      widget.issuesState.kanbanOrganizedIssues,
      boardID: 'issues-board',
      isCardsDraggable: KanbanBoardHelper.isCardDragable(
          groupBY: widget.issuesProvider.group_by,
          memberRole: projectProvider.role),
      onItemReorder: (
          {newCardIndex, newListIndex, oldCardIndex, oldListIndex}) {
        //  print('newCardIndex: $newCardIndex, newListIndex: $newListIndex, oldCardIndex: $oldCardIndex, oldListIndex: $oldListIndex');
        widget.issuesProvider
            .onDragEnd(
                context: context,
                newCardIndex: newCardIndex!,
                newListIndex: newListIndex!,
                oldCardIndex: oldCardIndex!,
                oldListIndex: oldListIndex!,
                issuesProvider: widget.issuesProvider)
            .then((_) {
          if (widget.issuesProvider.order_by != OrderBY.manual) {
            CustomToast.showToast(context,
                message:
                    'This board is ordered by ${widget.issuesProvider.order_by == OrderBY.lastUpdated ? 'last updated' : 'created at'} ',
                toastType: ToastType.warning);
          }
        }).catchError((e) {
          CustomToast.showToast(context,
              message: 'Failed to update issue', toastType: ToastType.failure);
        });
      },
      groupEmptyStates: !widget.issuesProvider.displayFilters.show_empty_groups,
      backgroundColor:
          themeProvider.themeManager.secondaryBackgroundDefaultColor,
      cardPlaceHolderColor:
          themeProvider.themeManager.primaryBackgroundDefaultColor,
      cardPlaceHolderDecoration: BoxDecoration(
          color: themeProvider.themeManager.primaryBackgroundDefaultColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              color: themeProvider.themeManager.borderSubtle01Color,
              spreadRadius: 0,
            ),
          ]),
      listScrollConfig: ScrollConfig(
          offset: 65,
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear),
      boardScrollConfig: ScrollConfig(
          offset: 45,
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear),
      listTransitionDuration: const Duration(milliseconds: 200),
      cardTransitionDuration: const Duration(milliseconds: 400),
    );
  }
}
