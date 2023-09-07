import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/utils/timezone_manager.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_progress_bar.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/loading_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../../bottom_sheets/project_select_cover_image.dart';
import '../../../provider/profile_provider.dart';
import '../../../utils/constants.dart';

class MemberProfile extends ConsumerStatefulWidget {
  const MemberProfile({required this.userID, super.key});
  final String userID;
  @override
  ConsumerState<MemberProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends ConsumerState<MemberProfile> {
  Map profileData = {
    'Username': '',
    'Joined on': '',
    'Timezone': '',
    'Status': 'Online',
  };
  List projectData = [
    {
      'name': 'Created',
      'color': const Color.fromRGBO(32, 59, 128, 1),
      'key': 'created_issues'
    },
    {
      'name': 'Assigned',
      'color': const Color.fromRGBO(63, 118, 255, 1),
      'key': 'assigned_issues'
    },
    {
      'name': 'Due',
      'color': const Color.fromRGBO(245, 158, 11, 1),
      'key': 'pending_issues'
    },
    {
      'name': 'Completed',
      'color': const Color.fromRGBO(22, 163, 74, 1),
      'key': 'completed_issues'
    },
  ];
  List<bool> expanded = [];
  @override
  void initState() {
    var memberprofileProvider =
        ref.read(ProviderList.memberProfileProvider.notifier);
    memberprofileProvider.getMemberProfile(userID: widget.userID).then((value) {
      profileData['Username'] = value['user_data']['display_name'];
      profileData['Joined on'] = DateFormat('MMM dd, yyyy')
          .format(DateTime.parse(value['user_data']['date_joined']));
      profileData['Timezone'] = value['user_data']['user_timezone'];

      expanded = List.generate(value['project_data'].length, (index) => false);
      // profileData['Status'] = value.memberProfile['profile_data']['status'];
    });
    var themeProv = ref.read(ProviderList.themeProvider);
    themeProv.setUiOverlayStyle(fromTHEME(theme: themeProv.theme));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.read(ProviderList.themeProvider);
    var memberprofileProvider = ref.watch(ProviderList.memberProfileProvider);
    ProfileProvider profileProv = ref.watch(ProviderList.profileProvider);

    //log(memberprofileProvider.getMemberProfileState.name);
    log(profileProv.userProfile.toString());

    return Scaffold(
      appBar: CustomAppBar(
          onPressed: () {
            Navigator.pop(context);
          },
          text: 'Profile'),
      body: SafeArea(
        child: LoadingWidget(
          loading:
              memberprofileProvider.getMemberProfileState == StateEnum.loading,
          widgetClass: memberprofileProvider.getMemberProfileState ==
                  StateEnum.loading
              ? Container()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          profileProv.updateProfileState == StateEnum.loading
                              ? Shimmer.fromColors(
                                  baseColor: themeProvider.themeManager
                                      .secondaryBackgroundDefaultColor,
                                  highlightColor: themeProvider
                                      .themeManager.borderSubtle01Color,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 30),
                                    color: themeProvider.themeManager
                                        .secondaryBackgroundDefaultColor,
                                    height: 140,
                                    width: MediaQuery.sizeOf(context).width,
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.only(bottom: 30),
                                  height: 140,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: memberprofileProvider.memberProfile[
                                                        'user_data']
                                                    ['cover_image'] !=
                                                null &&
                                            memberprofileProvider
                                                .memberProfile['user_data']
                                                    ['cover_image']
                                                .toString()
                                                .isNotEmpty
                                        ? DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                                memberprofileProvider
                                                            .memberProfile[
                                                        'user_data']
                                                    ['cover_image']!))
                                        : DecorationImage(
                                            fit: BoxFit.cover,
                                            image:
                                                Image.asset('assets/cover.png')
                                                    .image,
                                          ),
                                  ),
                                ),
                          Positioned(
                            left: 20,
                            bottom: 0,
                            child: Container(
                                height: 60,
                                width: 60,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    image: memberprofileProvider.memberProfile['user_data']['avatar'] != null &&
                                            memberprofileProvider.memberProfile['user_data']['avatar']
                                                .toString()
                                                .isNotEmpty
                                        ? DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                                memberprofileProvider.memberProfile['user_data']
                                                    ['avatar']!))
                                        : null,
                                    color: memberprofileProvider.memberProfile['user_data']['avatar'] != null &&
                                            memberprofileProvider.memberProfile['user_data']['avatar']
                                                .toString()
                                                .isNotEmpty
                                        ? null
                                        : const Color.fromRGBO(55, 65, 81, 1),
                                    borderRadius: BorderRadius.circular(4)),
                                child: memberprofileProvider.memberProfile['user_data']['avatar'] == null ||
                                        memberprofileProvider.memberProfile['user_data']['avatar'].toString().isEmpty
                                    ? CustomText(
                                        memberprofileProvider
                                            .memberProfile['user_data']
                                                ['first_name'][0]
                                            .toString()
                                            .toUpperCase(),
                                        color: Colors.white,
                                        type: FontStyle.H4,
                                        fontWeight: FontWeightt.Semibold,
                                      )
                                    : null),
                          ),
                          profileProv.userProfile.id == widget.userID
                              ? Positioned(
                                  right: 20,
                                  top: 20,
                                  child: GestureDetector(
                                    onTap: () async {
                                      Map<String, dynamic> url = {};
                                      await showModalBottomSheet(
                                          isScrollControlled: true,
                                          enableDrag: true,
                                          constraints: BoxConstraints(
                                              maxHeight: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.85),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30),
                                            ),
                                          ),
                                          context: context,
                                          builder: (ctx) {
                                            return SelectCoverImage(
                                              uploadedUrl: url,
                                            );
                                          });
                                      if (url['url'] == null) {
                                        return;
                                      }

                                      await profileProv.updateProfile(data: {
                                        'cover_image': url['url'],
                                      }).then((value) {
                                        if (profileProv.updateProfileState ==
                                            StateEnum.error) {
                                          CustomToast.showToast(
                                              context,
                                             message: 'Failed to update profile',
                          
                                              toastType: ToastType.failure);
                                        } else {
                                          setState(() {
                                            memberprofileProvider
                                                    .memberProfile['user_data']
                                                ['cover_image'] = url['url'];
                                          });
                                        }
                                      });
                                    },
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          color: themeProvider.themeManager
                                              .secondaryBackgroundDefaultColor,
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: themeProvider
                                            .themeManager.tertiaryTextColor,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 20, top: 20, bottom: 10),
                        child: CustomText(
                          memberprofileProvider.memberProfile['user_data']
                                  ['first_name'] +
                              memberprofileProvider.memberProfile['user_data']
                                  ['last_name'],
                          color: themeProvider.themeManager.primaryTextColor,
                          type: FontStyle.H6,
                          fontWeight: FontWeightt.Semibold,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, bottom: 30),
                        child: CustomText(
                          memberprofileProvider.memberProfile['user_data']
                              ['display_name'],
                          color: themeProvider.themeManager.tertiaryTextColor,
                          type: FontStyle.Small,
                          fontWeight: FontWeightt.Regular,
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: profileData.length - 1,
                          itemBuilder: (ctx, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, bottom: 10),
                                      child: CustomText(
                                        profileData.keys.toList()[index],
                                        color: themeProvider
                                            .themeManager.placeholderTextColor,
                                        type: FontStyle.Small,
                                        fontWeight: FontWeightt.Regular,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, bottom: 10),
                                      child: CustomText(
                                        (index == 2
                                                ? TimeZoneManager
                                                        .getTimeForTimeZone(
                                                            profileData.values
                                                                        .toList()[
                                                                    index] ??
                                                                '')
                                                    .toString()
                                                : '') +
                                            profileData.values.toList()[index],
                                        color: themeProvider
                                            .themeManager.secondaryTextColor,
                                        type: FontStyle.Small,
                                        fontWeight: FontWeightt.Medium,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: memberprofileProvider
                              .memberProfile['project_data'].length,
                          itemBuilder: (ctx, index) {
                            int assignedIssues = memberprofileProvider
                                    .memberProfile['project_data'][index]
                                ['assigned_issues'];
                            int completedIssues = memberprofileProvider
                                    .memberProfile['project_data'][index]
                                ['completed_issues'];

                            int percentage = assignedIssues == 0
                                ? 0
                                : double.parse(
                                        ((completedIssues / assignedIssues) *
                                                100)
                                            .toString())
                                    .round();
                            return Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                children: [
                                  Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: themeProvider
                                        .themeManager.borderSubtle01Color,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        expanded[index] = !expanded[index];
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: memberprofileProvider
                                                              .memberProfile[
                                                          'project_data'][index]
                                                      ['icon_prop'] !=
                                                  null
                                              ? Icon(
                                                  iconList[memberprofileProvider
                                                              .memberProfile[
                                                          'project_data'][index]
                                                      ['icon_prop']['name']],
                                                  color: themeProvider
                                                      .themeManager
                                                      .primaryTextColor,
                                                )
                                              : CustomText(
                                                  int.tryParse(memberprofileProvider
                                                              .memberProfile[
                                                                  'project_data']
                                                                  [index]
                                                                  ['emoji']
                                                              .toString()) !=
                                                          null
                                                      ? String.fromCharCode(int.parse(
                                                          memberprofileProvider
                                                                      .memberProfile[
                                                                  'project_data']
                                                              [index]['emoji']))
                                                      : '🚀',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width -
                                                  180,
                                          child: CustomText(
                                            memberprofileProvider.memberProfile[
                                                'project_data'][index]['name'],
                                            type: FontStyle.Small,
                                            fontWeight: FontWeightt.Medium,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const Spacer(),
                                        assignedIssues == 0
                                            ? Container()
                                            : Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                height: 23,
                                                width: 40,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: assignedIssues == 0
                                                        ? themeProvider
                                                            .themeManager
                                                            .successBackgroundColor
                                                        : percentage <= 35
                                                            ? const Color
                                                                    .fromRGBO(
                                                                254,
                                                                226,
                                                                226,
                                                                1)
                                                            : percentage <= 70
                                                                ? themeProvider
                                                                    .themeManager
                                                                    .textWarningColor
                                                                : themeProvider
                                                                    .themeManager
                                                                    .successBackgroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: CustomText(
                                                  "${assignedIssues == 0 ? '100' : percentage.toString()}%",
                                                  type: FontStyle.overline,
                                                  color: assignedIssues == 0
                                                      ? const Color.fromRGBO(
                                                          34, 197, 94, 1)
                                                      : percentage <= 35
                                                          ? themeProvider
                                                              .themeManager
                                                              .textErrorColor
                                                          : percentage <= 70
                                                              ? const Color
                                                                      .fromRGBO(
                                                                  245,
                                                                  158,
                                                                  11,
                                                                  1)
                                                              : const Color
                                                                      .fromRGBO(
                                                                  34,
                                                                  197,
                                                                  94,
                                                                  1),
                                                  fontWeight:
                                                      FontWeightt.Medium,
                                                ),
                                              ),
                                        Icon(
                                          expanded[index]
                                              ? Icons.arrow_drop_up_rounded
                                              : Icons.arrow_drop_down_rounded,
                                          color: themeProvider
                                              .themeManager.tertiaryTextColor,
                                        )
                                      ],
                                    ),
                                  ),
                                  expanded[index]
                                      ? Column(
                                          children: [
                                            memberprofileProvider.memberProfile[
                                                                    'project_data']
                                                                [index][
                                                            projectData[0]
                                                                ['key']] ==
                                                        0 &&
                                                    memberprofileProvider
                                                                    .memberProfile[
                                                                'project_data'][index]
                                                            [projectData[1]
                                                                ['key']] ==
                                                        0
                                                ? Container()
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 25,
                                                            bottom: 10),
                                                    child: CustomProgressBar
                                                        .withColorOverride(
                                                            width: width,
                                                            itemValue: [
                                                          memberprofileProvider
                                                                      .memberProfile[
                                                                  'project_data'][index]
                                                              [projectData[0]
                                                                  ['key']],
                                                          memberprofileProvider
                                                                      .memberProfile[
                                                                  'project_data'][index]
                                                              [projectData[1]
                                                                  ['key']],
                                                          memberprofileProvider
                                                                      .memberProfile[
                                                                  'project_data'][index]
                                                              [projectData[2]
                                                                  ['key']],
                                                          memberprofileProvider
                                                                      .memberProfile[
                                                                  'project_data'][index]
                                                              [projectData[3]
                                                                  ['key']],
                                                        ],
                                                            itemColors: [
                                                          projectData[0]
                                                              ['color'],
                                                          projectData[1]
                                                              ['color'],
                                                          projectData[2]
                                                              ['color'],
                                                          projectData[3]
                                                              ['color'],
                                                        ]),
                                                  ),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: projectData.length,
                                                itemBuilder: (ctx, i) {
                                                  return Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 30,
                                                                  right: 10),
                                                          height: 12,
                                                          width: 12,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  projectData[i]
                                                                      ['color'],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(),
                                                          child: CustomText(
                                                            projectData[i]
                                                                ['name'],
                                                            color: themeProvider
                                                                .themeManager
                                                                .placeholderTextColor,
                                                            type:
                                                                FontStyle.Small,
                                                            fontWeight:
                                                                FontWeightt
                                                                    .Regular,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                            right: 30,
                                                          ),
                                                          child: CustomText(
                                                            "${memberprofileProvider.memberProfile['project_data'][index][projectData[i]['key']]} Issues",
                                                            color: themeProvider
                                                                .themeManager
                                                                .tertiaryTextColor,
                                                            type:
                                                                FontStyle.Small,
                                                            fontWeight:
                                                                FontWeightt
                                                                    .Medium,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ],
                                        )
                                      : Container(),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  index ==
                                          memberprofileProvider
                                                  .memberProfile['project_data']
                                                  .length -
                                              1
                                      ? Container(
                                          height: 1,
                                          width: double.infinity,
                                          color: themeProvider
                                              .themeManager.borderSubtle01Color,
                                        )
                                      : Container(),
                                ],
                              ),
                            );
                          }),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
