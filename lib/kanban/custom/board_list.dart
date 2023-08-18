import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/kanban/Provider/provider_list.dart';
import 'package:plane_startup/kanban/models/item_state.dart';

import 'list_item.dart';

class BoardList extends ConsumerStatefulWidget {
  const BoardList({super.key, required this.index});
  final int index;

  @override
  ConsumerState<BoardList> createState() => _BoardListState();
}

class _BoardListState extends ConsumerState<BoardList> {
  Offset location = Offset.zero;

  @override
  Widget build(BuildContext context) {
    var prov = ref.read(ProviderList.boardProvider);
    var listProv = ref.read(ProviderList.boardListProvider);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      listProv.calculateSizePosition(
          listIndex: widget.index,
          context: context,
          setstate: () => setState(() {}));
    });
    return prov.board.groupEmptyStates == true &&
            prov.board.lists[widget.index].items.isEmpty
        ? Container()
        : prov.board.lists[widget.index].shrink
            ? Container(
                margin: const EdgeInsets.only(right: 15, top: 15),
                height: prov.board.lists[widget.index].width,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: prov.board.lists[widget.index].header,
                ),
              )
            : ValueListenableBuilder(
                valueListenable: prov.valueNotifier,
                builder: (context, a, b) {
                  if (prov.board.isElementDragged == true) {
                    var draggedItemIndex = prov.board.dragItemIndex;
                    var draggedItemListIndex = prov.board.dragItemOfListIndex;
                    var list = prov.board.lists[widget.index];
                    var box = context.findRenderObject();
                    var listBox = list.context!.findRenderObject();
                    if (box == null || listBox == null) return b!;

                    box = box as RenderBox;
                    listBox = listBox as RenderBox;
                    location = box.localToGlobal(Offset.zero);

                    list.x = listBox.localToGlobal(Offset.zero).dx -
                        prov.board.displacementX!;
                    list.y = listBox.localToGlobal(Offset.zero).dy -
                        prov.board.displacementY!;

                    if (((prov.draggedItemState!.width * 0.6) +
                                prov.valueNotifier.value.dx >
                            prov.board.lists[widget.index].x!) &&
                        ((prov.board.lists[widget.index].x! +
                                prov.board.lists[widget.index].width! >
                            prov.draggedItemState!.width +
                                prov.valueNotifier.value.dx)) &&
                        (prov.board.dragItemOfListIndex! != widget.index)) {
                     // print("RIGHT ->");
                     // print(prov.board.lists[widget.index].items.length);
                      // CASE: WHEN ELEMENT IS DRAGGED RIGHT SIDE AND LIST HAVE NO ELEMENT IN IT //
                      if (prov.board.lists[widget.index].items.isEmpty) {
                        log("LIST 0 RIGHT");
                       prov.move = "REPLACE";
                        prov.board.lists[widget.index].items.add(ListItem(
                            child: Container(
                              decoration: prov
                                      .board.cardPlaceHolderDecoration ??
                                  BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(6),
                                    color: prov.board.cardPlaceholderColor ??
                                        Colors.white,
                                  ),
                              margin: const EdgeInsets.only(top: 5),
                              width: prov.draggedItemState!.width,
                              height: prov.draggedItemState!.height,
                            ),
                            prevChild:
                                Container(), // WE HAVE ADDED THIS IN EMPTY LIST JUST TO SHOW PLACEHOLDER, so it should be hiddent
                            listIndex: widget.index,
                            index: 0,
                            addedBySystem: true));

                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          prov.board.lists[prov.board.dragItemOfListIndex!]
                                  .items[prov.board.dragItemIndex!].child =
                              prov.board.lists[prov.board.dragItemOfListIndex!]
                                  .items[prov.board.dragItemIndex!].prevChild;
                          prov.board.lists[prov.board.dragItemOfListIndex!]
                              .items[prov.board.dragItemIndex!].setState!();
                          prov.board.dragItemIndex = 0;
                          prov.board.dragItemOfListIndex = widget.index;
                          setState(() {});
                        });
                      }
                      // CASE WHEN LIST HAVE ONLY ONE ITEM AND IT IS PICKED, SO NOW IT IS HIDDEN, ITS SIZE IS 0 , SO WE NEED TO HANDLE IT EXPLICITLY  //
                      else if (prov.board.lists[widget.index].items.length ==
                              1 &&
                          prov.draggedItemState!.itemIndex == 0 &&
                          prov.draggedItemState!.listIndex == widget.index) {
                       // print("RIGHT LENGTH == 1");
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          if (prov.board.lists[draggedItemListIndex!]
                                  .items[draggedItemIndex!].addedBySystem ==
                              true) {
                            prov.board.lists[draggedItemListIndex].items
                                .removeAt(draggedItemIndex);
                            prov.board.lists[draggedItemListIndex].setState!();
                          } else {
                            prov
                                .board
                                .lists[prov.board.dragItemOfListIndex!]
                                .items[prov.board.dragItemIndex!]
                                .bottomPlaceholder = false;

                            prov.board.lists[prov.board.dragItemOfListIndex!]
                                    .items[prov.board.dragItemIndex!].child =
                                prov
                                    .board
                                    .lists[prov.board.dragItemOfListIndex!]
                                    .items[prov.board.dragItemIndex!]
                                    .prevChild;

                            prov.board.lists[prov.board.dragItemOfListIndex!]
                                .items[prov.board.dragItemIndex!].setState!();
                          }
                          prov.board.dragItemIndex = 0;
                          prov.board.dragItemOfListIndex = widget.index;
                          // log("UPDATED | ITEM= ${widget.itemIndex} | LIST= ${widget.listIndex}");
                          prov.board.lists[prov.board.dragItemOfListIndex!]
                              .items[prov.board.dragItemIndex!].setState!();
                        });
                      }
                    } else if (((prov.draggedItemState!.width * 0.6) +
                                prov.valueNotifier.value.dx <
                            prov.board.lists[widget.index].x! +
                                prov.board.lists[widget.index].width!) &&
                        ((prov.board.lists[widget.index].x! +
                                prov.board.lists[widget.index].width! <
                            prov.draggedItemState!.width +
                                prov.valueNotifier.value.dx)) &&
                        (prov.board.dragItemOfListIndex! != widget.index)) {
                      if (prov.board.lists[widget.index].items.isEmpty) {
                      prov.move = "REPLACE";
                      //  print("LIST 0 LEFT");
                        prov.board.lists[widget.index].items.add(ListItem(
                            child: Container(
                              decoration: prov
                                      .board.cardPlaceHolderDecoration ??
                                  BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(6),
                                    color: prov.board.cardPlaceholderColor ??
                                        Colors.white,
                                  ),
                              margin: const EdgeInsets.only(top: 5),
                              width: prov.draggedItemState!.width,
                              height: prov.draggedItemState!.height,
                            ),
                            prevChild:
                                Container(), // WE HAVE ADDED THIS IN EMPTY LIST JUST TO SHOW PLACEHOLDER, so it should be hiddent
                            listIndex: widget.index,
                            index: 0,
                            addedBySystem: true));

                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          prov.board.lists[prov.board.dragItemOfListIndex!]
                                  .items[prov.board.dragItemIndex!].child =
                              prov.board.lists[prov.board.dragItemOfListIndex!]
                                  .items[prov.board.dragItemIndex!].prevChild;
                          prov.board.lists[prov.board.dragItemOfListIndex!]
                              .items[prov.board.dragItemIndex!].setState!();
                          prov.board.dragItemIndex = 0;
                          prov.board.dragItemOfListIndex = widget.index;
                          setState(() {});
                        });
                      }
                      // CASE: WHEN LIST CONTAINS ONLY ONE ITEM, AND WHICH IS THE FIRST ITEM DRAGGED DURING A PARTICULAR SESSION, WHICH IS CURRENTLY HIDDEN //

                      else if (prov.board.lists[widget.index].items.length ==
                              1 &&
                          prov.draggedItemState!.itemIndex == 0 &&
                          prov.draggedItemState!.listIndex == widget.index) {
                       // print("LEFT LENGTH == 1");
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          // CASE : IF PREVIOUSLY PLACEHOLDER IS ADDED IN EMPTY LIST THEN EXPLICITLY REMOVE THAT PLACEHOLDER, AND MAKE THAT LIST EMPTY AGAIN //
                          if (prov.board.lists[draggedItemListIndex!]
                                  .items[draggedItemIndex!].addedBySystem ==
                              true) {
                            prov.board.lists[draggedItemListIndex].items
                                .removeAt(draggedItemIndex);
                            prov.board.lists[draggedItemListIndex].setState!();
                          } else {
                            prov
                                .board
                                .lists[draggedItemListIndex]
                                .items[draggedItemIndex]
                                .bottomPlaceholder = false;

                            prov.board.lists[draggedItemListIndex]
                                    .items[draggedItemIndex].child =
                                prov.board.lists[draggedItemListIndex]
                                    .items[draggedItemIndex].prevChild;

                            prov.board.lists[draggedItemListIndex]
                                .items[draggedItemIndex].setState!();
                          }

                          // Placeholder is updated at current position //
                          prov.board.dragItemIndex = 0;
                          prov.board.dragItemOfListIndex = widget.index;
                          // log("UPDATED | ITEM= ${widget.itemIndex} | LIST= ${widget.listIndex}");
                          prov.board.lists[prov.board.dragItemOfListIndex!]
                              .items[prov.board.dragItemIndex!].setState!();
                        });
                      }
                    }
                  }
                  return b!;
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8, top: 0, bottom: 15),
                  width: prov.board.lists[widget.index].width!,
                  decoration: prov.board.listDecoration ??
                      BoxDecoration(
                          color: prov.board.lists[widget.index].backgroundColor,
                          borderRadius: BorderRadius.circular(6)),
                  child: AnimatedSwitcher(
                    transitionBuilder: (child, animation) => prov
                                .board.listTransitionBuilder !=
                            null
                        ? prov.board.cardTransitionBuilder!(child, animation)
                        : FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                    //  layoutBuilder: (currentChild, previousChildren) => currentChild!,
                    duration: prov.board.listTransitionDuration,

                    child: prov.board.isListDragged &&
                            prov.draggedItemState!.listIndex == widget.index

                        // PLACE HOLDER | if list is getting dragged //
                        ? Container(
                            key: ValueKey(
                              "PLACEHOLDER ${widget.index}",
                            ),
                            color: prov.board.lists.length - 1 == widget.index
                                ? prov.board.listPlaceholderColor ??
                                    Colors.white.withOpacity(0.8)
                                : prov.board.listPlaceholderColor ??
                                    Colors.transparent,
                            child: prov.board.lists.length - 1 == widget.index
                                ? prov.board.listPlaceholderColor != null
                                    ? null
                                    : Opacity(
                                        opacity: 0.6,
                                        child: prov.draggedItemState!.child)
                                : null,
                          )
                        : Column(
                            key: ValueKey("LIST ${widget.index}"),
                            children: [
                                // HEADER //
                                prov.board.lists[widget.index].header ??
                                    GestureDetector(
                                      onLongPress: () {
                                        listProv.onListLongpress(
                                            listIndex: widget.index,
                                            context: context,
                                            setstate: () => setState(() {}));
                                      },
                                      child: Container(
                                        width: prov
                                            .board.lists[widget.index].width,
                                        color: prov.board.lists[widget.index]
                                            .headerBackgroundColor,
                                        margin:
                                            const EdgeInsets.only(bottom: 0),
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            bottom: 10,
                                            top: 10,
                                            right: 0),
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              prov.board.lists[widget.index]
                                                  .title,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.grey.shade800,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                                // padding: const EdgeInsets.all(5),
                                                child: PopupMenuButton(
                                                    constraints: BoxConstraints(
                                                      minWidth: prov
                                                              .board
                                                              .lists[
                                                                  widget.index]
                                                              .width! *
                                                          0.7,
                                                      maxWidth: prov
                                                              .board
                                                              .lists[
                                                                  widget.index]
                                                              .width! *
                                                          0.7,
                                                    ),
                                                    itemBuilder: (ctx) {
                                                      return [
                                                        PopupMenuItem(
                                                          value: 1,
                                                          child: Text(
                                                            "Add card",
                                                            style: prov.board
                                                                .textStyle,
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          value: 2,
                                                          child: Text(
                                                            "Delete List",
                                                            style: prov.board
                                                                .textStyle,
                                                          ),
                                                        ),
                                                      ];
                                                    },
                                                    onSelected: (value) async {
                                                      if (value == 1) {
                                                        listProv.addNewCard(
                                                            position: "TOP",
                                                            listIndex:
                                                                widget.index);
                                                      } else if (value == 2) {
                                                        prov.board.lists
                                                            .removeAt(
                                                                widget.index);
                                                        prov.board.setstate!();
                                                      }
                                                    })),
                                          ],
                                        ),
                                      ),
                                    ),
                                const SizedBox(
                                  height: 15,
                                ),
                                prov.board.lists[widget.index].shrink
                                    ? Container()
                                    : Expanded(
                                        child: MediaQuery.removePadding(
                                          context: context,
                                          removeTop: true,
                                          child: ListView.builder(
                                            physics:
                                                const ClampingScrollPhysics(),
                                            controller: prov
                                                .board
                                                .lists[widget.index]
                                                .scrollController,
                                            itemCount: prov
                                                .board
                                                .lists[widget.index]
                                                .items
                                                .length,
                                            shrinkWrap: true,
                                            itemBuilder: (ctx, index) {
                                              return Item(
                                                itemIndex: index,
                                                listIndex: widget.index,
                                              );
                                            },

                                            // itemCount: prov.items.length,
                                          ),
                                        ),
                                      ),

                                // Container(
                                //   padding: const EdgeInsets.only(left: 15),
                                //   height: 45,
                                //   width: prov.board.lists[widget.index].width,
                                //   color: const Color.fromRGBO(250, 250, 250, 1),
                                //   child: GestureDetector(
                                //     onTap: () async {
                                //       listProv.addNewCard(
                                //           position: "LAST", listIndex: widget.index);
                                //     },
                                //     child: Row(
                                //       children: const [
                                //         Icon(
                                //           Icons.add,
                                //            color: Color.fromRGBO(63, 118, 255, 1),
                                //           size: 22,
                                //         ),
                                //          SizedBox(
                                //           width: 10,
                                //         ),
                                //         Text(
                                //           'Add Issue',
                                //           style: TextStyle(
                                //               color: Color.fromRGBO(63, 118, 255, 1),
                                //               fontSize: 19,
                                //               fontWeight: FontWeight.bold),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // )
                              ]),
                  ),
                ));
  }
}
