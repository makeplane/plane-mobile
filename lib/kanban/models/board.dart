import 'package:flutter/material.dart';

import 'board_list.dart';
import 'inputs.dart';

class BoardState {
  List<BoardList> lists = [];
  String boardID;
  ScrollController controller;
  VoidCallback? setstate;
  int? dragListIndex = 0;
  int? dragItemIndex = 0;
  int? previousDragListIndex = 0;
  int? dragItemOfListIndex = 0;
  int? prevItemOfListIndex = 0;
  double? displacementX;
  double? displacementY;

  bool isElementDragged = false;
  bool isListDragged = false;
  TextEditingController newCardTextController = TextEditingController();
  bool? newCardFocused = false;
  int? newCardListIndex;
  int? newCardIndex;
  Function(int? itemIndex, int? listIndex)? onItemTap;
  Function(int? itemIndex, int? listIndex)? onItemLongPress;
  Function(int? listIndex)? onListTap;
  Function(int? listIndex)? onListLongPress;
  final void Function(
      {int? oldCardIndex,
      int? newCardIndex,
      int? oldListIndex,
      int? newListIndex})? onItemReorder;
  final void Function(int? oldListIndex, int? newListIndex)? onListReorder;
  final void Function(String? oldName, String? newName)? onListRename;
  final void Function(String? cardIndex, String? listIndex, String? text)?
      onNewCardInsert;
  final Widget Function(Widget child, Animation<double> animation)?
      cardTransitionBuilder;
  final Widget Function(Widget child, Animation<double> animation)?
      listTransitionBuilder;
  Color? backgroundColor;
  Color? cardPlaceholderColor;
  Color? listPlaceholderColor;
  final ScrollConfig? boardScrollConfig;
  final ScrollConfig? listScrollConfig;
  TextStyle? textStyle;
  Decoration? listDecoration;
  Decoration? boardDecoration;
  Decoration? cardPlaceHolderDecoration;
  final bool? groupEmptyStates;
  final Duration cardTransitionDuration;
  final Duration listTransitionDuration;
  final bool isCardsDraggable;
  BoardState(
      {required this.lists,
      required this.boardID,
      required this.controller,
      this.dragListIndex,
      this.isCardsDraggable = true,
      this.groupEmptyStates,
      this.cardPlaceHolderDecoration,
      this.onItemTap,
      this.onItemLongPress,
      this.boardScrollConfig,
      this.listScrollConfig,
      this.setstate,
      this.onListTap,
      this.onItemReorder,
      this.onListReorder,
      this.onListRename,
      this.onNewCardInsert,
      this.displacementX,
      this.displacementY,
      this.newCardIndex,
      this.newCardListIndex,
      this.onListLongPress,
      this.dragItemIndex,
      this.textStyle,
      this.backgroundColor = Colors.white,
      this.cardPlaceholderColor,
      this.listPlaceholderColor,
      this.cardTransitionBuilder,
      this.listTransitionBuilder,
      this.listDecoration,
      this.boardDecoration,
      this.dragItemOfListIndex,
      this.isElementDragged = false,
      this.cardTransitionDuration = const Duration(milliseconds: 150),
      this.listTransitionDuration = const Duration(milliseconds: 150),
      this.isListDragged = false}) {
    textStyle = textStyle ??
        TextStyle(
            color: Colors.grey.shade800,
            fontSize: 19,
            fontWeight: FontWeight.w400);
  }
}
