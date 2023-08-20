import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_divider.dart';
import 'package:plane_startup/widgets/custom_text.dart';

import '../utils/enums.dart';

class FilterPageSheet extends ConsumerStatefulWidget {
  const FilterPageSheet({super.key});

  @override
  ConsumerState<FilterPageSheet> createState() => _FilterPageSheetState();
}

class _FilterPageSheetState extends ConsumerState<FilterPageSheet> {
  void selectFilter(PageFilters filter) {
    setState(() {
      ref.read(ProviderList.pageProvider).selectedFilter = filter;
    });
    ref.read(ProviderList.pageProvider).updatepageList(
          slug: ref
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace!
              .workspaceSlug,
          projectId:
              ref.read(ProviderList.projectProvider).currentProject['id'],
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var pageProvider = ref.watch(ProviderList.pageProvider);
    log(pageProvider.selectedFilter.name);
    return Container(
      padding: const EdgeInsets.only(top: 23, left: 23, right: 23),
      child: Wrap(children: [
        Row(
          children: [
            const CustomText(
              'Filters',
              type: FontStyle.H6,
              fontWeight: FontWeightt.Semibold,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: themeProvider.themeManager.placeholderTextColor,
              ),
            )
          ],
        ),
        Container(height: 15),
        InkWell(
          onTap: () async {
            selectFilter(PageFilters.all);
          },
          child: Row(
            children: [
              Radio(
                activeColor: themeProvider.themeManager.primaryColour,
                fillColor: pageProvider.selectedFilter.name == 'all'
                    ? null
                    : MaterialStateProperty.all<Color>(
                        themeProvider.themeManager.borderSubtle01Color),
                value: 'all',
                groupValue: pageProvider.selectedFilter.name,
                onChanged: (value) {},
              ),
              CustomText(
                'All',
                type: FontStyle.Small,
                color: themeProvider.themeManager.tertiaryTextColor,
              )
            ],
          ),
        ),
        CustomDivider(themeProvider: themeProvider),
        InkWell(
          onTap: () async {
            selectFilter(PageFilters.recent);
          },
          child: Row(
            children: [
              Radio(
                fillColor: pageProvider.selectedFilter.name == 'recent'
                    ? null
                    : MaterialStateProperty.all<Color>(
                        themeProvider.themeManager.borderSubtle01Color),
                activeColor: themeProvider.themeManager.primaryColour,
                value: 'recent',
                groupValue: pageProvider.selectedFilter.name,
                onChanged: (value) {},
              ),
              CustomText(
                'Recent',
                type: FontStyle.Small,
                color: themeProvider.themeManager.tertiaryTextColor,
              )
            ],
          ),
        ),
        CustomDivider(themeProvider: themeProvider),
        InkWell(
          onTap: () async {
            selectFilter(PageFilters.favourites);
          },
          child: Row(
            children: [
              Radio(
                fillColor: pageProvider.selectedFilter.name == 'favourites'
                    ? null
                    : MaterialStateProperty.all<Color>(
                        themeProvider.themeManager.borderSubtle01Color),
                activeColor: themeProvider.themeManager.primaryColour,
                value: 'favourites',
                groupValue: pageProvider.selectedFilter.name,
                onChanged: (value) {},
              ),
              CustomText(
                'Favourites',
                type: FontStyle.Small,
                color: themeProvider.themeManager.tertiaryTextColor,
              )
            ],
          ),
        ),
        CustomDivider(themeProvider: themeProvider),
        InkWell(
          onTap: () async {
            selectFilter(PageFilters.createdByMe);
          },
          child: Row(
            children: [
              Radio(
                fillColor: pageProvider.selectedFilter.name == 'createdByMe'
                    ? null
                    : MaterialStateProperty.all<Color>(
                        themeProvider.themeManager.borderSubtle01Color),
                activeColor: themeProvider.themeManager.primaryColour,
                value: 'createdByMe',
                groupValue: pageProvider.selectedFilter.name,
                onChanged: (value) {},
              ),
              CustomText(
                'CreatedByMe',
                type: FontStyle.Small,
                color: themeProvider.themeManager.tertiaryTextColor,
              )
            ],
          ),
        ),
        CustomDivider(themeProvider: themeProvider),
        InkWell(
          onTap: () async {
            selectFilter(PageFilters.createdByOthers);
          },
          child: Row(
            children: [
              Radio(
                fillColor: pageProvider.selectedFilter.name == 'createdByOthers'
                    ? null
                    : MaterialStateProperty.all<Color>(
                        themeProvider.themeManager.borderSubtle01Color),
                activeColor: themeProvider.themeManager.primaryColour,
                value: 'createdByOthers',
                groupValue: pageProvider.selectedFilter.name,
                onChanged: (value) {},
              ),
              CustomText(
                'CreatedByOthers',
                type: FontStyle.Small,
                color: themeProvider.themeManager.tertiaryTextColor,
              )
            ],
          ),
        ),
        Container(height: 15),
      ]),
    );
  }
}
