import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane_startup/bottom_sheets/delete_cycle_sheet.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/ViewsTab/views_detail.dart';
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
          ? EmptyPlaceholder.emptyView(context, ref)
          : SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 16),
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
            boxShadow: themeProvider.themeManager.theme == THEME.light
                ? themeProvider.themeManager.shadowXXS
                : null,
            color: themeProvider.themeManager.primaryBackgroundDefaultColor,
            border: themeProvider.themeManager.theme == THEME.light
                ? null
                : Border.all(
                    color: themeProvider.themeManager.borderSubtle01Color,
                    width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //icon of cards stacked on each other
                Padding(
                    padding: const EdgeInsets.only(left: 15, top: 16),
                    child: SvgPicture.asset(
                      "assets/svg_images/view_card.svg",
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                          themeProvider.themeManager.primaryTextColor,
                          BlendMode.srcIn),
                    )),

                Container(
                  margin: const EdgeInsets.only(left: 5),
                  width: MediaQuery.sizeOf(context).width - 250,
                  padding: const EdgeInsets.only(left: 5, right: 15, top: 15),
                  child: CustomText(
                    viewsProvider.views[index]["name"],
                    type: FontStyle.H6,
                    fontWeight: FontWeightt.Medium,
                    color: themeProvider.themeManager.primaryTextColor,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 3, bottom: 3),
                      color: themeProvider
                          .themeManager.tertiaryBackgroundDefaultColor,
                      height: 28,
                      child: Center(
                        child: CustomText('${countFilters(index)} Filters',
                            type: FontStyle.XSmall,
                            color:
                                themeProvider.themeManager.tertiaryTextColor),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(ProviderList.viewsProvider.notifier)
                            .favouriteViews(
                                index: index,
                                method: viewsProvider.views[index]
                                            ["is_favorite"] ==
                                        false
                                    ? HttpMethod.post
                                    : HttpMethod.delete);
                        viewsProvider.views[index]["is_favorite"] =
                            !viewsProvider.views[index]["is_favorite"];
                        setState(() {});
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 12, left: 10, right: 10),
                        child:
                            viewsProvider.views[index]["is_favorite"] == false
                                ? Icon(
                                    Icons.star_border,
                                    color: themeProvider
                                        .themeManager.placeholderTextColor,
                                  )
                                : Icon(
                                    Icons.star,
                                    color: themeProvider
                                        .themeManager.tertiaryTextColor,
                                  ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          enableDrag: true,
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.50),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          context: context,
                          builder: (ctx) {
                            return DeleteCycleSheet(
                              name: viewsProvider.views[index]["name"],
                              id: viewsProvider.views[index]["id"],
                              type: 'View',
                              index: index,
                            );
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 12, right: 10),
                        child: Icon(
                          Icons.more_vert,
                          color:
                              themeProvider.themeManager.placeholderTextColor,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            //description

            viewsProvider.views[index]["description"] == null ||
                    viewsProvider.views[index]["description"].isEmpty
                ? Container()
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
