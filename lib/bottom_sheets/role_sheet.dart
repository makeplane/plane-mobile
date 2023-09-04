import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';

import '../utils/enums.dart';

class RoleSheet extends ConsumerStatefulWidget {
  const RoleSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RoleSheetState();
}

class _RoleSheetState extends ConsumerState<RoleSheet> {
  List<String> dropDownItems = [
    'Founder or learship team',
    'Product manager',
    'Designer',
    'Software developer',
    'Freelancer',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    var profileProvider = ref.watch(ProviderList.profileProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 23, left: 23, right: 23),
      child: Wrap(
        children: [
          Row(
            children: [
              CustomText(
                'Role',
                type: FontStyle.H6,
                fontWeight: FontWeightt.Semibold,
                color: themeProvider.themeManager.primaryTextColor,
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
          SizedBox(
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                profileProvider.changeIndex(0);
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: profileProvider.roleIndex == 0
                          ? null
                          : MaterialStateProperty.all<Color>(
                              themeProvider.themeManager.borderSubtle01Color,
                            ),
                      groupValue: profileProvider.dropDownValue,
                      activeColor: themeProvider.themeManager.primaryColour,
                      value: dropDownItems[0],
                      onChanged: (val) {
                        profileProvider.changeIndex(0);
                        Navigator.pop(context);
                      }),

                  // Text(
                  //   'Board View',
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  // ),
                  const SizedBox(width: 10),
                  CustomText(
                    dropDownItems[0],
                    type: FontStyle.Small,
                    color: themeProvider.themeManager.tertiaryTextColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Container(
              color: themeProvider.themeManager.borderDisabledColor,
            ),
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                profileProvider.changeIndex(1);
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: profileProvider.roleIndex == 1
                          ? null
                          : MaterialStateProperty.all<Color>(
                              themeProvider.themeManager.borderSubtle01Color),
                      groupValue: profileProvider.dropDownValue,
                      activeColor: themeProvider.themeManager.primaryColour,
                      value: dropDownItems[1],
                      onChanged: (val) {
                        profileProvider.changeIndex(1);
                        Navigator.pop(context);
                      }),
                  const SizedBox(width: 10),
                  CustomText(
                    dropDownItems[1],
                    type: FontStyle.Small,
                    color: themeProvider.themeManager.tertiaryTextColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Container(
              color: themeProvider.themeManager.borderDisabledColor,
            ),
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                profileProvider.changeIndex(2);
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: profileProvider.roleIndex == 2
                          ? null
                          : MaterialStateProperty.all<Color>(
                              themeProvider.themeManager.borderSubtle01Color,
                            ),
                      groupValue: profileProvider.dropDownValue,
                      activeColor: themeProvider.themeManager.primaryColour,
                      value: dropDownItems[2],
                      onChanged: (val) {
                        profileProvider.changeIndex(2);
                        Navigator.pop(context);
                      }),
                  const SizedBox(width: 10),
                  CustomText(
                    dropDownItems[2],
                    type: FontStyle.Small,
                    color: themeProvider.themeManager.tertiaryTextColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Container(
              color: themeProvider.themeManager.borderDisabledColor,
            ),
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                profileProvider.changeIndex(3);

                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: profileProvider.roleIndex == 3
                          ? null
                          : MaterialStateProperty.all<Color>(
                              themeProvider.themeManager.borderSubtle01Color),
                      groupValue: profileProvider.dropDownValue,
                      activeColor: themeProvider.themeManager.primaryColour,
                      value: dropDownItems[3],
                      onChanged: (val) {
                        profileProvider.changeIndex(3);

                        Navigator.pop(context);
                      }),
                  const SizedBox(width: 10),
                  CustomText(
                    dropDownItems[3],
                    type: FontStyle.Small,
                    color: themeProvider.themeManager.tertiaryTextColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Container(
              color: themeProvider.themeManager.borderDisabledColor,
            ),
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                profileProvider.changeIndex(4);
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: profileProvider.roleIndex == 4
                          ? null
                          : MaterialStateProperty.all<Color>(
                              themeProvider.themeManager.borderSubtle01Color),
                      groupValue: profileProvider.dropDownValue,
                      activeColor: themeProvider.themeManager.primaryColour,
                      value: dropDownItems[4],
                      onChanged: (val) {
                        profileProvider.changeIndex(4);
                        Navigator.pop(context);
                      }),
                  const SizedBox(width: 10),
                  CustomText(
                    dropDownItems[4],
                    type: FontStyle.Small,
                    color: themeProvider.themeManager.tertiaryTextColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Container(
              color: themeProvider.themeManager.borderDisabledColor,
            ),
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                profileProvider.changeIndex(5);
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: profileProvider.roleIndex == 5
                          ? null
                          : MaterialStateProperty.all<Color>(
                              themeProvider.themeManager.borderSubtle01Color),
                      groupValue: profileProvider.dropDownValue,
                      activeColor: themeProvider.themeManager.primaryColour,
                      value: dropDownItems[5],
                      onChanged: (val) {
                        profileProvider.changeIndex(5);
                        Navigator.pop(context);
                      }),
                  const SizedBox(width: 10),
                  CustomText(
                    dropDownItems[5],
                    type: FontStyle.Small,
                    color: themeProvider.themeManager.tertiaryTextColor,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
