import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/CyclesTab/cycle_active_card.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/CyclesTab/cycle_detail.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/widgets/custom_divider.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/cycle_card_widget.dart';
import 'package:plane/widgets/empty.dart';
import 'package:plane/widgets/loading_widget.dart';

class CycleWidget extends ConsumerStatefulWidget {
  const CycleWidget({super.key});

  @override
  ConsumerState<CycleWidget> createState() => _CycleWidgetState();
}

class _CycleWidgetState extends ConsumerState<CycleWidget> {
  int cycleNaveBarSelectedIndex = 0;
  EdgeInsets favouriteTextPadding =
      const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return cyclesProvider.cyclesState == StateEnum.loading
        ? Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: LoadingIndicator(
                indicatorType: Indicator.lineSpinFadeLoader,
                colors: [
                  themeProvider.themeManager.primaryBackgroundDefaultColor
                ],
                strokeWidth: 1.0,
                backgroundColor: Colors.transparent,
              ),
            ),
          )
        : cycles();
  }

  Widget cycles() {
    var cyclesProvider = ref.read(ProviderList.cyclesProvider);
    return SizedBox(
      width: width,
      height: height,
      child: Column(children: [
        const SizedBox(
          height: 15,
        ),
        cyclesProvider.cyclesAllData.isEmpty &&
                cyclesProvider.cycleFavoriteData.isEmpty &&
                cyclesProvider.allCyclesState != StateEnum.loading
            ? const SizedBox.shrink()
            : SizedBox(height: 40, child: cycleNaveBar()),
        const SizedBox(
          height: 15,
        ),
        Expanded(child: cycleBody()),
      ]),
    );
  }

  Widget cycleNaveBar() {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: [
        const SizedBox(width: 16),
        cycleNaveBarItem('All', 0),
        cycleNaveBarItem('Active', 1),
        cycleNaveBarItem('Upcoming', 2),
        cycleNaveBarItem('Completed', 3),
        cycleNaveBarItem('Draft', 4),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget cycleNaveBarItem(String title, int itemIndex) {
    var themeProvider = ref.watch(ProviderList.themeProvider);

    BoxDecoration decarationOnSelected = BoxDecoration(
        border: Border.all(width: 1, color: Colors.blueAccent),
        color: themeProvider.themeManager.primaryColour,
        borderRadius: const BorderRadius.all(Radius.circular(5)));
    BoxDecoration decarationOnUnSelected = BoxDecoration(
        border: Border.all(
            width: 1, color: themeProvider.themeManager.borderSubtle01Color),
        color: themeProvider.themeManager.primaryBackgroundDefaultColor,
        borderRadius: const BorderRadius.all(Radius.circular(5)));
    return GestureDetector(
      onTap: () {
        setState(() {
          cycleNaveBarSelectedIndex = itemIndex;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        decoration: cycleNaveBarSelectedIndex == itemIndex
            ? decarationOnSelected
            : decarationOnUnSelected,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: CustomText(
              title,
              color: cycleNaveBarSelectedIndex == itemIndex
                  ? Colors.white
                  : themeProvider.themeManager.primaryTextColor,
              type: FontStyle.Small,
              overrride: true,
            ),
          ),
        ),
      ),
    );
  }

  Widget cycleBody() {
    List<Widget> widgets = [
      cycleAll(),
      cycleActive(),
      cycleUpcoming(),
      cycleCompleted(),
      cycleDraft()
    ];
    return widgets[cycleNaveBarSelectedIndex];
  }

  Widget cycleAll() {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var cyclesProviderRead = ref.read(ProviderList.cyclesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return LoadingWidget(
      loading: cyclesProvider.allCyclesState == StateEnum.loading,
      widgetClass: cyclesProvider.cyclesAllData.isEmpty &&
              cyclesProvider.cycleFavoriteData.isEmpty
          ? EmptyPlaceholder.emptyCycles(context, ref)
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cyclesProvider.cycleFavoriteData.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cyclesProvider.cyclesAllData.isNotEmpty
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
                                : Container(
                                    height: 20,
                                  ),
                            ListView.separated(
                              separatorBuilder: (context, index) =>
                                  cyclesProvider.cycleFavoriteData[index]
                                          ['is_favorite']
                                      ? CustomDivider(
                                          themeProvider: themeProvider,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 15),
                                        )
                                      : Container(),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount:
                                  cyclesProvider.cycleFavoriteData.length,
                              itemBuilder: (context, index) {
                                return cyclesProvider.cycleFavoriteData[index]
                                        ['is_favorite']
                                    ? InkWell(
                                        onTap: () {
                                          cyclesProvider.currentCycle =
                                              cyclesProvider
                                                  .cycleFavoriteData[index];
                                          cyclesProviderRead.setState();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CycleDetail(
                                                cycleId: cyclesProvider
                                                        .cycleFavoriteData[
                                                    index]['id'],
                                                cycleName: cyclesProvider
                                                        .cycleFavoriteData[
                                                    index]['name'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: CycleCardWidget(
                                          cycleData: cyclesProvider
                                              .cycleFavoriteData[index],
                                        ),
                                      )
                                    : Container();
                              },
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  cyclesProvider.cyclesAllData.isNotEmpty &&
                          cyclesProvider.cycleFavoriteData.isNotEmpty
                      ? const SizedBox(height: 20)
                      : const SizedBox.shrink(),
                  cyclesProvider.cyclesAllData.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cyclesProvider.cycleFavoriteData.isNotEmpty
                                ? Padding(
                                    padding: favouriteTextPadding,
                                    child: CustomText(
                                      'All Cycles',
                                      type: FontStyle.Medium,
                                      fontWeight: FontWeightt.Medium,
                                      color: themeProvider
                                          .themeManager.placeholderTextColor,
                                    ),
                                  )
                                : Container(
                                    height: 20,
                                  ),
                            ListView.separated(
                                separatorBuilder: (context, index) =>
                                    CustomDivider(themeProvider: themeProvider),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: cyclesProvider.cyclesAllData.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      cyclesProvider.currentCycle =
                                          cyclesProvider.cyclesAllData[index];
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CycleDetail(
                                            cycleId: cyclesProvider
                                                .cyclesAllData[index]['id'],
                                            cycleName: cyclesProvider
                                                .cyclesAllData[index]['name'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: (Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CycleCardWidget(
                                          cycleData: cyclesProvider
                                              .cyclesAllData[index],
                                        ),
                                      ],
                                    )),
                                  );
                                }),
                          ],
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }

  Widget cycleActive() {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    if (cyclesProvider.activeCyclesState == StateEnum.loading) {
      return const LoadingWidget(widgetClass: Center(), loading: true);
    } else if (cyclesProvider.cyclesActiveData.isEmpty) {
      return const SizedBox(
        child: Center(
          child: CustomText(
            'No active cycle is present.',
            type: FontStyle.Small,
          ),
        ),
      );
    } else {
      return cyclesProvider.cyclesActiveData.isEmpty
          ? EmptyPlaceholder.emptyCycles(context, ref)
          : ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return CycleActiveCard(
                  index: index,
                );
              },
            );
    }
  }

  Widget cycleCompleted() {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var cyclesProviderRead = ref.read(ProviderList.cyclesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return LoadingWidget(
      loading: cyclesProvider.completedCyclesState == StateEnum.loading,
      widgetClass: cyclesProvider.cyclesCompletedData.isEmpty &&
              cyclesProvider.cycleCompletedFavoriteData.isEmpty
          ? EmptyPlaceholder.emptyCycles(context, ref)
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 15),
                  cyclesProvider.cycleCompletedFavoriteData.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cyclesProvider.cyclesCompletedData.isNotEmpty
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
                            ListView.separated(
                                separatorBuilder: (context, index) =>
                                    CustomDivider(
                                      themeProvider: themeProvider,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 15),
                                    ),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: cyclesProvider
                                    .cycleCompletedFavoriteData.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        cyclesProviderRead.currentCycle =
                                            cyclesProvider
                                                    .cycleCompletedFavoriteData[
                                                index];
                                        cyclesProviderRead.setState();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CycleDetail(
                                              cycleId: cyclesProvider
                                                      .cycleCompletedFavoriteData[
                                                  index]['id'],
                                              cycleName: cyclesProvider
                                                      .cycleCompletedFavoriteData[
                                                  index]['name'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: CycleCardWidget(
                                          cycleData: cyclesProvider
                                                  .cycleCompletedFavoriteData[
                                              index]));
                                }),
                          ],
                        )
                      : const SizedBox.shrink(),
                  cyclesProvider.cyclesCompletedData.isNotEmpty &&
                          cyclesProvider.cycleCompletedFavoriteData.isNotEmpty
                      ? Container(height: 20)
                      : Container(),
                  cyclesProvider.cyclesCompletedData.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cyclesProvider.cycleCompletedFavoriteData.isNotEmpty
                                ? Padding(
                                    padding: favouriteTextPadding,
                                    child: CustomText(
                                      'All Cycles',
                                      type: FontStyle.Medium,
                                      fontWeight: FontWeightt.Medium,
                                      color: themeProvider
                                          .themeManager.placeholderTextColor,
                                    ),
                                  )
                                : Container(height: 20),
                            ListView.separated(
                                separatorBuilder: (context, index) =>
                                    CustomDivider(
                                      themeProvider: themeProvider,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 15),
                                    ),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount:
                                    cyclesProvider.cyclesCompletedData.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        cyclesProviderRead.currentCycle =
                                            cyclesProvider
                                                .cyclesCompletedData[index];
                                        cyclesProviderRead.setState();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CycleDetail(
                                              cycleId: cyclesProvider
                                                      .cyclesCompletedData[
                                                  index]['id'],
                                              cycleName: cyclesProvider
                                                      .cyclesCompletedData[
                                                  index]['name'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: CycleCardWidget(
                                          cycleData: cyclesProvider
                                              .cyclesCompletedData[index]));
                                }),
                          ],
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }

  Widget cycleUpcoming() {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var cyclesProviderRead = ref.read(ProviderList.cyclesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);

    return LoadingWidget(
      loading: cyclesProvider.upcomingCyclesState == StateEnum.loading,
      widgetClass: cyclesProvider.cyclesUpcomingData.isEmpty &&
              cyclesProvider.cycleUpcomingFavoriteData.isEmpty
          ? EmptyPlaceholder.emptyCycles(context, ref)
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cyclesProvider.cycleUpcomingFavoriteData.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cyclesProvider.cyclesUpcomingData.isNotEmpty
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
                            ListView.separated(
                                separatorBuilder: (context, index) =>
                                    CustomDivider(
                                      themeProvider: themeProvider,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 15),
                                    ),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: cyclesProvider
                                    .cycleUpcomingFavoriteData.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        cyclesProviderRead.currentCycle =
                                            cyclesProvider
                                                    .cycleUpcomingFavoriteData[
                                                index];
                                        cyclesProviderRead.setState();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CycleDetail(
                                              cycleId: cyclesProvider
                                                      .cycleUpcomingFavoriteData[
                                                  index]['id'],
                                              cycleName: cyclesProvider
                                                      .cycleUpcomingFavoriteData[
                                                  index]['name'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: CycleCardWidget(
                                          cycleData: cyclesProvider
                                                  .cycleUpcomingFavoriteData[
                                              index]));
                                }),
                          ],
                        )
                      : const SizedBox.shrink(),
                  cyclesProvider.cyclesUpcomingData.isNotEmpty &&
                          cyclesProvider.cycleUpcomingFavoriteData.isNotEmpty
                      ? Container(height: 20)
                      : Container(),
                  cyclesProvider.cyclesUpcomingData.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cyclesProvider.cycleUpcomingFavoriteData.isNotEmpty
                                ? Padding(
                                    padding: favouriteTextPadding,
                                    child: CustomText(
                                      'All Cycles',
                                      type: FontStyle.Medium,
                                      fontWeight: FontWeightt.Medium,
                                      color: themeProvider
                                          .themeManager.placeholderTextColor,
                                    ),
                                  )
                                : Container(height: 20),
                            ListView.separated(
                                separatorBuilder: (context, index) =>
                                    CustomDivider(
                                      themeProvider: themeProvider,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 15),
                                    ),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount:
                                    cyclesProvider.cyclesUpcomingData.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        cyclesProviderRead.currentCycle =
                                            cyclesProvider
                                                .cyclesUpcomingData[index];
                                        cyclesProviderRead.setState();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CycleDetail(
                                              cycleId: cyclesProvider
                                                      .cyclesUpcomingData[index]
                                                  ['id'],
                                              cycleName: cyclesProvider
                                                      .cyclesUpcomingData[index]
                                                  ['name'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: CycleCardWidget(
                                          cycleData: cyclesProvider
                                              .cyclesUpcomingData[index]));
                                }),
                          ],
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }

  Widget cycleDraft() {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var cyclesProviderRead = ref.read(ProviderList.cyclesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return LoadingWidget(
      loading: cyclesProvider.draftCyclesState == StateEnum.loading,
      widgetClass: cyclesProvider.cyclesDraftData.isEmpty &&
              cyclesProvider.cycleDraftFavoriteData.isEmpty
          ? EmptyPlaceholder.emptyCycles(context, ref)
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cyclesProvider.cycleDraftFavoriteData.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cyclesProvider.cyclesDraftData.isNotEmpty
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
                            ListView.separated(
                                separatorBuilder: (context, index) =>
                                    CustomDivider(
                                      themeProvider: themeProvider,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 15),
                                    ),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: cyclesProvider
                                    .cycleDraftFavoriteData.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      cyclesProviderRead.currentCycle =
                                          cyclesProvider
                                              .cycleDraftFavoriteData[index];
                                      cyclesProviderRead.setState();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CycleDetail(
                                            cycleId: cyclesProvider
                                                    .cycleDraftFavoriteData[
                                                index]['id'],
                                            cycleName: cyclesProvider
                                                    .cycleDraftFavoriteData[
                                                index]['name'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: CycleCardWidget(
                                        cycleData: cyclesProvider
                                            .cycleDraftFavoriteData[index]),
                                  );
                                }),
                          ],
                        )
                      : const SizedBox.shrink(),
                  cyclesProvider.cyclesDraftData.isNotEmpty &&
                          cyclesProvider.cycleDraftFavoriteData.isNotEmpty
                      ? Container(height: 20)
                      : Container(),
                  cyclesProvider.cyclesDraftData.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cyclesProvider.cycleDraftFavoriteData.isNotEmpty
                                ? Padding(
                                    padding: favouriteTextPadding,
                                    child: CustomText(
                                      'All Cycles',
                                      type: FontStyle.Medium,
                                      fontWeight: FontWeightt.Medium,
                                      color: themeProvider
                                          .themeManager.placeholderTextColor,
                                    ),
                                  )
                                : Container(height: 20),
                            ListView.separated(
                                separatorBuilder: (context, index) =>
                                    CustomDivider(
                                      themeProvider: themeProvider,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 15),
                                    ),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount:
                                    cyclesProvider.cyclesDraftData.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        cyclesProviderRead.currentCycle =
                                            cyclesProvider
                                                .cyclesDraftData[index];
                                        cyclesProviderRead.setState();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CycleDetail(
                                              cycleId: cyclesProvider
                                                  .cyclesDraftData[index]['id'],
                                              cycleName: cyclesProvider
                                                      .cyclesDraftData[index]
                                                  ['name'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: CycleCardWidget(
                                          cycleData: cyclesProvider
                                              .cyclesDraftData[index]));
                                }),
                          ],
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }

  String checkDate({String? startDate, String? endDate}) {
    DateTime now = DateTime.now();
    if ((startDate == null) || (endDate == null)) {
      return 'Draft';
    } else {
      if (DateTime.parse(startDate).isAfter(now)) {
        Duration difference = DateTime.parse(startDate).difference(now);
        if (difference.inDays == 0) {
          return 'Today';
        } else {
          return '${difference.inDays.abs() + 1} Days Left';
        }
      }
      if (DateTime.parse(startDate).isBefore(now) &&
          DateTime.parse(endDate).isAfter(now)) {
        Duration difference = DateTime.parse(endDate).difference(now);
        if (difference.inDays == 0) {
          return 'Today';
        } else {
          return '${difference.inDays.abs() + 1} Days Left';
        }
      } else {
        return 'Completed';
      }
    }
  }
}
