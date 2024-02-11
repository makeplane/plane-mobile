import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/utils/constants.dart';

import 'package:plane/utils/enums.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/member_logo_widget.dart';

class LeadSheet extends ConsumerStatefulWidget {
  const LeadSheet({
    this.selectedLeadId,
    required this.onLeadSelect,
    super.key,
  });
  final VoidCallback onLeadSelect;
  final String? selectedLeadId;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeadSheetState();
}

class _LeadSheetState extends ConsumerState<LeadSheet> {
  String? selectedLeadId;

  @override
  void initState() {
    selectedLeadId = widget.selectedLeadId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.themeManager.primaryBackgroundDefaultColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
      ),
      width: double.infinity,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Wrap(
              children: [
                Row(
                  children: [
                    const CustomText(
                      'Lead',
                      type: FontStyle.H4,
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
                  height: 20,
                ),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  child: ListView.builder(
                    padding:
                        EdgeInsets.only(bottom: bottomSheetConstBottomPadding),
                    itemCount: projectProvider.projectMembers.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: widget.onLeadSelect,
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                            color: themeProvider
                                .themeManager.primaryBackgroundDefaultColor,
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                  height: 30,
                                  width: 30,
                                  alignment: Alignment.center,
                                  child: MemberLogoWidget(
                                      size: 30,
                                      boarderRadius: 50,
                                      padding: EdgeInsets.zero,
                                      imageUrl:
                                          projectProvider.projectMembers[index]
                                              ['member']['avatar'],
                                      colorForErrorWidget:
                                          const Color.fromRGBO(55, 65, 81, 1),
                                      memberNameFirstLetterForErrorWidget:
                                          projectProvider.projectMembers[index]
                                                  ['member']['first_name'][0]
                                              .toString())),
                              Container(
                                width: 10,
                              ),
                              CustomText(
                                projectProvider.projectMembers[index]['member']
                                        ['first_name'] +
                                    " " +
                                    projectProvider.projectMembers[index]
                                        ['member']['last_name'],
                                type: FontStyle.Small,
                              ),
                              const Spacer(),
                              selectedLeadId ==
                                      projectProvider.projectMembers[index]
                                          ['member']['id']
                                  ? const Icon(
                                      Icons.done,
                                      color: Color.fromRGBO(8, 171, 34, 1),
                                    )
                                  : Container(),
                              const SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
