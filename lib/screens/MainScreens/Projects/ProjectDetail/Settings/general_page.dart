import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/bottom_sheets/delete_project_sheet.dart';
import 'package:plane_startup/bottom_sheets/project_select_cover_image.dart';

import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';

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

  generateEmojis() {
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
      var projectProvider = ref.watch(ProviderList.projectProvider);
      name.text = projectProvider.projectDetailModel!.name!;
      description.text = projectProvider.projectDetailModel!.description!;
      identifier.text = projectProvider.projectDetailModel!.identifier!;
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
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    // projectProvider.projectDetailModel!.network == 1
    //     ? isProjectPublic = false
    //     : isProjectPublic = true;
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
                              return Stack(
                                children: [
                                  ListView(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    // physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      const SizedBox(
                                        height: 60,
                                      ),
                                      //selected == 0
                                      //?
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: emojisWidgets
                                            .map(
                                              (e) => InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedEmoji = e;
                                                    projectProvider.updateProject(
                                                        slug: ref
                                                            .read(ProviderList
                                                                .workspaceProvider)
                                                            .selectedWorkspace!
                                                            .workspaceSlug,
                                                        projId: projectProvider
                                                            .projectDetailModel!
                                                            .id!,
                                                        data: {
                                                          'name': name.text,
                                                          'description':
                                                              description.text,
                                                          'identifier':
                                                              identifier.text,
                                                          'network':
                                                              isProjectPublic
                                                                  ? 2
                                                                  : 0,
                                                          'emoji': selectedEmoji
                                                        });
                                                    //showEMOJI = false;
                                                  });

                                                  Navigator.of(context).pop();
                                                },
                                                child: SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child: Center(
                                                    child: CustomText(
                                                      String.fromCharCode(
                                                          int.parse(e)),
                                                      type: FontStyle.H5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      )
                                      //: Container(),
                                    ],
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      color: Colors.white,
                                    ),

                                    // height: 80,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 25),
                                              child: CustomText(
                                                'Choose your project icon',
                                                type: FontStyle.H6,
                                                fontWeight:
                                                    FontWeightt.Semibold,
                                              ),
                                            ),
                                            // const Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(
                                                  Icons.close,
                                                  size: 27,
                                                  color: themeProvider
                                                      .themeManager
                                                      .primaryTextColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                          // setState(() {
                          //   showEmojis = !showEmojis;
                          // });
                        },
                        child: Container(
                          height: 55,
                          width: 55,
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
                                ? CustomText(
                                    String.fromCharCode(
                                        int.parse(selectedEmoji!)),
                                    type: FontStyle.H6,
                                    fontWeight: FontWeightt.Semibold,
                                  )
                                : CustomText(
                                    projectProvider.projectDetailModel !=
                                                null &&
                                            projectProvider.projectDetailModel!
                                                    .emoji !=
                                                null &&
                                            int.tryParse(projectProvider
                                                    .projectDetailModel!
                                                    .emoji!) !=
                                                null
                                        ? String.fromCharCode(int.parse(
                                            projectProvider
                                                .projectDetailModel!.emoji!))
                                        : '🚀',
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),
                      //textfield
                      Expanded(
                        child: TextField(
                            controller: name,
                            decoration:
                                themeProvider.themeManager.textFieldDecoration
                            //     .copyWith(
                            //   enabledBorder: OutlineInputBorder(
                            //     borderSide: BorderSide(
                            //         color: themeProvider.isDarkThemeEnabled
                            //             ? darkThemeBorder
                            //             : const Color(0xFFE5E5E5),
                            //         width: 1.0),
                            //     borderRadius:
                            //         const BorderRadius.all(Radius.circular(8)),
                            //   ),
                            //   disabledBorder: OutlineInputBorder(
                            //     borderSide: BorderSide(
                            //         color: themeProvider.isDarkThemeEnabled
                            //             ? darkThemeBorder
                            //             : const Color(0xFFE5E5E5),
                            //         width: 1.0),
                            //     borderRadius:
                            //         const BorderRadius.all(Radius.circular(8)),
                            //   ),
                            //   focusedBorder: const OutlineInputBorder(
                            //     borderSide:
                            //         BorderSide(color: primaryColor, width: 2.0),
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(8)),
                            //   ),
                            // ),
                            ),
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
                      onTap: () {
                        CustomToast().showToast(
                            context,
                            'This operation cannot be performed using Plane Mobile',
                            themeProvider,
                            toastType: ToastType.defult);
                      },
                      readOnly: true,
                      controller: description,
                      maxLines: 4,
                      decoration:
                          themeProvider.themeManager.textFieldDecoration),
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
                        Positioned(
                          top: 15,
                          right: 15,
                          child: GestureDetector(
                            onTap: () async {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  enableDrag: true,
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.75),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                  ),
                                  context: context,
                                  builder: (ctx) {
                                    return const SelectCoverImage(
                                      creatProject: false,
                                    );
                                  });
                              // var file = await ImagePicker.platform
                              //     .pickImage(source: ImageSource.gallery);
                              // if (file != null) {
                              //   setState(() {
                              //     coverImage = File(file.path);
                              //   });
                              // }
                            },
                            child: CircleAvatar(
                              backgroundColor: themeProvider
                                  .themeManager.primaryBackgroundDefaultColor,
                              child: Center(
                                child: Icon(
                                  Icons.edit,
                                  color: themeProvider
                                      .themeManager.primaryTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // Text(
                      //   'Identifier',
                      //   style: TextStyle(
                      //     fontSize: 15,
                      //     fontWeight: FontWeight.w400,
                      //     color: themeProvider.secondaryTextColor,
                      //   ),
                      // ),
                      // const Text(
                      //   ' *',
                      //   style: TextStyle(
                      //     fontSize: 15,
                      //     fontWeight: FontWeight.w400,
                      //     color: Colors.red,
                      //   ),
                      // ),
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
                      controller: identifier,
                      maxLength: 5,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Z]')),
                      ],
                      decoration:
                          themeProvider.themeManager.textFieldDecoration),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
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
                                horizontal: 20, vertical: 50),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                //const SizedBox(height: 50),
                                selectionCard(
                                    title: 'Secret',
                                    isSelected: !isProjectPublic,
                                    onTap: () {
                                      setState(() {
                                        isProjectPublic = false;
                                      });
                                      Navigator.of(context).pop();
                                    }),
                                //const SizedBox(height: 5),
                                const Divider(),
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
                                //const SizedBox(height: 50),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 60,
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
                            !isProjectPublic ? 'Secret' : 'Public',
                            type: FontStyle.Small,
                            color: themeProvider.themeManager.primaryTextColor,
                          ),
                          const Spacer(),
                          Icon(Icons.arrow_drop_down,
                              color:
                                  themeProvider.themeManager.primaryTextColor)
                        ],
                      ),
                    ),
                  ),
                  // DropdownButtonFormField(
                  //   value: projectProvider.projectDetailModel!.network == 1
                  //       ? 'Secret'
                  //       : 'Public',
                  //   decoration: themeProvider.themeManager.textFieldDecoration.copyWith(
                  //     fillColor: themeProvider.isDarkThemeEnabled
                  //         ? darkBackgroundColor
                  //         : lightBackgroundColor,
                  //     filled: true,
                  //   ),
                  //   dropdownColor: themeProvider.isDarkThemeEnabled
                  //       ? Colors.black
                  //       : Colors.white,
                  //   items: [
                  //     DropdownMenuItem(
                  //       value: 'Secret',
                  //       child: CustomText(
                  //         'Secret',
                  //         type: FontStyle.Medium,
                  //       ),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: 'Public',
                  //       child: CustomText(
                  //         'Public',
                  //         type: FontStyle.Medium,
                  //       ),
                  //     ),
                  //   ],
                  //   onChanged: (val) {},
                  // ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        //light redzz
                        // color: Colors.red[00],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color.fromRGBO(255, 12, 12, 1))),
                    child: ExpansionTile(
                      onExpansionChanged: (value) async {
                        scrollDown();
                      },
                      childrenPadding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 10),
                      iconColor: themeProvider.themeManager.primaryTextColor,
                      collapsedIconColor:
                          themeProvider.themeManager.primaryTextColor,
                      backgroundColor: const Color.fromRGBO(255, 12, 12, 0.1),
                      collapsedBackgroundColor:
                          const Color.fromRGBO(255, 12, 12, 0.1),
                      title: CustomText(
                        'Danger Zone',
                        textAlign: TextAlign.left,
                        type: FontStyle.H5,
                        color: themeProvider.themeManager.textErrorColor,
                      ),
                      children: [
                        CustomText(
                          'The danger zone of the project delete page is a critical area that requires careful consideration and attention. When deleting a project, all of the data and resources within that project will be permanently removed and cannot be recovered.',
                          type: FontStyle.Medium,
                          maxLines: 8,
                          textAlign: TextAlign.left,
                          color:
                              themeProvider.themeManager.placeholderTextColor,
                        ),
                        GestureDetector(
                          onTap: () async {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              enableDrag: true,
                              constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height *
                                          0.85),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              context: context,
                              builder: (BuildContext context) =>
                                  const DeleteProjectSheet(),
                            );
                          },
                          child: Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 15),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 12, 12, 1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Center(
                                  child: CustomText(
                                'Delete Project',
                                color: Colors.white,
                                type: FontStyle.Medium,
                                overrride: true,
                                fontWeight: FontWeightt.Bold,
                              ))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Button(
                    text: 'Update Project',
                    ontap: () async {
                      // log(identifier.text +
                      //     " " +
                      //     projectProvider.projectDetailModel!.identifier!);

                      if (identifier.text !=
                          projectProvider.projectDetailModel!.identifier) {
                        var available =
                            await projectProvider.checkIdentifierAvailability(
                                slug: ref
                                    .read(ProviderList.workspaceProvider)
                                    .selectedWorkspace!
                                    .workspaceSlug,
                                identifier: identifier.text);
                        if (available) {
                          projectProvider.updateProject(
                              slug: ref
                                  .read(ProviderList.workspaceProvider)
                                  .selectedWorkspace!
                                  .workspaceSlug,
                              projId: projectProvider.projectDetailModel!.id!,
                              data: {
                                'name': name.text,
                                'description': description.text,
                                'identifier': identifier.text,
                                'network': isProjectPublic ? 2 : 0,
                                'emoji': selectedEmoji,
                                'cover_image': projectProvider
                                    .projectDetailModel!.coverImage
                              });
                        } else {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: CustomText(
                                'Identifier already taken',
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                      } else {
                        projectProvider.updateProject(
                            slug: ref
                                .read(ProviderList.workspaceProvider)
                                .selectedWorkspace!
                                .workspaceSlug,
                            projId: projectProvider.projectDetailModel!.id!,
                            data: {
                              'name': name.text,
                              'description': description.text,
                              'identifier': identifier.text,
                              'network': isProjectPublic ? 2 : 0,
                              'emoji': selectedEmoji,
                              'cover_image':
                                  projectProvider.projectDetailModel!.coverImage
                            });
                      }
                      // await projectProvider.updateProject(
                      //     projId: projectProvider.projectDetailModel!.id!,
                      //     slug: ref
                      //         .read(ProviderList.workspaceProvider)
                      //         .selectedWorkspace!
                      //         .workspaceSlug,
                      //     data: {
                      //       'name': name.text,
                      //       'description': description.text,
                      //       'identifier': identifier.text,
                      //       'network': isProjectPublic ? 0 : 1,
                      //     });
                    },
                  ),
                  const SizedBox(height: 15),
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

  Widget selectionCard(
      {required String title,
      required bool isSelected,
      required void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          const SizedBox(height: 33),
          CustomText(
            title,
            type: FontStyle.Small,
            // color: Colors.black,
          ),
          const Spacer(),
          isSelected
              ? const Icon(
                  Icons.done,
                  color: Color.fromRGBO(8, 171, 34, 1),
                )
              // : false
              //     ? const SizedBox(
              //         height: 20,
              //         width: 20,
              //         child: CircularProgressIndicator(
              //           strokeWidth: 2,
              //           color: greyColor,
              //         ),
              //       )
              : const SizedBox(),
          const SizedBox(height: 33),
        ],
      ),
    );
  }
}
