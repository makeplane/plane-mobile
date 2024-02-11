// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/theme_manager.dart';
import 'package:plane/widgets/custom_text.dart';

Widget ClearFilterButton(
    {required VoidCallback onClick, required WidgetRef ref}) {
  final ThemeManager themeManager =
      ref.read(ProviderList.themeProvider).themeManager;
  return GestureDetector(
    onTap: onClick,
    // onClick();
    // state.filters = const FiltersModel();
    // state._applyFilters(context: ref.context);

    child: Container(
        height: 35,
        width: 150,
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 2),
        margin: const EdgeInsets.only(bottom: 20, top: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: themeManager.borderSubtle01Color,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              'Clear all Filters',
              type: FontStyle.Medium,
              color: themeManager.placeholderTextColor,
            ),
          ],
        )),
  );
}

Widget SaveViewButton(
    {required VoidCallback onClick,
    required bool isFilterApplied,
    required WidgetRef ref}) {
  final themeManager = ref.read(ProviderList.themeProvider).themeManager;
  return InkWell(
    onTap: onClick,
    //  state.isFilterEmpty()
    //     ? null
    //     : () {
    //         Navigator.of(ref.context).push(MaterialPageRoute(
    //             builder: (context) => CreateView(
    //                   filtersData: state.filters,
    //                   fromProjectIssues: true,
    //                 )));
    //       },
    child: Container(
        width: MediaQuery.of(ref.context).size.width * 0.42,
        height: 50,
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: !isFilterApplied
              ? themeManager.borderSubtle01Color.withOpacity(0.6)
              : themeManager.primaryColour.withOpacity(0.2),
          border: Border.all(
              color: !isFilterApplied
                  ? themeManager.placeholderTextColor
                  : themeManager.primaryColour),
          borderRadius: BorderRadius.circular(buttonBorderRadiusLarge),
        ),
        child: Center(
          child: Wrap(
            children: [
              Icon(
                Icons.add,
                color: !isFilterApplied
                    ? themeManager.placeholderTextColor
                    : themeManager.primaryColour,
                size: 24,
              ),
              CustomText(
                '  Save View',
                color: !isFilterApplied
                    ? themeManager.placeholderTextColor
                    : themeManager.primaryColour,
                fontWeight: FontWeightt.Semibold,
                type: FontStyle.Medium,
              ),
            ],
          ),
        )),
  );
}
