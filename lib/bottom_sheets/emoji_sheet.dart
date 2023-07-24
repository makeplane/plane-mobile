import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/utils/constants.dart';

import 'package:plane_startup/widgets/custom_text.dart';

class EmojiSheet extends ConsumerStatefulWidget {
  final List<String> emojisWidgets;
  const EmojiSheet({super.key, required this.emojisWidgets});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmojiSheetState();
}

class _EmojiSheetState extends ConsumerState<EmojiSheet> {
  int selected = 0;
  String selectedEmoji = '';
  bool showEMOJI = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          shrinkWrap: true,

          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          // physics: NeverScrollableScrollPhysics(),
          children: [
            const SizedBox(
              height: 110,
            ),
            selected == 0
                ? Wrap(
                    spacing: 10,
                    runSpacing: 1,
                    children: widget.emojisWidgets
                        .map(
                          (e) => InkWell(
                            onTap: () {
                              setState(() {
                                selectedEmoji = e;
                                showEMOJI = false;
                              });
                            },
                            child: CustomText(
                              e,
                              type: FontStyle.heading,
                            ),
                          ),
                        )
                        .toList(),
                  )
                : Container(),
          ],
        ),
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),

          // height: 80,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: CustomText(
                      'Choose your project icon',
                      type: FontStyle.heading,
                    ),
                  ),
                  // const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 27,
                        color: Color.fromRGBO(143, 143, 147, 1),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              //row containing two tabs one for emoji and other for icon with an underline
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //emoji tab
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          // emojiTab = true;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: selected == 0 ? primaryColor : greyColor,
                              width: 2,
                            ),
                          ),
                        ),
                        child: CustomText(
                          'Emoji',
                          type: FontStyle.mainHeading,
                          fontWeight: FontWeight.w400,
                          color: selected == 0 ? primaryColor : greyColor,
                        ),
                      ),
                    ),
                  ),

                  //icon tab
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          // emojiTab = false;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: selected == 1 ? primaryColor : greyColor,
                              width: 2,
                            ),
                          ),
                        ),
                        child: CustomText(
                          'Icon',
                          type: FontStyle.mainHeading,
                          fontWeight: FontWeight.w400,
                          color: selected == 1 ? primaryColor : greyColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
