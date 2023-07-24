import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';


class LabelSheet extends ConsumerStatefulWidget {
  const LabelSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LabelSheetState();
}

class _LabelSheetState extends ConsumerState<LabelSheet> {
  List<String> tags = [
    'Label 1',
    'Label 2',
    'Label 3',
    'Label 4',
    'Label 5',
    'Label 6',
    'Label 7',
    'Label 8',
    'Label 9',
  ];
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      padding: const EdgeInsets.only(top: 23, left: 23, right: 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //text heading

          const CustomText(
            'Add Label',
            type: FontStyle.heading,
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              // Text(
              //   'View Title',
              //   style: TextStyle(
              //     fontSize: 15,
              //     fontWeight: FontWeight.w400,
              //     color: themeProvider.secondaryTextColor,
              //   ),
              // ),
              CustomText(
                'Search',
                type: FontStyle.text,
                // color: themeProvider.secondaryTextColor,
              ),
              // const Text(
              //   ' *',
              //   style: TextStyle(
              //     fontSize: 15,
              //     fontWeight: FontWeight.w400,
              //     color: Colors.red,
              //   ),
              // ),
              CustomText(
                ' *',
                type: FontStyle.title,
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 5),
          TextField(
            decoration: kTextFieldDecoration.copyWith(
              fillColor: themeProvider.isDarkThemeEnabled
                  ? darkBackgroundColor
                  : lightBackgroundColor,
              filled: true,
            ),
          ),
          const SizedBox(height: 20),
          // Text(
          //   'Description',
          //   style: TextStyle(
          //     fontSize: 15,
          //     fontWeight: FontWeight.w400,
          //     color: themeProvider.secondaryTextColor,
          //   ),
          // ),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: tags.map((tag) {
              return Container(
                height: 35,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color.fromARGB(255, 193, 192, 192),
                  ),
                ),
                // child: Text(
                //   tag,
                //   style: const TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
                child: CustomText(
                  tag,
                  type: FontStyle.smallText,
                ),
              );
            }).toList(),
          ),
          const Spacer(),
          const Button(
            text: 'Add Label',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
