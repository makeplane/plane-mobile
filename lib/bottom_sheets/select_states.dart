import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/provider/issues_provider.dart';
import 'package:plane/screens/create_state.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class SelectStates extends ConsumerStatefulWidget {
  const SelectStates({required this.createIssue, this.issueId, super.key});
  final bool createIssue;
  final String? issueId;

  @override
  ConsumerState<SelectStates> createState() => _SelectStatesState();
}

class _SelectStatesState extends ConsumerState<SelectStates> {
  String selectedState = '';
  @override
  void initState() {
    final prov = ref.read(ProviderList.issuesProvider);
    if (prov.states.isEmpty) {
      prov.getStates(
          slug: ref
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace
              .workspaceSlug,
          projID: ref
              .read(ProviderList.issuesProvider)
              .createIssueProjectData['id']);
    }

    // selectedState = widget.createIssue
    //     ? prov.createIssuedata['state'] != null
    //         ? prov.createIssuedata['state']['id']
    //         : ''
    //     : prov.states['state'] != null
    //         ? prov.states['state']['id']
    //         : '';
    // log(prov.createIssuedata['state'].toString());
    selectedState = prov.createIssuedata['state'] ?? prov.states.keys.first;
    super.initState();
  }

  Color getColorFromIssueProvider(
      IssuesProvider issuesProvider, int index, int idx) {
    const Color colorToReturnOnApiError = Color.fromARGB(255, 200, 80, 80);
    final String? colorData =
        issuesProvider.statesData[states[index]][idx]['color'];

    return (colorData == null || colorData[0] != '#')
        ? colorToReturnOnApiError
        : Color(int.parse("FF${colorData.replaceAll('#', '')}", radix: 16));
  }

  String issueDetailSelectedState = '';
  List states = ['backlog', 'unstarted', 'started', 'completed', 'cancelled'];
  @override
  Widget build(BuildContext context) {
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    final issueProvider = ref.watch(ProviderList.issueProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return WillPopScope(
      onWillPop: () async {
        final prov = ref.read(ProviderList.issuesProvider);
        //   if (selectedState.isNotEmpty) {
        prov.createIssuedata['state'] = selectedState;

        prov.setsState();

        //  }
        return true;
      },
      child: Container(
        padding: bottomSheetConstPadding,
        decoration: BoxDecoration(
          color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        width: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 45,
                  ),
                  for (int j = 0; j < states.length; j++)
                    for (int i = 0;
                        i < issuesProvider.statesData[states[j]].length;
                        i++)
                      // issuesProvider.states.keys.elementAt(i) ==
                      //         issuesProvider.stateOrdering[j]
                      //     ?
                      InkWell(
                        onTap: () async {
                          if (widget.createIssue) {
                            setState(() {
                              // log(issuesProvider.states[
                              //         issuesProvider.states.keys.elementAt(i)]
                              //     .toString());
                              selectedState =
                                  issuesProvider.statesData[states[j]][i]['id'];
                              issuesProvider.createIssuedata['state'] =
                                  selectedState;

                              issuesProvider.setsState();
                            });
                            issuesProvider.setsState();
                          } else {
                            setState(() {
                              issueDetailSelectedState = issuesProvider
                                  .statesData[states[j]][i]['name'];
                            });
                            await issueProvider.upDateIssue(
                                slug: ref
                                    .read(ProviderList.workspaceProvider)
                                    .selectedWorkspace
                                    .workspaceSlug,
                                projID: ref
                                    .read(ProviderList.projectProvider)
                                    .currentProject['id'],
                                issueID: widget.issueId!,
                                refs: ref,
                                data: {
                                  'state':
                                      '${issuesProvider.statesData[states[j]][i]['id']}'
                                });
                            await issuesProvider.filterIssues(
                              slug: ref
                                  .read(ProviderList.workspaceProvider)
                                  .selectedWorkspace
                                  .workspaceSlug,
                              projID: ref
                                  .read(ProviderList.projectProvider)
                                  .currentProject['id'],
                            );
                          }
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          //height: 40,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),

                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 25,
                                    width: 25,
                                    // decoration: BoxDecoration(
                                    //   color: Colors.grey,
                                    //   borderRadius: BorderRadius.circular(5),
                                    // ),
                                    child: SvgPicture.asset(
                                      states[j] == 'backlog'
                                          ? 'assets/svg_images/circle.svg'
                                          : states[j] == 'cancelled'
                                              ? 'assets/svg_images/cancelled.svg'
                                              : states[j] == 'completed'
                                                  ? 'assets/svg_images/done.svg'
                                                  : states[j] == 'started'
                                                      ? 'assets/svg_images/in_progress.svg'
                                                      : 'assets/svg_images/unstarted.svg',
                                      colorFilter: ColorFilter.mode(
                                          getColorFromIssueProvider(
                                              issuesProvider, j, i),
                                          BlendMode.srcIn),
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                  Container(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: width * 0.7,
                                    child: CustomText(
                                      issuesProvider.statesData[states[j]][i]
                                          ['name'],
                                      type: FontStyle.Medium,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeightt.Regular,
                                      color: themeProvider
                                          .themeManager.primaryTextColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  widget.createIssue
                                      ? createIssueStateSelectionWidget(i, j)
                                      : issueDetailStateSelectionWidget(i, j),
                                  const SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              Container(
                                  width: width,
                                  height: 1,
                                  color: themeProvider
                                      .themeManager.borderDisabledColor)
                            ],
                          ),
                        ),
                      ),
                  // : Container(),
                  widget.createIssue
                      ? GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const CreateState()));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 5, top: 15),
                            child: Row(
                              children: [
                                SizedBox(
                                    height: 25,
                                    width: 25,
                                    // decoration: BoxDecoration(
                                    //   color: Colors.grey,
                                    //   borderRadius: BorderRadius.circular(5),
                                    // ),
                                    child: Icon(
                                      Icons.add,
                                      color: themeProvider
                                          .themeManager.placeholderTextColor,
                                    )),
                                Container(
                                  width: 10,
                                ),
                                const CustomText(
                                  'Create New State',
                                  type: FontStyle.Small,
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(height: bottomSheetConstBottomPadding),
                ],
              ),
            ),
            Container(
              color: themeProvider.themeManager.primaryBackgroundDefaultColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'Select State',
                    type: FontStyle.H4,
                    fontWeight: FontWeightt.Semibold,
                    color: themeProvider.themeManager.primaryTextColor,
                  ),
                  IconButton(
                      onPressed: () {
                        final prov = ref.read(ProviderList.issuesProvider);
                        //   if (selectedState.isNotEmpty) {
                        prov.createIssuedata['state'] = selectedState;
                        // print('state');
                        // print(prov.createIssuedata['state'].toString());
                        prov.getStates(
                            slug: ref
                                .read(ProviderList.workspaceProvider)
                                .selectedWorkspace
                                .workspaceSlug,
                            projID: ref
                                .read(ProviderList.projectProvider)
                                .currentProject['id']);
                        prov.setsState();
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: themeProvider.themeManager.placeholderTextColor,
                      ))
                ],
              ),
            ),
            issuesProvider.statesState == StateEnum.loading
                ? Container(
                    alignment: Alignment.center,
                    color: Colors.white.withOpacity(0.7),
                    // height: 25,
                    // width: 25,
                    child: const Wrap(
                      children: [
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: LoadingIndicator(
                            indicatorType: Indicator.lineSpinFadeLoader,
                            colors: [Colors.black],
                            strokeWidth: 1.0,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget createIssueStateSelectionWidget(int i, int j) {
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    return selectedState == issuesProvider.statesData[states[j]][i]['id']
        ? const Icon(
            Icons.done,
            color: Color.fromRGBO(8, 171, 34, 1),
          )
        : const SizedBox();
  }

  Widget issueDetailStateSelectionWidget(int i, int j) {
    final issueProvider = ref.watch(ProviderList.issueProvider);
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    return issueProvider.issueDetails['state_detail']['id'] ==
            issuesProvider.statesData[states[j]][i]['id']
        ? const Icon(
            Icons.done,
            color: Color.fromRGBO(8, 171, 34, 1),
          )
        : issueProvider.updateIssueState == StateEnum.loading &&
                issueDetailSelectedState ==
                    issuesProvider.statesData[states[j]][i]['name']
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: greyColor,
                ),
              )
            : const SizedBox();
  }
}
