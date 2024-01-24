import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/member_logo_widget.dart';

Widget assigneeWidget({required WidgetRef ref, required Map detailData}) {
  final themeProvider = ref.watch(ProviderList.themeProvider);

  return Container(
    height: 45,
    width: double.infinity,
    decoration: BoxDecoration(
      color: themeProvider.themeManager.primaryBackgroundDefaultColor,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        color: themeProvider.themeManager.borderSubtle01Color,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //icon
          Icon(
            //two people icon
            Icons.people_outline_outlined,
            color: themeProvider.themeManager.placeholderTextColor,
          ),
          const SizedBox(width: 15),
          CustomText(
            'Lead',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Regular,
            color: themeProvider.themeManager.placeholderTextColor,
          ),
          const Spacer(),
          detailData['owned_by'] == null
              ? CustomText(
                  'No lead',
                  type: FontStyle.Medium,
                  fontWeight: FontWeightt.Regular,
                  color: themeProvider.themeManager.primaryTextColor,
                )
              : Row(
                  children: [
                    MemberLogoWidget(
                      fontType: FontStyle.Small,
                      boarderRadius: 50,
                      padding: EdgeInsets.zero,
                      size: 25,
                      imageUrl: (detailData['owned_by']['avatar']),
                      colorForErrorWidget: const Color.fromRGBO(55, 65, 81, 1),
                      memberNameFirstLetterForErrorWidget:
                          detailData['owned_by']['display_name'][0].toString(),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      constraints: BoxConstraints(maxWidth: width * 0.4),
                      child: CustomText(
                        (detailData['owned_by'] != null &&
                                detailData['owned_by']['display_name'] != null)
                            ? detailData['owned_by']['display_name'] ?? ''
                            : '',
                        type: FontStyle.Small,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    ),
  );
}
