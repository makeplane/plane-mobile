import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/core/extensions/string_extensions.dart';
import 'package:plane/widgets/custom_text.dart';

import '../utils/enums.dart';

class SelectAutomationState extends ConsumerStatefulWidget {
  const SelectAutomationState({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectAutomationStateState();
}

class _SelectAutomationStateState extends ConsumerState<SelectAutomationState> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final statesProvider = ref.watch(ProviderList.statesProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 23, left: 23, right: 23),
      child: Wrap(
        children: [
          Row(
            children: [
              const CustomText(
                'Select State',
                type: FontStyle.H6,
                fontWeight: FontWeightt.Semibold,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  size: 27,
                  color: themeProvider.themeManager.placeholderTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),

          //list of durations
          ListView.separated(
            itemCount: statesProvider.stateGroups['cancelled']!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: bottomSheetConstBottomPadding),
            itemBuilder: (context, index) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 50,
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    projectProvider.currentProject['default_state'] =
                        statesProvider.stateGroups['cancelled']![index].id;
                    projectProvider.setState();
                    projectProvider.updateProject(
                        slug: ref
                            .read(ProviderList.workspaceProvider)
                            .selectedWorkspace
                            .workspaceSlug,
                        projId: ref
                            .read(ProviderList.projectProvider)
                            .currentProject['id'],
                        ref: ref,
                        data: {
                          'default_state': statesProvider.stateGroups['cancelled']![index].id
                        });

                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/svg_images/cancelled.svg',
                        colorFilter: ColorFilter.mode(
                           statesProvider.stateGroups['cancelled']![index].color.toColor(),
                            BlendMode.srcIn),
                        height: 22,
                        width: 22,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomText(
                        statesProvider.stateGroups['cancelled']![index].name,
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Container(
                height: 1,
                width: double.infinity,
                color: themeProvider.themeManager.borderSubtle01Color,
              );
            },
          )
        ],
      ),
    );
  }
}
