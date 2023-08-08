import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/PagesTab/page_detail.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class PageCard extends ConsumerStatefulWidget {
  const PageCard({super.key, required this.index});
  final int index;

  @override
  ConsumerState<PageCard> createState() => _PageCardState();
}

class _PageCardState extends ConsumerState<PageCard> {
  String timeAgo({bool numericDates = true, required DateTime date}) {
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1w ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1d ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours}h ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1h ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1m ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds}s ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var pageProvider = ref.watch(ProviderList.pageProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);

    checkAccess();

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => PageDetail(
                    index: widget.index,
                  )),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
            color: themeProvider.isDarkThemeEnabled
                ? darkBackgroundColor
                : lightBackgroundColor,
            border: Border.all(
              color: themeProvider.isDarkThemeEnabled
                  ? darkThemeBorder
                  : Colors.grey.shade300,
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
                    child: SvgPicture.asset(
                      'assets/svg_images/file.svg',
                      width: 25,
                      height: 25,
                      colorFilter: ColorFilter.mode(
                          themeProvider.isDarkThemeEnabled
                              ? lightBackgroundColor
                              : darkBackgroundColor,
                          BlendMode.srcIn),
                    )),

                Container(
                  padding: const EdgeInsets.only(left: 10, right: 15, top: 20),
                  child: CustomText(
                    pageProvider
                            .pages[pageProvider.selectedFilter]![widget.index]
                        ['name'],
                    type: FontStyle.Medium,
                    fontWeight: FontWeightt.Semibold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            //description
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 35),
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 0),
                  child: CustomText(
                    timeAgo(
                        date: DateTime.parse(pageProvider
                            .pages[pageProvider.selectedFilter]![widget.index]
                                ['updated_at']
                            .toString())),
                    type: FontStyle.Small,
                    color: themeProvider.isDarkThemeEnabled
                        ? const Color.fromRGBO(172, 181, 189, 1)
                        : greyColor,
                  ),
                ),
                const Spacer(),
                checkAccess()
                    ? InkWell(
                        onTap: () {
                          pageProvider.pages[pageProvider.selectedFilter]![
                                  widget.index]['access'] =
                              pageProvider.pages[pageProvider.selectedFilter]![
                                          widget.index]['access'] ==
                                      1
                                  ? 0
                                  : 1;
                          pageProvider.editPage(
                            pageId: pageProvider.pages[pageProvider
                                .selectedFilter]![widget.index]['id'],
                            slug: workspaceProvider
                                .selectedWorkspace!.workspaceSlug,
                            projectId: projectProvider.currentProject['id'],
                            data: {
                              "access": pageProvider.pages[pageProvider
                                  .selectedFilter]![widget.index]['access']
                            },
                          );
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          child:
                              pageProvider.pages[pageProvider.selectedFilter]![
                                          widget.index]['access'] ==
                                      0 // 1 = locked || 0 = unlocked
                                  ? const Icon(
                                      Icons.lock_open_outlined,
                                      size: 18,
                                      color: Color.fromRGBO(172, 181, 189, 1),
                                    )
                                  : const Icon(
                                      Icons.lock_clock_outlined,
                                      size: 18,
                                      color: Color.fromRGBO(255, 0, 0, 1),
                                    ),
                        ),
                      )
                    : Container(),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: pageProvider.pages[pageProvider.selectedFilter]![
                              widget.index]['is_favorite'] ==
                          true
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              pageProvider.pages[pageProvider.selectedFilter]![
                                  widget.index]['is_favorite'] = !pageProvider
                                      .pages[pageProvider.selectedFilter]![
                                  widget.index]['is_favorite'];
                            });
                            pageProvider.makePageFavorite(
                                pageId: pageProvider.pages[pageProvider
                                    .selectedFilter]![widget.index]['id'],
                                slug: workspaceProvider
                                    .selectedWorkspace!.workspaceSlug,
                                projectId: projectProvider.currentProject['id'],
                                shouldItBeFavorite: false);
                          },
                          child: const Icon(Icons.star,
                              size: 18, color: Colors.amber))
                      : InkWell(
                          onTap: () {
                            setState(() {
                              pageProvider.pages[pageProvider.selectedFilter]![
                                  widget.index]['is_favorite'] = !pageProvider
                                      .pages[pageProvider.selectedFilter]![
                                  widget.index]['is_favorite'];
                            });
                            pageProvider.makePageFavorite(
                                pageId: pageProvider.pages[pageProvider
                                    .selectedFilter]![widget.index]['id'],
                                slug: workspaceProvider
                                    .selectedWorkspace!.workspaceSlug,
                                projectId: projectProvider.currentProject['id'],
                                shouldItBeFavorite: true);
                          },
                          child: const Icon(
                            Icons.star_border,
                            size: 18,
                            color: Color.fromRGBO(172, 181, 189, 1),
                          ),
                        ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  bool checkAccess() {
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);
    bool hasAccess = false;

    for (var element in projectProvider.projectMembers) {
      if (element['member']['id'] == profileProvider.userProfile.id &&
          (element['role'] == 20 || element['role'] == 15)) {
        hasAccess = true;
      } else {
        hasAccess = false;
      }
    }

    return hasAccess;
  }
}
