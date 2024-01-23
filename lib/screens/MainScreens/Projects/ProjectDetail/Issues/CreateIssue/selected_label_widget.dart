import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/extensions/string_extensions.dart';
import 'package:plane/widgets/custom_text.dart';

class SelectedLabelsWidget extends ConsumerWidget {
  const SelectedLabelsWidget({required this.selectedLabels, super.key});

  final List selectedLabels;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Row(
      children: [
        SizedBox(
          child: selectedLabels.length == 1
              ? CircleAvatar(
                  radius: 7,
                  backgroundColor:
                      selectedLabels[0]['color'].toString().toColor(),
                )
              : selectedLabels.length == 2
                  ? SizedBox(
                      width: 40,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Positioned(
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor: selectedLabels[0]['color']
                                  .toString()
                                  .toColor(),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            child: CircleAvatar(
                              radius: 8,
                              backgroundColor: themeProvider
                                  .themeManager.primaryBackgroundDefaultColor,
                              child: CircleAvatar(
                                radius: 7,
                                backgroundColor: selectedLabels[1]['color']
                                    .toString()
                                    .toColor(),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : selectedLabels.length == 3
                      ? SizedBox(
                          width: 60,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Positioned(
                                child: CircleAvatar(
                                  radius: 7,
                                  backgroundColor: selectedLabels[0]['color']
                                      .toString()
                                      .toColor(),
                                ),
                              ),
                              Positioned(
                                left: 30,
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: themeProvider.themeManager
                                      .primaryBackgroundDefaultColor,
                                  child: CircleAvatar(
                                    radius: 7,
                                    backgroundColor: selectedLabels[1]['color']
                                        .toString()
                                        .toColor(),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 40,
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: themeProvider.themeManager
                                      .primaryBackgroundDefaultColor,
                                  child: CircleAvatar(
                                    radius: 7,
                                    backgroundColor: selectedLabels[2]['color']
                                        .toString()
                                        .toColor(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : selectedLabels.length >= 4
                          ? fourCirclesWidget(ref: ref)
                          : Container(),
        ),
        const SizedBox(
          width: 5,
        ),
        CustomText(
          selectedLabels.length == 1
              ? '${selectedLabels.length} Label'
              : '${selectedLabels.length} Labels',
          type: FontStyle.Small,
        )
      ],
    );
  }

  Widget fourCirclesWidget({required WidgetRef ref}) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return SizedBox(
      width: 65,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CircleAvatar(
            radius: 7,
            backgroundColor: selectedLabels[0]['color'].toString().toColor(),
          ),
          Positioned(
            left: 30,
            child: CircleAvatar(
              radius: 8,
              backgroundColor:
                  themeProvider.themeManager.primaryBackgroundDefaultColor,
              child: CircleAvatar(
                radius: 7,
                backgroundColor:
                    selectedLabels[1]['color'].toString().toColor(),
              ),
            ),
          ),
          Positioned(
            left: 40,
            child: CircleAvatar(
              radius: 8,
              backgroundColor:
                  themeProvider.themeManager.primaryBackgroundDefaultColor,
              child: CircleAvatar(
                radius: 7,
                backgroundColor:
                    selectedLabels[2]['color'].toString().toColor(),
              ),
            ),
          ),
          Positioned(
            left: 50,
            child: CircleAvatar(
              radius: 8,
              backgroundColor:
                  themeProvider.themeManager.primaryBackgroundDefaultColor,
              child: CircleAvatar(
                radius: 7,
                backgroundColor:
                    selectedLabels[3]['color'].toString().toColor(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
