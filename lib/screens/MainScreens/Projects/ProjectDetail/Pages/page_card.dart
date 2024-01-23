import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane/bottom_sheets/delete_cycle_sheet.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Pages/page_detail.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

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
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final pageProvider = ref.watch(ProviderList.pageProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);

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
                          themeProvider.themeManager.primaryTextColor,
                          BlendMode.srcIn),
                    )),

                Container(
                  padding: const EdgeInsets.only(left: 10, right: 15, top: 20),
                  child: CustomText(
                    pageProvider
                            .pages[pageProvider.selectedFilter]![widget.index]
                        ['name'],
                    type: FontStyle.H6,
                    fontWeight: FontWeightt.Medium,
                    color: themeProvider.themeManager.primaryTextColor,
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
                    color: themeProvider.themeManager.placeholderTextColor,
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
                              context: context,
                              pageId: pageProvider.pages[pageProvider
                                  .selectedFilter]![widget.index]['id'],
                              slug: workspaceProvider
                                  .selectedWorkspace.workspaceSlug,
                              projectId: projectProvider.currentProject['id'],
                              data: {
                                "access": pageProvider.pages[pageProvider
                                    .selectedFilter]![widget.index]['access']
                              },
                              ref: ref);
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          child:
                              pageProvider.pages[pageProvider.selectedFilter]![
                                          widget.index]['access'] ==
                                      0 // 1 = locked || 0 = unlocked
                                  ? Icon(
                                      Icons.lock_open_outlined,
                                      size: 18,
                                      color: themeProvider
                                          .themeManager.placeholderTextColor,
                                    )
                                  : Icon(
                                      Icons.lock_clock_outlined,
                                      size: 18,
                                      color: themeProvider
                                          .themeManager.placeholderTextColor,
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
                                    .selectedWorkspace.workspaceSlug,
                                projectId: projectProvider.currentProject['id'],
                                shouldItBeFavorite: false);
                          },
                          child: Icon(Icons.star,
                              size: 18,
                              color:
                                  themeProvider.themeManager.tertiaryTextColor))
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
                                    .selectedWorkspace.workspaceSlug,
                                projectId: projectProvider.currentProject['id'],
                                shouldItBeFavorite: true);
                          },
                          child: Icon(
                            Icons.star_border,
                            size: 18,
                            color:
                                themeProvider.themeManager.placeholderTextColor,
                          ),
                        ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
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
                            name: pageProvider.pages[pageProvider
                                .selectedFilter]![widget.index]['name'],
                            id: pageProvider.pages[pageProvider
                                .selectedFilter]![widget.index]['id'],
                            type: 'Page',
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.more_vert,
                      size: 18,
                      color: themeProvider.themeManager.placeholderTextColor,
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
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    bool hasAccess = false;

    for (final element in projectProvider.projectMembers) {
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
