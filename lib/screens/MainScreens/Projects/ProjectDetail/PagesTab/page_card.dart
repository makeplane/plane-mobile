import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/PagesTab/page_detail.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';


class PageCard extends ConsumerStatefulWidget {
  const PageCard({super.key});

  @override
  ConsumerState<PageCard> createState() => _PageCardState();
}

class _PageCardState extends ConsumerState<PageCard> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const PageDetail();
        }));
      },
      child: Container(
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
                    Icons.edit_document,
                    color: themeProvider.isDarkThemeEnabled
                        ? darkPrimaryTextColor
                        : lightPrimaryTextColor,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(left: 5, right: 15, top: 20),
                  child: const CustomText(
                    'Page Title',
                    type: FontStyle.boldTitle,
                  ),
                ),
                const Spacer(),
                // Container(
                //   margin: const EdgeInsets.only(top: 15),
                //   padding: const EdgeInsets.only(
                //       left: 10, right: 10, top: 3, bottom: 3),
                //   color: Color.fromARGB(255, 218, 220, 223),
                //   height: 28,
                //   child: Center(
                //     child: CustomText('2 Filters',
                //         type: FontStyle.subtitle,
                //         color: const Color.fromRGBO(73, 80, 87, 1)),
                //   ),
                // ),
                // Container(
                //   margin: const EdgeInsets.only(top: 12, left: 10, right: 10),
                //   child: const Icon(
                //     Icons.star_border,
                //     color: Color.fromRGBO(172, 181, 189, 1),
                //   ),
                // )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            //description
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 25),
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: const CustomText(
                    'description',
                    type: FontStyle.description,
                  ),
                ),
                const Spacer(),

                //three small icons
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const Icon(
                    Icons.lock_open_outlined,
                    size: 16,
                    color: Color.fromRGBO(172, 181, 189, 1),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: Color.fromRGBO(172, 181, 189, 1),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const Icon(
                    Icons.star_border,
                    size: 16,
                    color: Color.fromRGBO(172, 181, 189, 1),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
