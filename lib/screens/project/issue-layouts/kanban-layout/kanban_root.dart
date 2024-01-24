import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/kanban/custom/board.dart';
import 'package:plane/kanban/models/inputs.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';

class KanbanLayoutRoot extends ConsumerStatefulWidget {
  const KanbanLayoutRoot({required this.isViews, super.key});
  final bool isViews;
  @override
  ConsumerState<KanbanLayoutRoot> createState() => _KanbanLayoutRootState();
}

class _KanbanLayoutRootState extends ConsumerState<KanbanLayoutRoot> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    return KanbanBoard(
      issuesProvider.initializeBoard(views: widget.isViews),
      boardID: 'issues-board',
      isCardsDraggable: issuesProvider.checkIsCardsDaraggable(),
      onItemReorder: (
          {newCardIndex, newListIndex, oldCardIndex, oldListIndex}) {
        //  print('newCardIndex: $newCardIndex, newListIndex: $newListIndex, oldCardIndex: $oldCardIndex, oldListIndex: $oldListIndex');
        issuesProvider
            .reorderIssue(
          context: context,
          newCardIndex: newCardIndex!,
          newListIndex: newListIndex!,
          oldCardIndex: oldCardIndex!,
          oldListIndex: oldListIndex!,
        )
            .then((value) {
          if (issuesProvider.issues.orderBY != OrderBY.manual) {
            CustomToast.showToast(context,
                message:
                    'This board is ordered by ${issuesProvider.issues.orderBY == OrderBY.lastUpdated ? 'last updated' : 'created at'} ',
                toastType: ToastType.warning);
          }
        }).catchError((e) {
          CustomToast.showToast(context,
              message: 'Failed to update issue', toastType: ToastType.failure);
        });
      },
      groupEmptyStates: !issuesProvider.showEmptyStates,
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
