import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import '../utils/enums.dart';

class SquareAvatarWidget extends ConsumerStatefulWidget {
  final List details;
  const SquareAvatarWidget({required this.details, super.key});

  @override
  ConsumerState<SquareAvatarWidget> createState() => _SquareAvatarWidgetState();
}

class _SquareAvatarWidgetState extends ConsumerState<SquareAvatarWidget> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return SizedBox(
      width: widget.details.length == 1
          ? 30
          : widget.details.length == 2
              ? 50
              : widget.details.length == 3
                  ? 70
                  : 90,
      child: Stack(
        children: [
          Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: themeProvider.isDarkThemeEnabled
                        ? darkThemeBorder
                        : strokeColor,
                    width: 1),
                color: Colors.transparent,
              ),
              child: widget.details[0]['avatar'] != "" &&
                      widget.details[0]['avatar'] != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        widget.details[0]['avatar'],
                        fit: BoxFit.cover,
                      ))
                  : Center(
                      child: CustomText(
                        widget.details[0]['display_name'][0]
                            .toString()
                            .toUpperCase(),
                        type: FontStyle.Small,
                        //  color: Colors.white,
                      ),
                    )),
          widget.details.length >= 2
              ? Positioned(
                  left: 20,
                  child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border:
                            Border.all(color: lightBackgroundColor, width: 1),
                        color: darkSecondaryBGC,
                      ),
                      child: widget.details[1]['avatar'] != "" &&
                              widget.details[1]['avatar'] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                widget.details[1]['avatar'],
                                fit: BoxFit.cover,
                              ))
                          : Center(
                              child: CustomText(
                                widget.details[1]['display_name'][0]
                                    .toString()
                                    .toUpperCase(),
                                type: FontStyle.Small,
                                color: Colors.white,
                              ),
                            )),
                )
              : Container(),
          widget.details.length >= 3
              ? Positioned(
                  left: 40,
                  child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border:
                            Border.all(color: lightBackgroundColor, width: 1),
                        color: darkSecondaryBGC,
                      ),
                      child: widget.details[2]['avatar'] != "" &&
                              widget.details[2]['avatar'] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                widget.details[2]['avatar'],
                                fit: BoxFit.cover,
                              ))
                          : Center(
                              child: CustomText(
                                widget.details[2]['display_name'][0]
                                    .toString()
                                    .toUpperCase(),
                                type: FontStyle.Small,
                                color: Colors.white,
                              ),
                            )),
                )
              : Container(),
          widget.details.length >= 4
              ? Positioned(
                  left: 60,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: lightBackgroundColor, width: 1),
                      color: strokeColor,
                    ),
                    child: Center(
                      child: CustomText(
                        '+${widget.details.length - 3}',
                        type: FontStyle.Small,
                        color: greyColor,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
