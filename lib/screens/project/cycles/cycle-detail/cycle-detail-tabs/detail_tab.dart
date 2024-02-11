// ignore_for_file: use_build_context_synchronously
part of '../cycle_detail.dart';

class DetailsTAB extends ConsumerStatefulWidget {
  const DetailsTAB({super.key});

  @override
  ConsumerState<DetailsTAB> createState() => _DetailsTABState();
}

class _DetailsTABState extends ConsumerState<DetailsTAB> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
/*
class CycleDetailsPage extends ConsumerStatefulWidget {
  const CycleDetailsPage({
    super.key,
    required this.cycleId,
  });
  final String cycleId;

  @override
  ConsumerState<CycleDetailsPage> createState() => _CycleDetailsPageState();
}

class _CycleDetailsPageState extends ConsumerState<CycleDetailsPage> {
  DateTime? dueDate;
  DateTime? startDate;

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final cyclesProvider = ref.watch(ProviderList.cyclesProvider);

    if (cyclesProvider.cyclesDetailState == DataState.loading) {
      return Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: LoadingIndicator(
            indicatorType: Indicator.lineSpinFadeLoader,
            colors: [themeProvider.themeManager.primaryTextColor],
            strokeWidth: 1.0,
            backgroundColor: Colors.transparent,
          ),
        ),
      );
    } else {
      return ListView(
        children: [
          const SizedBox(height: 30),
          dateWidget(),
          const SizedBox(height: 30),
          detailsWidget(),
          const SizedBox(height: 30),
          progressWidget(ref: ref, chartData: widget.chartData),
          const SizedBox(height: 30),
          // assigneesWidget(
          //     ref: ref, detailData: cyclesProvider.cyclesDetailsData),
          const SizedBox(height: 30),
          statesWidget(ref: ref, detailData: cyclesProvider.cyclesDetailsData),
          const SizedBox(height: 30),
          labelsWidget(),
          const SizedBox(height: 30),
          // widget.fromModule ? links() : Container()
        ],
      );
    }
  }

  Widget dateWidget() {
    final cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final detailData = cyclesProvider.cyclesDetailsData;

    startDate = DateFormat('yyyy-MM-dd').parse(
        detailData['start_date'] == null || detailData['start_date'] == ''
            ? DateTime.now().toString()
            : detailData['start_date']!);

    dueDate = DateFormat('yyyy-MM-dd').parse(
        detailData['end_date'] == null || detailData['end_date'] == ''
            ? DateTime.now().toString()
            : detailData['end_date']!);

    return Wrap(
      runSpacing: 20,
      children: [
        (detailData['start_date'] == null || detailData['start_date'] == '') ||
                (detailData['end_date'] == null || detailData['end_date'] == '')
            ? Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    width: 1,
                    color: themeProvider.themeManager.borderSubtle01Color,
                  ),
                ),
                child: const CustomText(
                  'Draft',
                  type: FontStyle.Small,
                ),
              )
            : Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: checkDate(
                                startDate: detailData['start_date'],
                                endDate: detailData['end_date']) ==
                            'Draft'
                        ? themeProvider
                            .themeManager.tertiaryBackgroundDefaultColor
                        : checkDate(
                                    startDate: detailData['start_date'],
                                    endDate: detailData['end_date']) ==
                                'Completed'
                            ? themeProvider
                                .themeManager.secondaryBackgroundActiveColor
                            : themeProvider.themeManager.successBackgroundColor,
                    borderRadius: BorderRadius.circular(5)),
                child: CustomText(
                  checkDate(
                    startDate: detailData['start_date'],
                    endDate: detailData['end_date'],
                  ),
                  type: FontStyle.Small,
                  color: checkDate(
                            startDate: detailData['start_date'],
                            endDate: detailData['end_date'],
                          ) ==
                          'Draft'
                      ? greyColor
                      : checkDate(
                                startDate: detailData['start_date'],
                                endDate: detailData['end_date'],
                              ) ==
                              'Completed'
                          ? themeProvider.themeManager.primaryColour
                          : greenHighLight,
                ),
              ),
        const SizedBox(width: 20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                if (projectProvider.role != Role.admin &&
                    projectProvider.role != Role.member) {
                  CustomToast.showToast(context,
                      message: accessRestrictedMSG,
                      toastType: ToastType.failure);
                  return;
                }
                final date = await showDatePicker(
                  builder: (context, child) => Theme(
                    data: themeProvider.themeManager.datePickerThemeData,
                    child: child!,
                  ),
                  context: context,
                  initialDate: startDate!,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025),
                );
                if (date != null) {
                  final bool dateNotConflicted = dueDate == null
                      ? true
                      : await cyclesProvider.dateCheck(
                          slug: ref
                              .read(ProviderList.workspaceProvider)
                              .selectedWorkspace
                              .workspaceSlug,
                          projectId: ref
                              .read(ProviderList.projectProvider)
                              .currentProject["id"],
                          data: {
                            "cycle_id": widget.cycleId,
                            "start_date": DateFormat('yyyy-MM-dd').format(date),
                            "end_date":
                                DateFormat('yyyy-MM-dd').format(dueDate!),
                          },
                        );
                  if (dateNotConflicted) {
                    if (dueDate != null && date.isAfter(dueDate!)) {
                      CustomToast.showToast(context,
                          message: 'Start date cannot be after end date',
                          toastType: ToastType.failure);
                      return;
                    }
                    setState(() {
                      startDate = date;
                    });
                  } else {
                    CustomToast.showToast(context,
                        message: 'Date is conflicted with other cycle',
                        toastType: ToastType.failure);
                    return;
                  }
                }

                if (date != null) {
                  cyclesProvider.cycleDetailsCrud(
                    disableLoading: true,
                    slug: ref
                        .read(ProviderList.workspaceProvider)
                        .selectedWorkspace
                        .workspaceSlug,
                    projectId: ref
                        .read(ProviderList.projectProvider)
                        .currentProject["id"],
                    method: CRUD.update,
                    cycleId: widget.cycleId,
                    data: {'start_date': DateFormat('yyyy-MM-dd').format(date)},
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color:
                      themeProvider.themeManager.primaryBackgroundDefaultColor,
                  border: Border.all(
                    width: 1,
                    color: themeProvider.themeManager.borderSubtle01Color,
                  ),
                ),
                child: (detailData['start_date'] == null ||
                            detailData['start_date'] == '') ||
                        (detailData['end_date'] == null ||
                            detailData['end_date'] == '')
                    ? CustomText(
                        'Start Date',
                        type: FontStyle.Small,
                        fontWeight: FontWeightt.Regular,
                        color: themeProvider.themeManager.secondaryTextColor,
                      )
                    : Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 15,
                              color: themeProvider
                                  .themeManager.placeholderTextColor),
                          const SizedBox(width: 7),
                          CustomText(
                            '${dateFormating(detailData['start_date'])} ',
                            type: FontStyle.Small,
                            fontWeight: FontWeightt.Regular,
                            color:
                                themeProvider.themeManager.secondaryTextColor,
                          ),
                        ],
                      ),
              ),
            ),
            //arrow
            const SizedBox(width: 5),
            Icon(
              Icons.arrow_forward,
              size: 15,
              color: themeProvider.themeManager.placeholderTextColor,
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () async {
                if (projectProvider.role != Role.admin &&
                    projectProvider.role != Role.member) {
                  CustomToast.showToast(context,
                      message: accessRestrictedMSG,
                      toastType: ToastType.failure);
                  return;
                }
                final date = await showDatePicker(
                  builder: (context, child) => Theme(
                    data: themeProvider.themeManager.datePickerThemeData,
                    child: child!,
                  ),
                  context: context,
                  initialDate: dueDate!,
                  firstDate: startDate ?? DateTime.now(),
                  lastDate: DateTime(2025),
                );

                if (date != null) {
                  if (!date.isAfter(DateTime.now())) {
                    CustomToast.showToast(context,
                        message: 'Due date not valid ',
                        toastType: ToastType.failure);
                    return;
                  }
                  if (date.isAfter(startDate!)) {
                    final bool dateNotConflicted =
                        await cyclesProvider.dateCheck(
                      slug: ref
                          .read(ProviderList.workspaceProvider)
                          .selectedWorkspace
                          .workspaceSlug,
                      projectId: ref
                          .read(ProviderList.projectProvider)
                          .currentProject["id"],
                      data: {
                        "cycle_id": widget.cycleId,
                        "start_date":
                            DateFormat('yyyy-MM-dd').format(startDate!),
                        "end_date": DateFormat('yyyy-MM-dd').format(date),
                      },
                    );

                    if (dateNotConflicted) {
                      setState(() {
                        dueDate = date;
                      });
                      cyclesProvider.cycleDetailsCrud(
                        disableLoading: true,
                        slug: ref
                            .read(ProviderList.workspaceProvider)
                            .selectedWorkspace
                            .workspaceSlug,
                        projectId: ref
                            .read(ProviderList.projectProvider)
                            .currentProject["id"],
                        method: CRUD.update,
                        cycleId: widget.cycleId,
                        data: {
                          'end_date': DateFormat('yyyy-MM-dd').format(date)
                        },
                      );
                      cyclesProvider.changeTabIndex(1);
                    } else {
                      CustomToast.showToast(context,
                          message: 'Date is conflicted with other cycle ',
                          toastType: ToastType.failure);
                    }
                  } else {
                    CustomToast.showToast(context,
                        message: 'Start date cannot be after end date ',
                        toastType: ToastType.failure);
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color:
                      themeProvider.themeManager.primaryBackgroundDefaultColor,
                  border: Border.all(
                    width: 1,
                    color: themeProvider.themeManager.borderSubtle01Color,
                  ),
                ),
                child: (detailData['start_date'] == null ||
                            detailData['start_date'] == '') ||
                        (detailData['end_date'] == null ||
                            detailData['end_date'] == '')
                    ? CustomText('End Date',
                        type: FontStyle.Small,
                        fontWeight: FontWeightt.Regular,
                        color: themeProvider.themeManager.secondaryTextColor)
                    : Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 15,
                              color: themeProvider
                                  .themeManager.placeholderTextColor),
                          const SizedBox(width: 5),
                          CustomText(
                              '${dateFormating(detailData['end_date'])} ',
                              type: FontStyle.Small,
                              fontWeight: FontWeightt.Regular,
                              color: themeProvider
                                  .themeManager.secondaryTextColor),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget detailsWidget() {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              'Details',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Medium,
              color: themeProvider.themeManager.primaryTextColor,
            )),
        const SizedBox(height: 10),
        stateWidget(),
        const SizedBox(height: 10),
        assigneeWidget(ref: ref, detailData: cyclesProvider.cyclesDetailsData),
      ],
    );
  }

  Widget labelsWidget({bool fromModule = false}) {
    final cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);

    final detailData = cyclesProvider.cyclesDetailsData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              'Labels',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Medium,
              color: themeProvider.themeManager.primaryTextColor,
            )),
        const SizedBox(height: 10),
        detailData['distribution']['labels'].isNotEmpty
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      themeProvider.themeManager.primaryBackgroundDefaultColor,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: themeProvider.themeManager.borderSubtle01Color,
                  ),
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: detailData['distribution']['labels'].length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: cyclesProvider.issues.filters.labels.contains(
                                  detailData['distribution']['labels'][index]
                                      ['label_id'])
                              ? themeProvider
                                  .themeManager.secondaryBackgroundDefaultColor
                              : themeProvider
                                  .themeManager.primaryBackgroundDefaultColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 20,
                                  color: detailData['distribution']['labels']
                                              [index]['label_name'] ==
                                          null
                                      ? themeProvider.themeManager
                                          .tertiaryBackgroundDefaultColor
                                      : detailData['distribution']['labels']
                                                      [index]['color'] ==
                                                  '' ||
                                              detailData['distribution']
                                                          ['labels'][index]
                                                      ['color'] ==
                                                  null
                                          ? themeProvider
                                              .themeManager.placeholderTextColor
                                          : detailData['distribution']['labels']
                                                  [index]['color']
                                              .toString()
                                              .toColor(),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: width * 0.4,
                                  child: CustomText(
                                    detailData['distribution']['labels'][index]
                                            ['label_name'] ??
                                        'No Label',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                CompletionPercentage(
                                    value: detailData['distribution']['labels']
                                        [index]['completed_issues'],
                                    totalValue: detailData['distribution']
                                        ['labels'][index]['total_issues'])
                              ],
                            )
                          ],
                        ),
                      );
                    }),
              )
            : const Align(
                alignment: Alignment.center,
                child: CustomText('No data found'),
              )
      ],
    );
  }

  Widget stateWidget({bool fromModule = false}) {
    final cyclesProvider = ref.watch(ProviderList.cyclesProvider);
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
          children: [
            //icon
            Icon(
                //four squares icon
                Icons.timelapse_rounded,
                color: themeProvider.themeManager.placeholderTextColor),
            const SizedBox(width: 15),
            CustomText(
              'Progress',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Regular,
              color: themeProvider.themeManager.placeholderTextColor,
            ),
            Expanded(child: Container()),

            CompletionPercentage(
              value: cyclesProvider.cyclesDetailsData['completed_issues'],
              totalValue: cyclesProvider.cyclesDetailsData['total_issues'],
            )
          ],
        ),
      ),
    );
  }

  Widget membersWidget() {
    final modulesProvider = ref.watch(ProviderList.modulesProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    return GestureDetector(
      onTap: () {
        if (projectProvider.role != Role.admin &&
            projectProvider.role != Role.member) {
          CustomToast.showToast(context,
              message: accessRestrictedMSG, toastType: ToastType.failure);
          return;
        }
        showModalBottomSheet(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          context: context,
          builder: (context) => const AssigneeSheet(
            fromModuleDetail: false,
          ),
        );
      },
      child: Container(
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
            children: [
              //icon
              Icon(
                //two people icon
                Icons.people_alt_rounded,
                color: themeProvider.themeManager.placeholderTextColor,
              ),
              const SizedBox(width: 15),
              CustomText(
                'Members',
                type: FontStyle.Medium,
                fontWeight: FontWeightt.Regular,
                color: themeProvider.themeManager.placeholderTextColor,
              ),
              Expanded(child: Container()),
              (modulesProvider.currentModule['members_detail'] == null ||
                      modulesProvider.currentModule['members_detail'].isEmpty)
                  ? Row(
                      children: [
                        CustomText(
                          'No members',
                          type: FontStyle.Medium,
                          fontWeight: FontWeightt.Regular,
                          color: themeProvider.themeManager.primaryTextColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: themeProvider.themeManager.primaryTextColor,
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 27,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 30,
                          child: SquareAvatarWidget(
                              borderRadius: 50,
                              member_ids: modulesProvider
                                  .currentModule['members_detail']),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  String dateFormating(String date) {
    final DateTime formatedDate = DateTime.parse(date);
    final String finalDate = DateFormat('dd MMM').format(formatedDate);
    return finalDate;
  }

  String checkDate({required String startDate, required String endDate}) {
    final DateTime now = DateTime.now();
    if ((startDate.isEmpty) || (endDate.isEmpty)) {
      return 'Draft';
    } else {
      if (DateTime.parse(startDate).isAfter(now)) {
        final Duration difference =
            DateTime.parse(startDate.split('+').first).difference(now);
        if (difference.inDays == 0) {
          return 'Today';
        } else {
          return '${difference.inDays.abs() + 1} Days Left';
        }
      }
      if (DateTime.parse(startDate).isBefore(now) &&
          DateTime.parse(endDate).isAfter(now)) {
        final Duration difference = DateTime.parse(endDate).difference(now);
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

  String checkTimeDifferenc(String dateTime) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(DateTime.parse(dateTime));
    String? format;

    if (difference.inDays > 0) {
      format = '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      format = '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      format = '${difference.inMinutes} minutes ago';
    } else {
      format = '${difference.inSeconds} seconds ago';
    }

    return format;
  }
}
*/