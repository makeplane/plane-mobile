import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class ViewCard extends ConsumerStatefulWidget {
  const ViewCard({super.key});

  @override
  ConsumerState<ViewCard> createState() => _ViewCardState();
}

class _ViewCardState extends ConsumerState<ViewCard> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
          color: themeProvider.isDarkThemeEnabled
              ? darkBackgroundColor
              : lightBackgroundColor,
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          //elevation
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //icon of cards stacked on each other
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 20),
                child: Icon(
                  Icons.view_agenda,
                  color: themeProvider.isDarkThemeEnabled
                      ? darkPrimaryTextColor
                      : lightPrimaryTextColor,
                ),
              ),

              Container(
                padding: const EdgeInsets.only(left: 5, right: 15, top: 20),
                child: const CustomText(
                  'Testing',
                  type: FontStyle.boldTitle,
                ),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(top: 15),
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 3, bottom: 3),
                color: const Color.fromARGB(255, 218, 220, 223),
                height: 28,
                child: const Center(
                  child: CustomText('2 Filters',
                      type: FontStyle.subtitle,
                      color: Color.fromRGBO(73, 80, 87, 1)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 12, left: 10, right: 10),
                child: const Icon(
                  Icons.star_border,
                  color: Color.fromRGBO(172, 181, 189, 1),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          //description
          Container(
            margin: const EdgeInsets.only(left: 25),
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: const CustomText(
              'description',
              type: FontStyle.description,
            ),
          ),
        ],
      ),
    );
  }
}
