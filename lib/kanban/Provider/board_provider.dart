import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/kanban/models/board.dart';
import 'package:plane/kanban/models/board_list.dart';
import 'package:plane/kanban/models/inputs.dart';
import 'package:plane/kanban/models/item_state.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_text.dart';

import '../../utils/enums.dart';

class BoardProvider extends ChangeNotifier {
  BoardProvider(ChangeNotifierProviderRef<BoardProvider> this.ref);
  Ref ref;
  ValueNotifier<Offset> valueNotifier = ValueNotifier<Offset>(Offset.zero);
  String move =
      ""; // This value is used to find the actual position of droppped element //
  DraggedItemState? draggedItemState;

  late BoardState board;
  var scrolling = false;
  var scrollingRight = false;
  var scrollingLeft = false;

  void setcanDrag(
      {required bool value, required int itemIndex, required int listIndex}) {
    board.isElementDragged = value;
    board.isListDragged = value;
    move = "";
    if (value == false) {
      draggedItemState = null;
      return;
    }

    var item = board.lists[listIndex].items[itemIndex];
    draggedItemState = DraggedItemState(
        child: item.child,
        listIndex: listIndex,
        itemIndex: itemIndex,
        height: item.height!,
        width: item.width!,
        x: item.x!,
        y: item.y!);
    notifyListeners();
  }

  void initializeBoard(
      {required List<BoardListsData> data,
      required String boardID,
      Color backgroundColor = Colors.white,
      TextStyle? textStyle,
      final bool isCardsDraggable = true,
      Function(int? itemIndex, int? listIndex)? onItemTap,
      Function(int? itemIndex, int? listIndex)? onItemLongPress,
      Function(int? listIndex)? onListTap,
      Function(int? listIndex)? onListLongPress,
      double? displacementX,
      double? displacementY,
      void Function(
              {int? oldCardIndex,
              int? newCardIndex,
              int? oldListIndex,
              int? newListIndex})?
          onItemReorder,
      void Function(int? oldListIndex, int? newListIndex)? onListReorder,
      void Function(String? oldName, String? newName)? onListRename,
      void Function(String? cardIndex, String? listIndex, String? text)?
          onNewCardInsert,
      Decoration? boardDecoration,
      Decoration? listDecoration,
      Decoration? cardPlaceHolderDecoration,
      Widget Function(Widget child, Animation<double> animation)?
          listTransitionBuilder,
      Widget Function(Widget child, Animation<double> animation)?
          cardTransitionBuilder,
      required Duration cardTransitionDuration,
      required Duration listTransitionDuration,
      Color? cardPlaceHolderColor,
      Color? listPlaceHolderColor,
      ScrollConfig? boardScrollConfig,
      ScrollConfig? listScrollConfig,
      required bool groupEmptyStates}) {
    var themeProvider = ref.read(ProviderList.themeProvider);
    board = BoardState(
      boardID: boardID,
        textStyle: textStyle,
        lists: [],
        isCardsDraggable: isCardsDraggable,
        displacementX: displacementX,
        displacementY: displacementY,
        onItemTap: onItemTap,
        groupEmptyStates: groupEmptyStates,
        onItemLongPress: onItemLongPress,
        onListTap: onListTap,
        onListLongPress: onListLongPress,
        onItemReorder: onItemReorder,
        onListReorder: onListReorder,
        onListRename: onListRename,
        onNewCardInsert: onNewCardInsert,
        boardScrollConfig: boardScrollConfig,
        listScrollConfig: listScrollConfig,
        listTransitionBuilder: listTransitionBuilder,
        cardTransitionBuilder: cardTransitionBuilder,
        cardTransitionDuration: cardTransitionDuration,
        listTransitionDuration: listTransitionDuration,
        controller: ScrollController(),
        backgroundColor: backgroundColor,
        cardPlaceholderColor: cardPlaceHolderColor,
        listPlaceholderColor: listPlaceHolderColor,
        cardPlaceHolderDecoration: cardPlaceHolderDecoration,
        listDecoration: listDecoration,
        boardDecoration: boardDecoration);
    // log("LENGTH=${data.length}");
    BoardList emptyStates = BoardList(
        // footer: data[i].footer,
        index: double.maxFinite.toInt(),
        headerBackgroundColor: data.first.headerBackgroundColor,
        footerBackgroundColor: data.first.footerBackgroundColor,
        backgroundColor: data.first.backgroundColor,
        items: [],
        width: data.first.width,
        scrollController: ScrollController(),
        title: 'Hidden groups');
    for (int i = 0; i < data.length; i++) {
      if (data[i].items.isEmpty && groupEmptyStates) {
        var widget = Container(
          height: 50,
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: themeProvider.themeManager.primaryBackgroundDefaultColor,
            border: Border.all(
                color: themeProvider.themeManager.borderSubtle01Color,
                width: 1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              data[i].leading!,
              const SizedBox(
                width: 10,
              ),
              CustomText(
                data[i].title!,
                type: FontStyle.Small,
                // fontSize: 20,
              ),
            ],
          ),
        );
        emptyStates.items.add(ListItem(
            child: widget,
            listIndex: data.length,
            index: emptyStates.items.length,
            prevChild: widget));
        //  continue;
      }
      List<ListItem> listItems = [];
      for (int j = 0; j < data[i].items.length; j++) {
        listItems.add(ListItem(
            child: data[i].items[j],
            listIndex: i,
            index: j,
            prevChild: data[i].items[j]));
      }
      board.lists.add(BoardList(
          index: i,
          header: data[i].header,
          footer: data[i].footer,
          shrink: data[i].shrink!,
          leading: data[i].leading,
          headerBackgroundColor: data[i].headerBackgroundColor,
          footerBackgroundColor: data[i].footerBackgroundColor,
          backgroundColor: data[i].backgroundColor,
          items: listItems,
          width: data[i].width,
          scrollController: ScrollController(),
          title: data[i].title ?? 'LIST ${i + 1}'));
    }
    if (emptyStates.items.isNotEmpty && groupEmptyStates) {
      emptyStates.header = Container(
        width: data.first.width,
        height: 50,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            CustomText(
              'Hidden groups',
              type: FontStyle.H6,
              fontWeight: FontWeightt.Semibold,
              color: themeProvider.themeManager.primaryTextColor,
              fontSize: 20,
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                left: 15,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: themeProvider
                      .themeManager.tertiaryBackgroundDefaultColor),
              height: 25,
              width: 35,
              child: CustomText(
                emptyStates.items.length.toString(),
                type: FontStyle.Small,
              ),
            ),
          ],
        ),
      );
      emptyStates.index = board.lists.length;
      board.lists.add(emptyStates);
    }
  }

  void updateValue({
    required double dx,
    required double dy,
  }) {
    valueNotifier.value = Offset(dx, dy);
  }

  void setsState() {
    notifyListeners();
  }

  void boardScroll() async {
    if ((board.isElementDragged == false && board.isListDragged == false) ||
        scrolling) {
      return;
    }
    if (board.boardScrollConfig == null) {
      if (board.controller.offset < board.controller.position.maxScrollExtent &&
          valueNotifier.value.dx + (draggedItemState!.width / 2) >
              board.controller.position.viewportDimension - 100) {
        scrolling = true;
        scrollingRight = true;
        await board.controller.animateTo(board.controller.offset + 65,
            duration: const Duration(milliseconds: 150), curve: Curves.linear);
        scrolling = false;
        scrollingRight = false;
        boardScroll();
      } else if (board.controller.offset > 0 && valueNotifier.value.dx <= 0) {
        scrolling = true;
        scrollingLeft = true;
        await board.controller.animateTo(board.controller.offset - 65,
            duration:
                Duration(milliseconds: valueNotifier.value.dx < 20 ? 50 : 100),
            curve: Curves.linear);
        scrolling = false;
        scrollingLeft = false;
        boardScroll();
      }
    } else {
      if (board.controller.offset < board.controller.position.maxScrollExtent &&
          valueNotifier.value.dx + (draggedItemState!.width * 0.6) >
              board.controller.position.viewportDimension) {
        //print("SCROLLING 0.3");
        scrolling = true;
        scrollingRight = true;
        await board.controller.animateTo(
            board.controller.offset + board.boardScrollConfig!.offset,
            duration: board.boardScrollConfig!.duration,
            curve: board.boardScrollConfig!.curve);
        scrolling = false;
        scrollingRight = false;
        boardScroll();
      } else if (board.controller.offset <
              board.controller.position.maxScrollExtent &&
          valueNotifier.value.dx + (draggedItemState!.width * 0.8) >
              board.controller.position.viewportDimension) {
        scrolling = true;
        scrollingRight = true;
        await board.controller.animateTo(
            board.controller.offset + board.boardScrollConfig!.offset,
            duration: Duration(
                milliseconds:
                    board.boardScrollConfig!.duration.inMilliseconds * 3),
            curve: board.boardScrollConfig!.curve);
        scrolling = false;
        scrollingRight = false;
        boardScroll();
      } else if (board.controller.offset > 0 &&
          valueNotifier.value.dx + (draggedItemState!.width * 0.1) <= 0) {
        scrolling = true;
        scrollingLeft = true;
        await board.controller.animateTo(
            board.controller.offset - board.boardScrollConfig!.offset,
            duration: board.boardScrollConfig!.duration,
            curve: board.boardScrollConfig!.curve);
        scrolling = false;
        scrollingLeft = false;
        boardScroll();
      } else if (board.controller.offset > 0 && valueNotifier.value.dx <= 20) {
        scrolling = true;
        scrollingLeft = true;
        await board.controller.animateTo(
            board.controller.offset - board.boardScrollConfig!.offset,
            duration: Duration(
                milliseconds:
                    board.boardScrollConfig!.duration.inMilliseconds * 3),
            curve: board.boardScrollConfig!.curve);
        scrolling = false;
        scrollingLeft = false;
        boardScroll();
      }
    }
  }
}
