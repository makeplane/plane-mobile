import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane_startup/bottom_sheets/global_search_sheet.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/IssuesTab/create_issue.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/IssuesTab/issue_detail_screen.dart';
import 'package:plane_startup/screens/MainScreens/Projects/create_project_screen.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_rich_text.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/empty.dart';

class MyIssuesScreen extends ConsumerStatefulWidget {
  const MyIssuesScreen({super.key});

  @override
  ConsumerState<MyIssuesScreen> createState() => _MyIssuesScreenState();
}

class _MyIssuesScreenState extends ConsumerState<MyIssuesScreen> {
  @override
  Widget build(BuildContext context) {
    var myIssuesProvider = ref.watch(ProviderList.myIssuesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    return Scaffold(
      appBar: CustomAppBar(
        text: 'My Issues',
        onPressed: () {},
        leading: false,
        elevation: false,
        centerTitle: false,
        fontType: FontStyle.mainHeading,
        actions: [
          workspaceProvider.role != Role.admin &&
                  workspaceProvider.role != Role.member
              ? Container()
              : GestureDetector(
                  onTap: () async {
                    if (ref
                        .watch(ProviderList.projectProvider)
                        .projects
                        .isEmpty) {
                      CustomToast().showSimpleToast(
                          'You dont have any projects yet, try creating one');
                    } else {
                      ref.watch(ProviderList.projectProvider).currentProject =
                          ref.watch(ProviderList.projectProvider).projects[0];
                      ref.watch(ProviderList.projectProvider).setState();
                      await ref
                          .read(ProviderList.projectProvider)
                          .initializeProject();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateIssue(),
                        ),
                      );
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: themeProvider.isDarkThemeEnabled
                        ? darkSecondaryBGC
                        : lightGreeyColor,
                    radius: 20,
                    child: Icon(
                      size: 20,
                      Icons.add,
                      color: !themeProvider.isDarkThemeEnabled
                          ? Colors.black
                          : Colors.white,
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
              backgroundColor: themeProvider.isDarkThemeEnabled
                  ? darkSecondaryBGC
                  : lightGreeyColor,
              radius: 20,
              child: Icon(
                size: 20,
                Icons.search,
                color: !themeProvider.isDarkThemeEnabled
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: myIssuesProvider.data.isEmpty
                ? EmptyPlaceholder.emptyIssues(context)
                : ListView.builder(
                    itemCount: myIssuesProvider.data.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              ref
                                      .watch(ProviderList.projectProvider)
                                      .currentProject =
                                  myIssuesProvider.data[index]
                                      ['project_detail'];
                              ref
                                  .watch(ProviderList.projectProvider)
                                  .setState();
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return IssueDetail(
                                  appBarTitle: myIssuesProvider.data[index]
                                      ['name'],
                                  issueId: myIssuesProvider.data[index]['id'],
                                );
                              }));
                            },
                            child: Container(
                              width: width,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 16),
                              child: Row(
                                children: [
                                  myIssuesProvider.data[index]['state_detail']['group'] ==
                                          'backlog'
                                      ? SvgPicture.asset(
                                          height: 20,
                                          width: 20,
                                          'assets/svg_images/circle.svg',
                                          colorFilter: ColorFilter.mode(
                                              Color(int.parse(myIssuesProvider
                                                  .data[index]['state_detail']
                                                      ['color']
                                                  .toString()
                                                  .replaceAll('#', '0xFF'))),
                                              BlendMode.srcIn))
                                      : myIssuesProvider.data[index]
                                                  ['state_detail']['group'] ==
                                              'cancelled'
                                          ? SvgPicture.asset(
                                              height: 20,
                                              width: 20,
                                              'assets/svg_images/cancelled.svg',
                                              colorFilter: ColorFilter.mode(
                                                  Color(int.parse(myIssuesProvider.data[index]['state_detail']['color'].toString().replaceAll('#', '0xFF'))),
                                                  BlendMode.srcIn))
                                          : myIssuesProvider.data[index]['state_detail']['group'] == 'completed'
                                              ? SvgPicture.asset(height: 20, width: 20, 'assets/svg_images/done.svg', colorFilter: ColorFilter.mode(Color(int.parse(myIssuesProvider.data[index]['state_detail']['color'].toString().replaceAll('#', '0xFF'))), BlendMode.srcIn))
                                              : myIssuesProvider.data[index]['state_detail']['group'] == 'started'
                                                  ? SvgPicture.asset(height: 20, width: 20, 'assets/svg_images/in_progress.svg', colorFilter: ColorFilter.mode(Color(int.parse(myIssuesProvider.data[index]['state_detail']['color'].toString().replaceAll('#', '0xFF'))), BlendMode.srcIn))
                                                  : SvgPicture.asset(height: 20, width: 20, 'assets/svg_images/circle.svg', colorFilter: ColorFilter.mode(Color(int.parse(myIssuesProvider.data[index]['state_detail']['color'].toString().replaceAll('#', '0xFF'))), BlendMode.srcIn)),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  CustomRichText(
                                    //ype: RichFontStyle.title,
                                    fontSize: 14,
                                    color: themeProvider.isDarkThemeEnabled
                                        ? Colors.grey.shade400
                                        : darkBackgroundColor,
                                    fontWeight: FontWeight.w500,
                                    widgets: [
                                      TextSpan(
                                          text: myIssuesProvider.data[index]
                                              ['project_detail']['identifier'],
                                          style: TextStyle(
                                            color:
                                                themeProvider.isDarkThemeEnabled
                                                    ? darkSecondaryTextColor
                                                    : lightSecondaryTextColor,
                                          )),
                                      TextSpan(
                                          text:
                                              '-${myIssuesProvider.data[index]['sequence_id']}',
                                          style: TextStyle(
                                            color:
                                                themeProvider.isDarkThemeEnabled
                                                    ? darkSecondaryTextColor
                                                    : lightSecondaryTextColor,
                                          )),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: CustomText(
                                      myIssuesProvider.data[index]['name'],
                                      maxLines: 1,
                                      type: FontStyle.description,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: themeProvider
                                                      .isDarkThemeEnabled
                                                  ? darkThemeBorder
                                                  : lightGreeyColor),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      height: 30,
                                      width: 30,
                                      child: myIssuesProvider.data[index]
                                                  ['priority'] ==
                                              null
                                          ? const Icon(
                                              Icons.do_disturb_alt_outlined,
                                              size: 18,
                                              color: greyColor,
                                            )
                                          : myIssuesProvider.data[index]
                                                          ['state_detail']
                                                      ['group'] ==
                                                  'cancelled'
                                              ? SvgPicture.asset(
                                                  width: 20,
                                                  height: 20,
                                                  'assets/svg_images/cancelled.svg',
                                                  colorFilter: ColorFilter.mode(
                                                      Color(int.parse(myIssuesProvider.data[index]['state_detail']['color'].toString().replaceAll('#', '0xFF'))),
                                                      BlendMode.srcIn))
                                              : myIssuesProvider.data[index]['state_detail']['group'] == 'completed'
                                                  ? SvgPicture.asset(width: 20, height: 20, 'assets/svg_images/done.svg', colorFilter: ColorFilter.mode(Color(int.parse(myIssuesProvider.data[index]['state_detail']['color'].toString().replaceAll('#', '0xFF'))), BlendMode.srcIn))
                                                  : myIssuesProvider.data[index]['state_detail']['group'] == 'started'
                                                      ? SvgPicture.asset(width: 20, height: 20, 'assets/svg_images/in_progress.svg', colorFilter: ColorFilter.mode(Color(int.parse(myIssuesProvider.data[index]['state_detail']['color'].toString().replaceAll('#', '0xFF'))), BlendMode.srcIn))
                                                      : SvgPicture.asset(width: 20, height: 20, 'assets/svg_images/circle.svg', colorFilter: ColorFilter.mode(Color(int.parse(myIssuesProvider.data[index]['state_detail']['color'].toString().replaceAll('#', '0xFF'))), BlendMode.srcIn))),
                                  // const SizedBox(
                                  //   width: 15,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            width: width,
                            color: themeProvider.isDarkThemeEnabled
                                ? darkThemeBorder
                                : strokeColor,
                          )
                        ],
                      );
                    }),
          ),
        ],
      ),
    );
  }
}
