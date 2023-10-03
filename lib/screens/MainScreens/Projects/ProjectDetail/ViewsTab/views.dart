import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plane/bottom_sheets/delete_cycle_sheet.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/ViewsTab/views_detail.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/empty.dart';
import 'package:plane/widgets/loading_widget.dart';

class Views extends ConsumerStatefulWidget {
  const Views({super.key});

  @override
  ConsumerState<Views> createState() => _ViewsState();
}

class _ViewsState extends ConsumerState<Views> {
  int countFilters(int index) {
    final prov = ref.read(ProviderList.viewsProvider);
    int count = 0;
    prov.views[index]["query_data"].forEach((key, value) {
      if (value != null && value.isNotEmpty) count++;
    });
    return count;
  }

  EdgeInsets favouriteTextPadding =
      const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 20);

  @override
  Widget build(BuildContext context) {
    final viewsProvider = ref.watch(ProviderList.viewsProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return LoadingWidget(
      loading: viewsProvider.viewsState == StateEnum.loading,
      widgetClass: viewsProvider.views.isEmpty
          ? EmptyPlaceholder.emptyView(context, ref)
          : SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isThereFavouriteView(viewsProvider.views) &&
                            isThereUnFavouriteView(viewsProvider.views)
                        ? Padding(
                            padding: favouriteTextPadding,
                            child: CustomText(
                              'Favourite',
                              type: FontStyle.Medium,
                              fontWeight: FontWeightt.Medium,
                              color: themeProvider
                                  .themeManager.placeholderTextColor,
                            ),
                          )
                        : Container(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                            itemCount: viewsProvider.views.length,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              return viewsProvider.views[index]
                                          ["is_favorite"] ==
                                      false
                                  ? Container()
                                  : viewCard(index);
                            }),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isThereFavouriteView(viewsProvider.views) &&
                                isThereUnFavouriteView(viewsProvider.views)
                            ? Padding(
                                padding: favouriteTextPadding,
                                child: CustomText(
                                  'All Views',
                                  type: FontStyle.Medium,
                                  fontWeight: FontWeightt.Medium,
                                  color: themeProvider
                                      .themeManager.placeholderTextColor,
                                ),
                              )
                            : Container(),
                        ListView.builder(
                            primary: false,
                            padding: const EdgeInsets.only(bottom: 15),
                            itemCount: viewsProvider.views.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return viewsProvider.views[index]
                                          ["is_favorite"] ==
                                      true
                                  ? Container()
                                  : viewCard(index);
                            }),
                      ],
                    ),
                  ]),
            ),
    );
  }

  bool isThereFavouriteView(List<dynamic>? views) {
    if (views == null) {
      return false;
    } else {
      for (final item in views) {
        if (item["is_favorite"] == true) {
          return true;
        }
      }
      return false;
    }
  }

  bool isThereUnFavouriteView(List<dynamic>? views) {
    if (views == null) {
      return false;
    } else {
      for (final item in views) {
        if (item["is_favorite"] == false) {
          return true;
        }
      }
      return false;
    }
  }

  Widget viewCard(int index) {
    final viewsProvider = ref.watch(ProviderList.viewsProvider);
    final themeProvider = ref.read(ProviderList.themeProvider);
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
                    padding: const EdgeInsets.only(left: 15, top: 20),
                    child: SvgPicture.asset(
                      "assets/svg_images/view_card.svg",
                      height: 16,
                      width: 16,
                      colorFilter: ColorFilter.mode(
                          themeProvider.themeManager.primaryTextColor,
                          BlendMode.srcIn),
                    )),

                Expanded(
                  flex: 500,
                  child: Container(
                    margin: const EdgeInsets.only(left: 5),
                    //width: MediaQuery.sizeOf(context).width - 250,
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 20),
                    child: CustomText(
                      viewsProvider.views[index]["name"],
                      type: FontStyle.H6,
                      fontWeight: FontWeightt.Medium,
                      color: themeProvider.themeManager.primaryTextColor,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: themeProvider
                              .themeManager.tertiaryBackgroundDefaultColor,
                        ),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 3, bottom: 3),
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
                          //margin: const EdgeInsets.only(top: 12, left: 10, right: 10),
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
                      const SizedBox(
                        width: 10,
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
                        child: Icon(
                          LucideIcons.trash2,
                          color: themeProvider.themeManager.textErrorColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
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
