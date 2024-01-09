import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/member_logo_widget.dart';

import 'custom_text.dart';

class ProfileCircleAvatarsWidget extends ConsumerStatefulWidget {
  const ProfileCircleAvatarsWidget({required this.details, super.key});
  final List details;

  @override
  ConsumerState<ProfileCircleAvatarsWidget> createState() =>
      _ProfileCircleAvatarsWidgetState();
}

class _ProfileCircleAvatarsWidgetState
    extends ConsumerState<ProfileCircleAvatarsWidget> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return SizedBox(
      width: widget.details.length == 1
          ? 22
          : widget.details.length == 2
              ? 39
              : 55,
      height: 22,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: widget.details[0]['avatar'] != "" &&
                    widget.details[0]['avatar'] != null
                ? CircleAvatar(
                    radius: 11,
                    backgroundColor:
                        themeProvider.themeManager.placeholderTextColor,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.orange,
                      child: MemberLogoWidget(
                        imageUrl: widget.details[0]['avatar'],
                        colorForErrorWidget: themeProvider
                            .themeManager.tertiaryBackgroundDefaultColor,
                        memberNameFirstLetterForErrorWidget: widget.details[0]
                                ['display_name'][0]
                            .toString()
                            .toUpperCase(),
                        size: 20,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 11,
                    backgroundColor:
                        themeProvider.themeManager.placeholderTextColor,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: darkSecondaryBGC,
                      child: Center(
                          child: CustomText(
                        widget.details[0]['display_name'] != null
                            ? widget.details[0]['display_name'][0]
                                .toString()
                                .toUpperCase()
                            : "",
                        type: FontStyle.Small,
                        color: Colors.white,
                      )),
                    ),
                  ),
          ),
          widget.details.length >= 2
              ? Positioned(
                  left: 15,
                  child: widget.details[1]['avatar'] != "" &&
                          widget.details[1]['avatar'] != null
                      ? CircleAvatar(
                          radius: 11,
                          backgroundColor:
                              themeProvider.themeManager.placeholderTextColor,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.blueAccent,
                            child: MemberLogoWidget(
                              padding: EdgeInsets.zero,
                              imageUrl: widget.details[1]['avatar'],
                              colorForErrorWidget: themeProvider
                                  .themeManager.tertiaryBackgroundDefaultColor,
                              memberNameFirstLetterForErrorWidget: widget
                                  .details[1]['display_name'][0]
                                  .toString()
                                  .toUpperCase(),
                              size: 20,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 11,
                          backgroundColor:
                              themeProvider.themeManager.placeholderTextColor,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: themeProvider
                                .themeManager.tertiaryBackgroundDefaultColor,
                            child: Center(
                              child: CustomText(
                                widget.details[1]['display_name'][0]
                                    .toString()
                                    .toUpperCase(),
                                type: FontStyle.Small,
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                              ),
                            ),
                          ),
                        ),
                )
              : Container(),
          widget.details.length >= 3
              ? Positioned(
                  left: 30,
                  child: widget.details[2]['avatar'] != "" &&
                          widget.details[2]['avatar'] != null
                      ? CircleAvatar(
                          radius: 11,
                          backgroundColor: themeProvider
                              .themeManager.tertiaryBackgroundDefaultColor,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: MemberLogoWidget(
                              padding: EdgeInsets.zero,
                              imageUrl: widget.details[2]['avatar'],
                              colorForErrorWidget: themeProvider
                                  .themeManager.tertiaryBackgroundDefaultColor,
                              memberNameFirstLetterForErrorWidget: widget
                                  .details[2]['display_name'][0]
                                  .toString()
                                  .toUpperCase(),
                              size: 20,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 11,
                          backgroundColor:
                              themeProvider.themeManager.placeholderTextColor,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: themeProvider
                                .themeManager.tertiaryBackgroundDefaultColor,
                            child: Center(
                              child: CustomText(
                                widget.details[2]['display_name'][0]
                                    .toString()
                                    .toUpperCase(),
                                type: FontStyle.Small,
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                              ),
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
