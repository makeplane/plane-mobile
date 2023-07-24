import 'package:flutter/material.dart';
import 'item_state.dart';

class BoardList {
  BuildContext? context;
  double? x;
  double? y;
  double? height;
  double? width;
  Widget? child;
  Widget? header;
  Widget? footer;
  Color? headerBackgroundColor;
  Color? footerBackgroundColor;
  Color? backgroundColor;
  VoidCallback? setState;
  List<ListItem> items = [];
  TextEditingController nameController = TextEditingController();
  ScrollController scrollController;
  bool shrink;
  String title;
  int index;
  Widget? leading;
  BoardList(
      {required this.items,
      required this.index,
      this.shrink = false,
      this.leading,
      this.context,
      this.height,
      this.width,
      this.header,
      this.footer,
      this.setState,
      this.headerBackgroundColor = const Color.fromARGB(
        255,
        247,
        248,
        252,
      ),
      this.footerBackgroundColor = const Color.fromARGB(
        255,
        247,
        248,
        252,
      ),
      this.x,
      this.child,
      this.backgroundColor = const Color.fromARGB(
        255,
        247,
        248,
        252,
      ),
      this.y,
      required this.scrollController,
      required this.title}) {
    headerBackgroundColor = headerBackgroundColor ?? Colors.grey.shade300;
    footerBackgroundColor = footerBackgroundColor ?? Colors.grey.shade300;
  }
}
