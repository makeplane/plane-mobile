// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/core/extensions/string_extensions.dart';
import 'package:plane/widgets/custom_text.dart';

class LabelsDProperty extends ConsumerWidget {
  const LabelsDProperty({required this.label_ids, super.key});
  final List<String> label_ids;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
    final labelProvider = ref.read(ProviderList.labelProvider);
    return label_ids.length == 1
        ? Container(
            width: 80,
            margin: const EdgeInsets.only(right: 5),
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            decoration: BoxDecoration(
                border: Border.all(
                  color: themeManager.borderSubtle01Color,
                ),
                borderRadius: BorderRadius.circular(4)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 5,
                  backgroundColor:
                      (labelProvider.projectLabels[label_ids[0]])!
                          .color
                          .toColor(),
                ),
                const SizedBox(
                  width: 5,
                ),
                CustomText(
                  '${label_ids.length} Labels',
                  type: FontStyle.XSmall,
                  height: 1,
                  color: themeManager.tertiaryTextColor,
                ),
              ],
            ),
          )
        : Container(
            margin: const EdgeInsets.only(right: 5),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: label_ids.length,
              itemBuilder: (context, idx) {
                final label = labelProvider.projectLabels.values.elementAt(idx);
                return Container(
                  height: 30,
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: themeManager.borderSubtle01Color),
                      borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: label.color.toColor(),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 120),
                        child: CustomText(
                          label.name,
                          type: FontStyle.XSmall,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          height: 1,
                          color: themeManager.tertiaryTextColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }
}
