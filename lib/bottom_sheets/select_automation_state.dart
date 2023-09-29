import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane/provider/provider_list.dart';
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
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 23, left: 23, right: 23),
      child: Wrap(
        children: [
          Row(
            children: [
              const CustomText(
                'Select Duration',
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
            itemCount: issuesProvider.statesData['cancelled'].length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 50,
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    projectProvider.currentProject['default_state'] =
                        issuesProvider.statesData['cancelled'][index]['id'];
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
                          'default_state': issuesProvider
                              .statesData['cancelled'][index]['id'],
                        });

                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/svg_images/cancelled.svg',
                        colorFilter: ColorFilter.mode(
                            issuesProvider.statesData['cancelled'][index]
                                        ['color'][0] !=
                                    '#'
                                ? Color(int.parse("FF3A3A3A", radix: 16))
                                : Color(int.parse(
                                    "FF${issuesProvider.statesData['cancelled'][index]['color'].replaceAll('#', '')}",
                                    radix: 16)),
                            BlendMode.srcIn),
                        height: 22,
                        width: 22,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomText(
                        issuesProvider.statesData['cancelled'][index]['name'],
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
