// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class EstimateDProperty extends ConsumerWidget {
  const EstimateDProperty({this.estimate_point, super.key});
  final String? estimate_point;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
    final projectProvider = ref.read(ProviderList.projectProvider);
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 5),
      height: 30,
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      decoration: BoxDecoration(
          border: Border.all(
            color: themeManager.borderSubtle01Color,
          ),
          borderRadius: BorderRadius.circular(4)),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            Icons.change_history,
            size: 18,
            color: themeManager.tertiaryTextColor,
          ),
          const SizedBox(
            width: 5,
          ),
          CustomText(
            estimate_point != '' && estimate_point != null
                ? ref
                    .read(ProviderList.estimatesProvider)
                    .estimates
                    .firstWhere((element) {
                    return element['id'] ==
                        projectProvider.currentProject['estimate'];
                  })['points'].firstWhere((element) {
                    return element['key'] == estimate_point;
                  })['value']
                : 'Estimate',
            type: FontStyle.XSmall,
            height: 1,
            color: themeManager.tertiaryTextColor,
          ),
        ],
      ),
    );
  }
}
