// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/shimmer_effect_widget.dart';
import '../utils/enums.dart';

class SquareAvatarWidget extends ConsumerStatefulWidget {
  const SquareAvatarWidget(
      {required this.member_ids, this.borderRadius = 5, super.key});
  final List<String> member_ids;
  final double borderRadius;

  @override
  ConsumerState<SquareAvatarWidget> createState() => _SquareAvatarWidgetState();
}

class _SquareAvatarWidgetState extends ConsumerState<SquareAvatarWidget> {
  List<Map<String, dynamic>> members = [];
  @override
  void initState() {
    final workspaceMembers =
        ref.read(ProviderList.workspaceProvider).workspaceMembers;

    for (final member in workspaceMembers) {
      if (widget.member_ids.contains(member['member']['id'])) {
        members.add(member['member']);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return SizedBox(
      width: widget.member_ids.length == 1
          ? 30
          : widget.member_ids.length == 2
              ? 50
              : widget.member_ids.length == 3
                  ? 70
                  : 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(
                      color: themeProvider.themeManager.borderSubtle01Color,
                      width: 1),
                  color:
                      members[0]['avatar'] != "" && members[0]['avatar'] != null
                          ? Colors.transparent
                          : const Color.fromRGBO(55, 65, 80, 1),
                ),
                child:
                    members[0]['avatar'] != "" && members[0]['avatar'] != null
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
                            child: CachedNetworkImage(
                              imageUrl: members[0]['avatar'],
                              placeholder: (context, url) =>
                                  const ShimmerEffectWidget(
                                height: 30,
                                width: 30,
                                borderRadius: 5,
                              ),
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) {
                                return Container(
                                  color: const Color.fromRGBO(55, 65, 80, 1),
                                  child: Center(
                                    child: CustomText(
                                      members[0]['display_name'][0]
                                          .toString()
                                          .toUpperCase(),
                                      type: FontStyle.Small,
                                      color: Colors.white,
                                      //  color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ))
                        : Center(
                            child: CustomText(
                              members[0]['display_name'][0]
                                  .toString()
                                  .toUpperCase(),
                              type: FontStyle.Small,
                              color: Colors.white,
                              //  color: Colors.white,
                            ),
                          )),
          ),
          widget.member_ids.length >= 2
              ? Positioned(
                  left: 20,
                  child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        border: Border.all(
                            color:
                                themeProvider.themeManager.borderSubtle01Color,
                            width: 1),
                        color: members[1]['avatar'] != "" &&
                                members[1]['avatar'] != null
                            ? Colors.transparent
                            : const Color.fromRGBO(55, 65, 80, 1),
                      ),
                      child: members[1]['avatar'] != "" &&
                              members[1]['avatar'] != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(widget.borderRadius),
                              child: CachedNetworkImage(
                                imageUrl: members[1]['avatar'],
                                placeholder: (context, url) =>
                                    const ShimmerEffectWidget(
                                  height: 30,
                                  width: 30,
                                  borderRadius: 5,
                                ),
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) {
                                  return Container(
                                    color: const Color.fromRGBO(55, 65, 80, 1),
                                    child: Center(
                                      child: CustomText(
                                        members[1]['display_name'][0]
                                            .toString()
                                            .toUpperCase(),
                                        type: FontStyle.Small,
                                        color: Colors.white,
                                        //  color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              ))
                          : Center(
                              child: CustomText(
                                members[1]['display_name'][0]
                                    .toString()
                                    .toUpperCase(),
                                type: FontStyle.Small,
                                color: Colors.white,
                              ),
                            )),
                )
              : Container(),
          widget.member_ids.length >= 3
              ? Positioned(
                  left: 40,
                  child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        border: Border.all(
                            color:
                                themeProvider.themeManager.borderSubtle01Color,
                            width: 1),
                        color: members[2]['avatar'] != "" &&
                                members[2]['avatar'] != null
                            ? Colors.transparent
                            : const Color.fromRGBO(55, 65, 80, 1),
                      ),
                      child: members[2]['avatar'] != "" &&
                              members[2]['avatar'] != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(widget.borderRadius),
                              child: CachedNetworkImage(
                                  imageUrl: members[2]['avatar'],
                                  placeholder: (context, url) =>
                                      const ShimmerEffectWidget(
                                        height: 30,
                                        width: 30,
                                        borderRadius: 5,
                                      ),
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      color:
                                          const Color.fromRGBO(55, 65, 80, 1),
                                      child: Center(
                                        child: CustomText(
                                          members[2]['display_name'][0]
                                              .toString()
                                              .toUpperCase(),
                                          type: FontStyle.Small,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                  fit: BoxFit.cover))
                          : Center(
                              child: CustomText(
                                members[2]['display_name'][0]
                                    .toString()
                                    .toUpperCase(),
                                type: FontStyle.Small,
                                color: Colors.white,
                              ),
                            )),
                )
              : Container(),
          widget.member_ids.length >= 4
              ? Positioned(
                  left: 60,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      border: Border.all(
                          color: themeProvider.themeManager.borderSubtle01Color,
                          width: 1),
                      color: strokeColor,
                    ),
                    child: Center(
                      child: CustomText(
                        '+${widget.member_ids.length - 3}',
                        type: FontStyle.Small,
                        color: themeProvider.themeManager.placeholderTextColor,
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
