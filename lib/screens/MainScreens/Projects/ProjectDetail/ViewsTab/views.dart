import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/ViewsTab/views_detail.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/empty.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

class Views extends ConsumerStatefulWidget {
  const Views({super.key});

  @override
  ConsumerState<Views> createState() => _ViewsState();
}

class _ViewsState extends ConsumerState<Views> {
  int countFilters(int index) {
    var prov = ref.read(ProviderList.viewsProvider);
    int count = 0;
    prov.views[index]["query_data"].forEach((key, value) {
      if (value != null && value.isNotEmpty) count++;
    });
    return count;
  }

  @override
  Widget build(BuildContext context) {
    var viewsProvider = ref.watch(ProviderList.viewsProvider);
    return LoadingWidget(
      loading: viewsProvider.viewsState == StateEnum.loading,
      widgetClass: viewsProvider.views.isEmpty
          ? EmptyPlaceholder.emptyView(context,ref)
          : SingleChildScrollView(
              child: Column(children: [
                ListView.builder(
                    padding: const EdgeInsets.only(bottom: 0),
                    itemCount: viewsProvider.views.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      return viewsProvider.views[index]["is_favorite"] == false
                          ? Container()
                          : viewCard(index);
                    }),
                ListView.builder(
                    primary: false,
                    padding: const EdgeInsets.only(bottom: 15),
                    itemCount: viewsProvider.views.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return viewsProvider.views[index]["is_favorite"] == true
                          ? Container()
                          : viewCard(index);
                    }),
              ]),
            ),
    );
  }

  Widget viewCard(int index) {
    var viewsProvider = ref.watch(ProviderList.viewsProvider);
    var themeProvider = ref.read(ProviderList.themeProvider);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => ViewsDetail(
                      index: index,
                    )));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        decoration: BoxDecoration(
            color: themeProvider.isDarkThemeEnabled
                ? darkBackgroundColor
                : lightBackgroundColor,
            border: Border.all(
                color: themeProvider.isDarkThemeEnabled
                    ? darkThemeBorder
                    : strokeColor),
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
                    child: SvgPicture.asset(
                      "assets/svg_images/view_card.svg",
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                          themeProvider.isDarkThemeEnabled
                              ? greyColor
                              : Colors.black,
                          BlendMode.srcIn),
                    )),

                Container(
                  margin: const EdgeInsets.only(left: 5),
                  width: MediaQuery.sizeOf(context).width - 200,
                  padding: const EdgeInsets.only(left: 5, right: 15, top: 20),
                  child: CustomText(
                    viewsProvider.views[index]["name"],
                    type: FontStyle.H5,
                    fontWeight: FontWeightt.Medium,
                  ),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 3, bottom: 3),
                  color: themeProvider.isDarkThemeEnabled
                      ? darkThemeBorder
                      : const Color.fromARGB(255, 218, 220, 223),
                  height: 28,
                  child: Center(
                    child: CustomText('${countFilters(index)} Filters',
                        type: FontStyle.XSmall,
                        color: themeProvider.isDarkThemeEnabled
                            ? greyColor
                            : const Color.fromRGBO(73, 80, 87, 1)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ref
                        .read(ProviderList.viewsProvider.notifier)
                        .favouriteViews(
                            index: index,
                            method: viewsProvider.views[index]["is_favorite"] ==
                                    false
                                ? HttpMethod.post
                                : HttpMethod.delete);
                    viewsProvider.views[index]["is_favorite"] =
                        !viewsProvider.views[index]["is_favorite"];
                    setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, left: 10, right: 10),
                    child: viewsProvider.views[index]["is_favorite"] == false
                        ? const Icon(
                            Icons.star_border,
                            color: Color.fromRGBO(172, 181, 189, 1),
                          )
                        : const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            //description

            viewsProvider.views[index]["description"] == null ||
                    viewsProvider.views[index]["description"].isEmpty
                ? Container(
                    height: 8,
                  )
                : Container(
                    margin: const EdgeInsets.only(left: 25),
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: CustomText(
                      viewsProvider.views[index]["description"] ?? '',
                      type: FontStyle.Medium,
                      color: themeProvider.themeManager.secondaryTextColor,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
