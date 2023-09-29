import 'package:flutter/material.dart';
import 'package:plane/utils/constants.dart';

import 'custom_text.dart';

class ProfileCircleAvatarsWidget extends StatefulWidget {
  const ProfileCircleAvatarsWidget({required this.details, super.key});
  final List details;

  @override
  State<ProfileCircleAvatarsWidget> createState() =>
      _ProfileCircleAvatarsWidgetState();
}

class _ProfileCircleAvatarsWidgetState
    extends State<ProfileCircleAvatarsWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.details.length == 1
          ? 20
          : widget.details.length == 2
              ? 35
              : 50,
      height: 20,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: widget.details[0]['avatar'] != "" &&
                    widget.details[0]['avatar'] != null
                ? CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.orange,
                    backgroundImage: NetworkImage(widget.details[0]['avatar']),
                  )
                : CircleAvatar(
                    radius: 10,
                    backgroundColor: darkSecondaryBGC,
                    child: Center(
                        child: CustomText(
                      widget.details[0]['display_name'] != null
                          ? widget.details[0]['display_name'][0]
                              .toString()
                              .toUpperCase()
                          : "",
                      color: Colors.white,
                    )),
                  ),
          ),
          widget.details.length >= 2
              ? Positioned(
                  left: 15,
                  child: widget.details[1]['avatar'] != "" &&
                          widget.details[1]['avatar'] != null
                      ? CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.blueAccent,
                          backgroundImage:
                              NetworkImage(widget.details[1]['avatar']),
                        )
                      : CircleAvatar(
                          radius: 10,
                          backgroundColor: darkSecondaryBGC,
                          child: Center(
                              child: CustomText(
                                  widget.details[1]['first_name'][0]
                                      .toString()
                                      .toUpperCase(),
                                  color: Colors.white)),
                        ),
                )
              : Container(),
          widget.details.length >= 3
              ? Positioned(
                  left: 30,
                  child: widget.details[2]['avatar'] != "" &&
                          widget.details[2]['avatar'] != null
                      ? CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          backgroundImage:
                              NetworkImage(widget.details[2]['avatar']),
                        )
                      : CircleAvatar(
                          radius: 10,
                          backgroundColor: darkSecondaryBGC,
                          child: Center(
                              child: CustomText(
                                  widget.details[2]['first_name'][0]
                                      .toString()
                                      .toUpperCase(),
                                  color: Colors.white)),
                        ),
                )
              : Container(),
        ],
      ),
    );
  }
}
