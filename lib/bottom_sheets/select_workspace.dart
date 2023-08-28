// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/screens/on_boarding/auth/setup_workspace.dart';
import 'package:plane_startup/utils/color_manager.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:plane_startup/provider/provider_list.dart';

class SelectWorkspace extends ConsumerStatefulWidget {
  const SelectWorkspace({super.key});

  @override
  ConsumerState<SelectWorkspace> createState() => _SelectWorkspaceState();
}

class _SelectWorkspaceState extends ConsumerState<SelectWorkspace> {
  double height = 0;
  var colors = [
    const Color.fromRGBO(48, 0, 240, 1),
    const Color.fromRGBO(209, 88, 0, 1),
    const Color.fromRGBO(167, 0, 209, 1),
  ];
  @override
  Widget build(BuildContext context) {
    var prov = ref.watch(ProviderList.workspaceProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var box = context.findRenderObject() as RenderBox;
      height = box.size.height;
    });
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        //color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      width: double.infinity,
      child: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    'Workspace',
                    type: FontStyle.H4,
                    fontWeight: FontWeightt.Semibold,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: themeProvider.themeManager.placeholderTextColor,
                    ),
                  ),
                ],
              ),
              Container(
                height: 15,
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: prov.workspaces.length,
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTap: () async {
                        await prov
                            .selectWorkspace(id: prov.workspaces[index]["id"])
                            .then(
                          (value) async {
                            ref.read(ProviderList.cyclesProvider).clearData();
                            ref.read(ProviderList.modulesProvider).clearData();
                            ref.read(ProviderList.myIssuesProvider).clear();
                            ref.read(ProviderList.activityProvider).clear();
                            ref.read(ProviderList.projectProvider).getProjects(
                                slug: ref
                                    .read(ProviderList.workspaceProvider)
                                    .workspaces
                                    .where((element) =>
                                        element['id'] ==
                                        profileProvider
                                            .userProfile.lastWorkspaceId)
                                    .first['slug']);
                            // ref
                            //     .read(ProviderList.projectProvider)
                            //     .favouriteProjects(
                            //       index: 0,
                            //       slug: ref
                            //           .read(ProviderList.workspaceProvider)
                            //           .workspaces
                            //           .where((element) =>
                            //               element['id'] ==
                            //               profileProvider
                            //                   .userProfile.lastWorkspaceId)
                            //           .first['slug'],
                            //       method: HttpMethod.get,
                            //       projectID: "",
                            //     );
                            await ref
                                .read(ProviderList.myIssuesProvider)
                                .getMyIssuesView();
                            ref
                                .read(ProviderList.myIssuesProvider)
                                .filterIssues(assigned: true);
                            ref
                                .watch(ProviderList.myIssuesProvider)
                                .getLabels();

                            ref
                                .read(ProviderList.notificationProvider)
                                .getUnreadCount();

                            ref
                                .read(ProviderList.notificationProvider)
                                .getNotifications(type: 'assigned');
                            ref
                                .read(ProviderList.notificationProvider)
                                .getNotifications(type: 'created');
                            ref
                                .read(ProviderList.notificationProvider)
                                .getNotifications(type: 'watching');
                            ref
                                .read(ProviderList.notificationProvider)
                                .getNotifications(
                                    type: 'unread', getUnread: true);
                            ref
                                .read(ProviderList.notificationProvider)
                                .getNotifications(
                                    type: 'archived', getArchived: true);
                            ref
                                .read(ProviderList.notificationProvider)
                                .getNotifications(
                                    type: 'snoozed', getSnoozed: true);
                          },
                        );

                        ///
                        Navigator.of(context).pop();
                      },
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            color: Colors.transparent,
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              children: [
                                prov.workspaces[index]['logo'] == null ||
                                        prov.workspaces[index]['logo'] == ''
                                    ? Container(
                                        height: 35,
                                        width: 35,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color:
                                                ColorManager.getColorWithIndex(
                                                    index),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: CustomText(
                                          prov.workspaces[index]['name']
                                              .toString()
                                              .toUpperCase()[0],
                                          type: FontStyle.Medium,
                                          fontWeight: FontWeightt.Semibold,
                                          // fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          overrride: true,
                                        ))
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: CachedNetworkImage(
                                          height: 35,
                                          width: 35,
                                          fit: BoxFit.fill,
                                          imageUrl: prov.workspaces[index]
                                                  ['logo']
                                              .toString(),
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                  height: 35,
                                                  width: 35,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: colors[
                                                          Random().nextInt(3)],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: CustomText(
                                                    prov.workspaces[index]
                                                            ['name']
                                                        .toString()
                                                        .toUpperCase()[0],
                                                    type: FontStyle.Medium,
                                                    fontWeight:
                                                        FontWeightt.Semibold,
                                                    // fontWeight: FontWeight.w400,
                                                    color: Colors.white,
                                                  )),
                                        ),

                                        //     Image.network(
                                        //   prov.workspaces[index]['logo']
                                        //       .toString(),
                                        //   width: 35,
                                        //   height: 35,
                                        //   fit: BoxFit.cover,
                                        // ),
                                      ),
                                const SizedBox(
                                  width: 10,
                                ),
                                CustomText(
                                  prov.workspaces[index]['name'],
                                  type: FontStyle.H5,
                                  color: themeProvider
                                      .themeManager.tertiaryTextColor,
                                ),
                                const Spacer(),
                                ref
                                            .read(ProviderList.profileProvider)
                                            .userProfile
                                            .lastWorkspaceId ==
                                        prov.workspaces[index]['id']
                                    ? const Icon(
                                        Icons.done,
                                        color: Color.fromRGBO(9, 169, 83, 1),
                                      )
                                    : Container(),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 2,
                            margin: const EdgeInsets.only(bottom: 15),
                            color:
                                themeProvider.themeManager.borderDisabledColor,
                          )
                        ],
                      ),
                    );
                  }),
              Container(
                height: 5,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const SetupWorkspace(
                            fromHomeScreen: true,
                          )));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: themeProvider.themeManager.primaryColour,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    CustomText(
                      'Create Workspace',
                      type: FontStyle.H5,
                      color: themeProvider.themeManager.primaryColour,
                    ),
                  ],
                ),
              ),
              Container(
                height: 20,
              ),
            ],
          ),
          prov.selectWorkspaceState == StateEnum.loading ||
                  ref.watch(ProviderList.myIssuesProvider).myIssuesViewState ==
                      StateEnum.loading
              ? Container(
                  height: height - 32,
                  alignment: Alignment.center,
                  color: themeProvider.theme == THEME.dark ||
                          themeProvider.theme == THEME.darkHighContrast
                      ? themeProvider.themeManager.primaryBackgroundDefaultColor
                          .withOpacity(0.7)
                      : themeProvider.themeManager.primaryBackgroundDefaultColor
                          .withOpacity(0.7),
                  // height: 25,
                  // width: 25,
                  child: Center(
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineSpinFadeLoader,
                        colors: [
                          themeProvider.theme == THEME.dark ||
                                  themeProvider.theme == THEME.darkHighContrast
                              ? Colors.white
                              : Colors.black
                        ],
                        strokeWidth: 1.0,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
