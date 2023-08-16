import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane_startup/bottom_sheets/global_search_sheet.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/MainScreens/Projects/create_project_screen.dart';
import 'package:plane_startup/screens/on_boarding/on_boarding_screen.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/bottom_sheets/select_workspace.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../on_boarding/auth/setup_workspace.dart';

class DashBoardScreen extends ConsumerStatefulWidget {
  final bool fromSignUp;
  const DashBoardScreen({required this.fromSignUp, super.key});

  @override
  ConsumerState<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends ConsumerState<DashBoardScreen> {
  String greetAtTime(int hourIn24HourFormate) {
    if (hourIn24HourFormate < 12) {
      return 'Good Morning';
    } else if (hourIn24HourFormate < 17) {
      // 17 = 5 pm
      return 'Good Afternoon';
    } else {
      return 'Good evening';
    }
  }

  Widget greetingImageAtTime(int hourIn24HourFormate) {
    String whatImageToShow = '';
    if (hourIn24HourFormate < 5) {
      whatImageToShow = 'assets/images/moon.png';
    } else if (hourIn24HourFormate < 19) {
      whatImageToShow = 'assets/images/sun.png';
    } else {
      whatImageToShow = 'assets/images/moon.png';
    }

    return Image.asset(
      whatImageToShow,
      width: 20,
      height: 20,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  var gridCards = [
    'Issues assigned to you',
    'Pending Issues',
    'Completed Issues',
    'Due by this week'
  ];
  var gridCardKeys = [
    'assigned_issues_count',
    'pending_issues_count',
    'completed_issues_count',
    'issues_due_week_count'
  ];
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var dashboardProvider = ref.watch(ProviderList.dashboardProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: headerWidget(),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.65, //ToDo : make it better
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const OnBoardingScreen()));
                        },
                        child: CustomText(
                          '${greetAtTime(DateTime.now().hour)}, ${profileProvider.userProfile.firstName ?? 'User name'}',
                          type: FontStyle.H5,
                          fontWeight: FontWeightt.Semibold,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          greetingImageAtTime(DateTime.now().hour),
                          const SizedBox(width: 5),
                          CustomText(
                            //DateFormat('EEEE, MMM dd  hh:mm ').format(DateTime.now()),
                            DateFormat('EEEE, MMM dd,')
                                .add_jm()
                                .format(DateTime.now()),
                            type: FontStyle.XSmall,
                            fontWeight: FontWeightt.Medium,
                            color:
                                themeProvider.themeManager.placeholderTextColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            dashboardProvider.hideGithubBlock == false
                ? Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: themeProvider
                                .themeManager.secondaryBackgroundDefaultColor),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: CustomText(
                                    'Plane is open source, support us by staring us on GitHub.',
                                    type: FontStyle.Medium,
                                    fontWeight: FontWeightt.Medium,
                                    textAlign: TextAlign.start,
                                    color: themeProvider
                                        .themeManager.primaryTextColor,
                                    overflow: TextOverflow.visible,
                                    maxLines: 5,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      dashboardProvider.hideGithubBlock = true;
                                    });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: themeProvider
                                        .themeManager.secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          themeProvider.theme == THEME.custom
                                              ? themeProvider.themeManager.tertiaryBackgroundDefaultColor
                                              : themeProvider.themeManager
                                                  .primaryTextColor,
                                      elevation: 0),
                                  onPressed: () async {
                                    //redirect to github using url launcher.
                                    try {
                                      var url = Uri.parse(
                                          'https://github.com/makeplane/plane-mobile');

                                      await launchUrl(url);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.redAccent,
                                          content: Text(
                                              'Something went wrong !',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      );
                                    }
                                  },
                                  child: CustomText(
                                    'Star us on GitHub',
                                    type: FontStyle.Small,
                                    fontWeight: FontWeightt.Medium,
                                    color: themeProvider.theme == THEME.dark ||
                                            themeProvider.theme ==
                                                THEME.darkHighContrast
                                        ? Colors.black
                                        : themeProvider.theme == THEME.custom
                                            ? themeProvider.themeManager
                                                .secondaryBackgroundDefaultColor
                                            : Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 35,
                        child: Image.asset(
                          themeProvider.theme == THEME.dark ||
                                  themeProvider.theme == THEME.darkHighContrast
                              ? 'assets/images/github.png'
                              : 'assets/images/github_black.png',
                          width: 70,
                          height: 70,
                        ),
                      ),
                    ],
                  )
                : Container(),
            const SizedBox(
              height: 20,
            ),
            projectProvider.projects.isEmpty &&
                    projectProvider.projectState != StateEnum.loading
                ? Container(
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(63, 118, 255, 0.05),
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          'Create a project',
                          type: FontStyle.H5,
                          fontWeight: FontWeightt.Semibold,
                        ),
                        const SizedBox(height: 10),
                        CustomText(
                          'Manage your projects by creating issues, cycles, modules, views and pages.',
                          type: FontStyle.Small,
                          color: themeProvider.themeManager.tertiaryTextColor,
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateProject()));
                          },
                          child: Container(
                            height: 45,
                            width: 120,
                            //margin: const EdgeInsets.only(top: 30),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color.fromRGBO(63, 118, 255, 1),
                            ),
                            child: const CustomText(
                              'Create Project',
                              type: FontStyle.Small,
                              fontWeight: FontWeightt.Medium,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
            projectProvider.projects.isNotEmpty
                ? GridView.builder(
                    itemCount: 4,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height * 0.25)),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: themeProvider
                                  .themeManager.borderSubtle01Color),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                gridCards[index],
                                type: FontStyle.XSmall,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomText(
                                dashboardProvider.dashboardData[
                                            gridCardKeys[index]] !=
                                        null
                                    ? '${dashboardProvider.dashboardData[gridCardKeys[index]]}'
                                    : '0',
                                type: FontStyle.H4,
                                fontWeight: FontWeightt.Bold,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget headerWidget() {
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom:
              BorderSide(color: themeProvider.themeManager.borderDisabledColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                enableDrag: true,
                constraints: BoxConstraints(
                    minHeight: height * 0.5,
                    maxHeight: MediaQuery.of(context).size.height * 0.8),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
                context: context,
                builder: (ctx) {
                  return const SelectWorkspace();
                },
              ).then((value) {
                ref
                    .read(ProviderList.myIssuesProvider)
                    .getMyIssuesView()
                    .then((value) {
                  ref.read(ProviderList.myIssuesProvider).filterIssues();
                });
              });
            },
            child: Row(
              children: [
                workspaceProvider.selectedWorkspace == null
                    ? Container()
                    : workspaceProvider.selectedWorkspace!.workspaceLogo != ''
                        ? CachedNetworkImage(
                            height: 35,
                            width: 35,
                            fit: BoxFit.fill,
                            imageUrl: workspaceProvider
                                .selectedWorkspace!.workspaceLogo,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: primaryColor,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Center(
                                child: CustomText(
                                  workspaceProvider
                                      .selectedWorkspace!.workspaceName[0]
                                      .toUpperCase(),
                                  type: FontStyle.Medium,
                                  fontWeight: FontWeightt.Bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: primaryColor,
                            ),
                            child: Center(
                              child: CustomText(
                                workspaceProvider
                                    .selectedWorkspace!.workspaceName[0]
                                    .toUpperCase(),
                                type: FontStyle.Medium,
                                fontWeight: FontWeightt.Bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                const SizedBox(
                  width: 10,
                ),
                CustomText(
                  workspaceProvider.selectedWorkspace!.workspaceName,
                  type: FontStyle.H4,
                  fontWeight: FontWeightt.Semibold,
                ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SetupWorkspace(
                                fromHomeScreen: true,
                              )));
                },
                child: CircleAvatar(
                  backgroundColor: themeProvider
                      .themeManager.primaryBackgroundSelectedColour,
                  radius: 20,
                  child: Icon(
                    size: 20,
                    Icons.add,
                    color: themeProvider.themeManager.secondaryTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GlobalSearchSheet()));
                },
                child: CircleAvatar(
                  backgroundColor: themeProvider
                      .themeManager.primaryBackgroundSelectedColour,
                  radius: 20,
                  child: Icon(
                    size: 20,
                    Icons.search,
                    color: themeProvider.themeManager.secondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
