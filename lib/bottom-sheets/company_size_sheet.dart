import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_divider.dart';
import 'package:plane/widgets/custom_text.dart';

import '../utils/enums.dart';

class CompanySize extends ConsumerStatefulWidget {
  const CompanySize({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CompanySizeState();
}

class _CompanySizeState extends ConsumerState<CompanySize> {
  final List<String> companySizeData = [
    "Just myself",
    "2-10",
    "11-50",
    "51-200",
    "201-500",
    "500+"
  ];
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    return Padding(
      padding: const EdgeInsets.all(23),
      child: Column(
        children: [
          Row(
            children: [
              CustomText(
                'Company Size',
                type: FontStyle.H4,
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
          Expanded(
            child: ListView.separated(
              itemCount: companySizeData.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 50,
                  child: InkWell(
                    onTap: () {
                      workspaceProvider.changeCompanySize(
                          size: companySizeData[index]);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          workspaceProvider.companySize ==
                                  companySizeData[index]
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: workspaceProvider.companySize ==
                                  companySizeData[index]
                              ? themeProvider.themeManager.primaryColour
                              : themeProvider.themeManager.borderSubtle01Color,
                        ),
                        const SizedBox(width: 10),
                        CustomText(
                          companySizeData[index],
                          type: FontStyle.Medium,
                          fontWeight: FontWeightt.Regular,
                          color: themeProvider.themeManager.primaryTextColor,
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return CustomDivider(
                    themeProvider: themeProvider,
                    color: themeProvider.themeManager.borderDisabledColor);
              },
            ),
          ),
        ],
      ),
    );
  }
}
