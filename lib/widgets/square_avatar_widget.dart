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
      {required this.details, this.borderRadius = 5, super.key});
  final List details;
  final double borderRadius;

  @override
  ConsumerState<SquareAvatarWidget> createState() => _SquareAvatarWidgetState();
}

class _SquareAvatarWidgetState extends ConsumerState<SquareAvatarWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return SizedBox(
      width: widget.details.length == 1
          ? 30
          : widget.details.length == 2
              ? 50
              : widget.details.length == 3
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
                  color: widget.details[0]['avatar'] != "" &&
                          widget.details[0]['avatar'] != null
                      ? Colors.transparent
                      : const Color.fromRGBO(55, 65, 80, 1),
                ),
                child: widget.details[0]['avatar'] != "" &&
                        widget.details[0]['avatar'] != null
                    ? ClipRRect(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        child: CachedNetworkImage(
                          imageUrl: widget.details[0]['avatar'],
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
                                  widget.details[0]['display_name'][0]
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
                          widget.details[0]['display_name'][0]
                              .toString()
                              .toUpperCase(),
                          type: FontStyle.Small,
                          color: Colors.white,
                          //  color: Colors.white,
                        ),
                      )),
          ),
          widget.details.length >= 2
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
                        color: widget.details[1]['avatar'] != "" &&
                                widget.details[1]['avatar'] != null
                            ? Colors.transparent
                            : const Color.fromRGBO(55, 65, 80, 1),
                      ),
                      child: widget.details[1]['avatar'] != "" &&
                              widget.details[1]['avatar'] != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(widget.borderRadius),
                              child: CachedNetworkImage(
                                imageUrl: widget.details[1]['avatar'],
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
                                        widget.details[1]['display_name'][0]
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
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        border: Border.all(
                            color:
                                themeProvider.themeManager.borderSubtle01Color,
                            width: 1),
                        color: widget.details[2]['avatar'] != "" &&
                                widget.details[2]['avatar'] != null
                            ? Colors.transparent
                            : const Color.fromRGBO(55, 65, 80, 1),
                      ),
                      child: widget.details[2]['avatar'] != "" &&
                              widget.details[2]['avatar'] != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(widget.borderRadius),
                              child: CachedNetworkImage(
                                  imageUrl: widget.details[2]['avatar'],
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
                                          widget.details[2]['display_name'][0]
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
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      border: Border.all(
                          color: themeProvider.themeManager.borderSubtle01Color,
                          width: 1),
                      color: strokeColor,
                    ),
                    child: Center(
                      child: CustomText(
                        '+${widget.details.length - 3}',
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
