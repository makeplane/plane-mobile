import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/bottom-sheets/delete_leave_project_sheet.dart';
import 'package:plane/bottom-sheets/emoji_sheet.dart';
import 'package:plane/bottom-sheets/project_select_cover_image.dart';

import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_divider.dart';
import 'package:plane/widgets/loading_widget.dart';

import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_text.dart';

class GeneralPage extends ConsumerStatefulWidget {
  const GeneralPage({super.key});

  @override
  ConsumerState<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends ConsumerState<GeneralPage> {
  String? selectedEmoji;
  bool showEmojis = false;
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController identifier = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isProjectPublic = true;
  List<String> emojisWidgets = [];
  bool isEmoji = false;
  String selectedColor = '#3A3A3A';
  Role? role;
  bool? expansionState;

  void generateEmojis() {
    for (int i = 0; i < emojis.length; i++) {
      setState(() {
        emojisWidgets.add(emojis[i]);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    generateEmojis();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final projectProvider = ref.watch(ProviderList.projectProvider);
      isEmoji = projectProvider.currentProject['emoji'] != null;
      name.text = projectProvider.projectDetailModel!.name!;
      description.text = projectProvider.projectDetailModel!.description!;
      setState(() {
        isProjectPublic = projectProvider.projectDetailModel!.network == 2;
      });

      identifier.text = projectProvider.projectDetailModel!.identifier!;
      getRole();
    });
  }

  void scrollDown() async {
    await Future.delayed(const Duration(milliseconds: 200));
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  bool updating = false;
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: LoadingWidget(
        loading: projectProvider.updateProjectState == StateEnum.loading,
        widgetClass: Container(
          color: themeProvider.themeManager.primaryBackgroundDefaultColor,
          padding: const EdgeInsets.only(
            left: 15,
            top: 20,
            right: 15,
          ),
          child: Stack(
            children: [
              ListView(
                controller: scrollController,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  Row(
                    children: [
                      CustomText(
                        'Icon & Name',
                        type: FontStyle.Small,
                        color: themeProvider.themeManager.tertiaryTextColor,
                      ),
                      CustomText(
                        '*',
                        type: FontStyle.Small,
                        color: themeProvider.themeManager.textErrorColor,
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  //row containing 2 containers one for icon, one textfield
                  Row(
                    children: [
                      //icon container
                      InkWell(
                        onTap: () {
                          if (checkUser()) {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              enableDrag: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.75,
                              ),
                              context: context,
                              builder: (ctx) {
                                return const EmojiSheet();
                              },
                            ).then((value) {
                              setState(() {
                                selectedEmoji = value['name'];
                                isEmoji = value['is_emoji'];
                                selectedColor = value['color'] ?? '#3A3A3A';
                              });

                              if (isEmoji) {
                                projectProvider.updateProject(
                                    slug: ref
                                        .read(ProviderList.workspaceProvider)
                                        .selectedWorkspace
                                        .workspaceSlug,
                                    projId:
                                        projectProvider.projectDetailModel!.id!,
                                    data: {
                                      'name': name.text,
                                      'description': description.text,
                                      'identifier': identifier.text,
                                      'network': isProjectPublic ? 2 : 0,
                                      'emoji': selectedEmoji,
                                      'icon_prop': null
                                    },
                                    ref: ref);
                              } else {
                                projectProvider.updateProject(
                                    slug: ref
                                        .read(ProviderList.workspaceProvider)
                                        .selectedWorkspace
                                        .workspaceSlug,
                                    projId:
                                        projectProvider.projectDetailModel!.id!,
                                    data: {
                                      'name': name.text,
                                      'description': description.text,
                                      'identifier': identifier.text,
                                      'network': isProjectPublic ? 2 : 0,
                                      'emoji': null,
                                      'icon_prop': {
                                        'name': selectedEmoji,
                                        'color': selectedColor,
                                      }
                                    },
                                    ref: ref);
                              }
                            });
                          }
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: themeProvider
                                .themeManager.tertiaryBackgroundDefaultColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: themeProvider
                                  .themeManager.borderSubtle01Color,
                            ),
                          ),
                          child: Center(
                            child: selectedEmoji != null
                                ? !isEmoji
                                    ? Icon(
                                        iconList[selectedEmoji],
                                        color: Color(
                                          int.parse(
                                            selectedColor
                                                .toString()
                                                .replaceAll('#', '0xFF'),
                                          ),
                                        ),
                                      )
                                    : CustomText(
                                        String.fromCharCode(
                                            int.parse(selectedEmoji!)),
                                        type: FontStyle.H6,
                                        fontWeight: FontWeightt.Semibold,
                                      )
                                : projectProvider.currentProject['icon_prop'] !=
                                        null
                                    ? Icon(
                                        iconList[projectProvider
                                                .currentProject['icon_prop']
                                            ['name']],
                                        color: Color(
                                          int.parse(
                                            projectProvider
                                                .currentProject['icon_prop']
                                                    ["color"]
                                                .toString()
                                                .replaceAll('#', '0xFF'),
                                          ),
                                        ),
                                      )
                                    : CustomText(
                                        projectProvider.projectDetailModel !=
                                                    null &&
                                                projectProvider
                                                        .projectDetailModel!
                                                        .emoji !=
                                                    null &&
                                                int.tryParse(projectProvider
                                                        .projectDetailModel!
                                                        .emoji!) !=
                                                    null
                                            ? String.fromCharCode(int.parse(
                                                projectProvider
                                                    .projectDetailModel!
                                                    .emoji!))
                                            : '🚀',
                                      ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),
                      //textfield
                      Expanded(
                        child: TextField(
                            enabled: checkUser() ? true : false,
                            style: !checkUser()
                                ? TextStyle(
                                    color: themeProvider
                                        .themeManager.tertiaryTextColor,
                                  )
                                : null,
                            controller: name,
                            decoration:
                                themeProvider.themeManager.textFieldDecoration),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CustomText(
                        'Description',
                        type: FontStyle.Small,
                        color: themeProvider.themeManager.tertiaryTextColor,
                      ),
                      CustomText(
                        '*',
                        type: FontStyle.Small,
                        color: themeProvider.themeManager.textErrorColor,
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  //textfield
                  TextField(
                      enabled: checkUser() ? true : false,
                      style: !checkUser()
                          ? TextStyle(
                              color:
                                  themeProvider.themeManager.tertiaryTextColor,
                            )
                          : null,

                      // readOnly: true,
                      controller: description,
                      maxLines: 4,
                      decoration: themeProvider.themeManager.textFieldDecoration
                          .copyWith(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15))),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CustomText(
                        'Cover',
                        type: FontStyle.Small,
                        color: themeProvider.themeManager.tertiaryTextColor,
                      ),
                      CustomText(
                        '*',
                        type: FontStyle.Small,
                        color: themeProvider.themeManager.textErrorColor,
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  //textfield
                  LoadingWidget(
                    loading: ref
                            .watch(ProviderList.fileUploadProvider)
                            .fileUploadState ==
                        StateEnum.loading,
                    widgetClass: Stack(
                      children: [
                        Container(
                          height: 150,
                          width: width,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: themeProvider
                                      .themeManager.borderSubtle01Color),
                              borderRadius: BorderRadius.circular(10)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              projectProvider.projectDetailModel!.coverImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        checkUser()
                            ? Positioned(
                                top: 15,
                                right: 15,
                                child: GestureDetector(
                                    onTap: () async {
                                      final Map<String, dynamic> url = {};

                                      await showModalBottomSheet(
                                          isScrollControlled: true,
                                          enableDrag: true,
                                          constraints: BoxConstraints(
                                              maxHeight: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.75),
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
                                      log(url.toString());
                                      setState(() {
                                        projectProvider.projectDetailModel!
                                                .coverImage =
                                            url['url'] ??
                                                projectProvider
                                                    .projectDetailModel!
                                                    .coverImage;
                                      });
                                    },
                                    child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: themeProvider.themeManager
                                              .primaryBackgroundDefaultColor,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.edit,
                                            color: themeProvider
                                                .themeManager.tertiaryTextColor,
                                            size: 20,
                                          ),
                                        ))))
                            : Container(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CustomText(
                        'Identifier',
                        type: FontStyle.Small,
                        color: themeProvider.themeManager.tertiaryTextColor,
                      ),
                      CustomText(
                        '*',
                        type: FontStyle.Small,
                        color: themeProvider.themeManager.textErrorColor,
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  //textfield
                  TextFormField(
                      enabled: checkUser() ? true : false,
                      style: !checkUser()
                          ? TextStyle(
                              color:
                                  themeProvider.themeManager.tertiaryTextColor,
                            )
                          : null,
                      controller: identifier,
                      maxLength: 12,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Z]')),
                      ],
                      decoration:
                          themeProvider.themeManager.textFieldDecoration),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CustomText(
                        'Network',
                        type: FontStyle.Small,
                        color: themeProvider.themeManager.tertiaryTextColor,
                      ),
                      CustomText(
                        '*',
                        type: FontStyle.Small,
                        color: themeProvider.themeManager.textErrorColor,
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      if (checkUser()) {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          enableDrag: true,
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.85),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          )),
                          context: context,
                          builder: (ctx) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 25),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      const CustomText(
                                        'Network',
                                        type: FontStyle.H4,
                                        fontWeight: FontWeightt.Semibold,
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: themeProvider.themeManager
                                              .placeholderTextColor,
                                        ),
                                      ),
                                      const SizedBox(width: 5)
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  selectionCard(
                                      title: 'Private',
                                      isSelected: !isProjectPublic,
                                      onTap: () {
                                        setState(() {
                                          isProjectPublic = false;
                                        });
                                        Navigator.of(context).pop();
                                      }),
                                  //const SizedBox(height: 5),
                                  CustomDivider(themeProvider: themeProvider),
                                  //const SizedBox(height: 5),
                                  selectionCard(
                                      title: 'Public',
                                      isSelected: isProjectPublic,
                                      onTap: () {
                                        setState(() {
                                          isProjectPublic = true;
                                        });
                                        Navigator.of(context).pop();
                                      }),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: themeProvider.themeManager.borderSubtle01Color,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomText(
                            isProjectPublic ? 'Public' : 'Private',
                            type: FontStyle.Medium,
                            fontWeight: FontWeightt.Regular,
                            color: themeProvider.themeManager.primaryTextColor,
                          ),
                          const Spacer(),
                          checkUser()
                              ? Icon(Icons.keyboard_arrow_down,
                                  color: themeProvider
                                      .themeManager.primaryTextColor)
                              : Container()
                        ],
                      ),
                    ),
                  ),

                  !checkUser() ? const SizedBox(height: 10) : Container(),

                  !checkUser()
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                //light redzz
                                // color: Colors.red[00],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: expansionState == true
                                      ? themeProvider
                                          .themeManager.textErrorColor
                                      : themeProvider
                                          .themeManager.borderSubtle01Color,
                                ),
                              ),
                              child: ExpansionTile(
                                onExpansionChanged: (value) async {
                                  scrollDown();
                                  setState(() {
                                    expansionState = value;
                                  });
                                },
                                childrenPadding: const EdgeInsets.only(
                                    left: 15, right: 15, bottom: 10),
                                iconColor:
                                    themeProvider.themeManager.primaryTextColor,
                                collapsedIconColor:
                                    themeProvider.themeManager.primaryTextColor,
                                backgroundColor: Colors.transparent,
                                collapsedBackgroundColor: Colors.transparent,
                                title: CustomText(
                                  'Danger Zone',
                                  textAlign: TextAlign.left,
                                  type: FontStyle.H5,
                                  color: themeProvider
                                      .themeManager.primaryTextColor,
                                  fontWeight: FontWeightt.Semibold,
                                ),
                                children: [
                                  CustomText(
                                    getRole() == Role.admin
                                        ? 'The danger zone of the project delete page is a critical area that requires careful consideration and attention. When deleting a project, all of the data and resources within that project will be permanently removed and cannot be recovered.'
                                        : 'Departing from the project implies a loss of access to future updates and project data. However, your existing issue data will remain secure within the "My Issues" section. Rejoining is feasible through the Projects page.',
                                    type: FontStyle.Medium,
                                    maxLines: 8,
                                    textAlign: TextAlign.left,
                                    color: themeProvider
                                        .themeManager.placeholderTextColor,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Button(
                                    text: 'Delete Project',
                                    color: (themeProvider.theme == THEME.dark ||
                                            themeProvider.theme ==
                                                THEME.darkHighContrast ||
                                            (themeProvider.theme ==
                                                    THEME.systemPreferences &&
                                                SchedulerBinding
                                                        .instance
                                                        .platformDispatcher
                                                        .platformBrightness ==
                                                    Brightness.dark))
                                        ? const Color.fromRGBO(95, 21, 21, 1)
                                        : const Color.fromRGBO(
                                            254, 242, 242, 1),
                                    textColor: themeProvider
                                        .themeManager.textErrorColor,
                                    filledButton: false,
                                    borderColor: themeProvider
                                        .themeManager.textErrorColor,
                                    ontap: () {
                                      showModalBottomSheet(
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
                                        builder: (BuildContext context) =>
                                            DeleteLeaveProjectSheet(
                                          data: {
                                            'WORKSPACE_ID': workspaceProvider
                                                .selectedWorkspace.workspaceId,
                                            'WORKSPACE_NAME': workspaceProvider
                                                .selectedWorkspace
                                                .workspaceName,
                                            'WORKSPACE_SLUG': workspaceProvider
                                                .selectedWorkspace
                                                .workspaceSlug,
                                            'PROJECT_ID': projectProvider
                                                .projectDetailModel!.id,
                                            'PROJECT_NAME': projectProvider
                                                .projectDetailModel!.name
                                          },
                                          role: getRole(),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                  checkUser()
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            Button(
                              text: 'Update Project',
                              ontap: () async {
                                if (identifier.text !=
                                    projectProvider
                                        .projectDetailModel!.identifier) {
                                  final available = await projectProvider
                                      .checkIdentifierAvailability(
                                          slug: ref
                                              .read(ProviderList
                                                  .workspaceProvider)
                                              .selectedWorkspace
                                              .workspaceSlug,
                                          identifier: identifier.text);
                                  if (available) {
                                    projectProvider.updateProject(
                                        slug: ref
                                            .read(
                                                ProviderList.workspaceProvider)
                                            .selectedWorkspace
                                            .workspaceSlug,
                                        projId: projectProvider
                                            .projectDetailModel!.id!,
                                        data: {
                                          'name': name.text,
                                          'description': description.text,
                                          'identifier': identifier.text,
                                          'network': isProjectPublic ? 2 : 0,
                                          'emoji': selectedEmoji,
                                          'cover_image': projectProvider
                                              .projectDetailModel!.coverImage
                                        },
                                        ref: ref);
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    CustomToast.showToast(context,
                                        message: 'Identifier already taken',
                                        toastType: ToastType.failure);
                                    return;
                                  }
                                } else {
                                  await projectProvider.updateProject(
                                      slug: ref
                                          .read(ProviderList.workspaceProvider)
                                          .selectedWorkspace
                                          .workspaceSlug,
                                      projId: projectProvider
                                          .projectDetailModel!.id!,
                                      data: {
                                        'name': name.text,
                                        'description': description.text,
                                        'identifier': identifier.text,
                                        'network': isProjectPublic ? 2 : 0,
                                        'emoji': selectedEmoji,
                                        'cover_image': projectProvider
                                            .projectDetailModel!.coverImage
                                      },
                                      ref: ref);

                                  if (projectProvider.updateProjectState ==
                                      StateEnum.success) {
                                    // ignore: use_build_context_synchronously
                                    CustomToast.showToast(context,
                                        message: 'Project updated successfully',
                                        toastType: ToastType.success);
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    CustomToast.showToast(context,
                                        message: 'Something went wrong',
                                        toastType: ToastType.failure);
                                  }
                                }
                              },
                            ),
                            const SizedBox(height: 15),
                          ],
                        )
                      : Container()
                ],
              ),
              showEmojis
                  ? Positioned(
                      left: 50,
                      child: Container(
                        constraints:
                            const BoxConstraints(maxWidth: 340, maxHeight: 400),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: themeProvider
                              .themeManager.primaryBackgroundDefaultColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: ListView(
                          children: [
                            Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: emojis
                                  .map(
                                    (e) => InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedEmoji = e;
                                          showEmojis = false;
                                        });
                                      },
                                      child: CustomText(
                                        String.fromCharCode(int.parse(e)),
                                        type: FontStyle.H6,
                                        fontWeight: FontWeightt.Semibold,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  bool checkUser() {
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    final List members = projectProvider.projectMembers;
    bool hasAccess = false;
    for (final element in members) {
      if ((element['member']['id'] == profileProvider.userProfile.id) &&
          (element['role'] == 20)) {
        hasAccess = true;
      }
    }
    return hasAccess;
  }

  Widget selectionCard(
      {required String title,
      required bool isSelected,
      required void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            CustomText(
              title,
              type: FontStyle.H6,
              // color: Colors.black,
            ),
            const Spacer(),
            isSelected
                ? const Icon(
                    Icons.done,
                    color: Color.fromRGBO(8, 171, 34, 1),
                  )
                : const SizedBox(),
            const SizedBox(height: 33),
          ],
        ),
      ),
    );
  }

  Role getRole() {
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    int? userRole;
    final List members = projectProvider.projectMembers;
    for (final element in members) {
      if (element['member']['id'] == profileProvider.userProfile.id) {
        userRole = element['role'];
      }
    }
    switch (userRole) {
      case 20:
        return role = Role.admin;
      case 15:
        return role = Role.member;
      case 10:
        return role = Role.viewer;
      case 5:
        return role = Role.guest;
      default:
        return role = Role.guest;
    }
  }
}
