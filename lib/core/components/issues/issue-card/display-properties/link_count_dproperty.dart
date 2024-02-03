import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class LinkCountDProperty extends ConsumerWidget {
  const LinkCountDProperty({required this.linkCount, super.key});
  final int linkCount;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 5),
      height: 30,
      padding: const EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
          border: Border.all(color: themeManager.borderSubtle01Color),
          borderRadius: BorderRadius.circular(4)),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Transform.rotate(
            angle: 33.6,
            child: Icon(
              Icons.link,
              size: 18,
              color: themeManager.tertiaryTextColor,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          CustomText(
            linkCount.toString(),
            type: FontStyle.XSmall,
            height: 1,
            color: themeManager.tertiaryTextColor,
          ),
        ],
      ),
    );
  }
}
