import 'package:flutter/material.dart';

class ListItem {
  BuildContext? context;
  double? height;
  double? width;
  int listIndex;
  VoidCallback? setState;
  bool? isNew;
  Color? backgroundColor = Colors.white;
  int index;
  double? x;
  double? y;
  bool? containsPlaceholder;
  bool? bottomPlaceholder = false;
  Widget child;
  bool? addedBySystem = false;
  Size? actualSize;
  Widget prevChild;
  ListItem({
    this.context,
    required this.child,
    required this.prevChild,
    required this.listIndex,
    required this.index,
    this.actualSize,
    this.height,
    this.containsPlaceholder,
    this.setState,
    this.addedBySystem,
    this.bottomPlaceholder = false,
    this.backgroundColor,
    this.width,
    this.x,
    this.y,
    this.isNew = false,
  });
}

class DraggedItemState {
  BuildContext? context;
  double height;
  double width;
  int? listIndex;
  int? itemIndex;
  double x;
  VoidCallback? setState;
  double y;
  Widget child;
  DraggedItemState({
    this.context,
    required this.child,
    this.setState,
    required this.listIndex,
    required this.itemIndex,
    required this.height,
    required this.width,
    required this.x,
    required this.y,
  });
}
