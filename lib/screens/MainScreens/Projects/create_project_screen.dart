// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/bottom_sheets/project_select_cover_image.dart';
import 'package:plane_startup/widgets/loading_widget.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class CreateProject extends ConsumerStatefulWidget {
  const CreateProject({super.key});

  @override
  ConsumerState<CreateProject> createState() => _CreateProjectState();
}

class _CreateProjectState extends ConsumerState<CreateProject> {
  final TextEditingController emojiController = TextEditingController();
  GlobalKey<FormState> gkey = GlobalKey<FormState>();

  var showEMOJI = false;
  List<String> emojisWidgets = [];
  String selectedEmoji = (emojis[855]);
  var emoji = emojis[855];
  var selectedVal = 2;
  File? coverImage;
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController identifier = TextEditingController();

  generateEmojis() {
    for (int i = 0; i < emojis.length; i++) {
      setState(() {
        emojisWidgets.add(emojis[i]);
      });
    }
  }

  @override
  void initState() {
    generateEmojis();
    super.initState();
  }

  TextEditingController? getIdentifier(String? id) {
    setState(() {
      identifier.text = id!.toUpperCase().replaceAll(" ", "");
    });
    return identifier;
  }

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return Scaffold(
      // backgroundColor: themeProvider.backgroundColor,
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        text: 'Create Project',
      ),
      body: LoadingWidget(
        loading: projectProvider.createProjectState == StateEnum.loading,
        widgetClass: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            // color: themeProvider.backgroundColor,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Form(
                        key: gkey,
                        child: Column(
                          children: [
                            //cover image
                            Stack(
                              children: [
                                Container(
                                  height: 157,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      image: coverImage != null
                                          ? DecorationImage(
                                              fit: BoxFit.cover,
                                              image:
                                                  Image.file(coverImage!).image)
                                          : null),
                                  child: coverImage == null
                                      ? Image.network(
                                          projectProvider.coverUrl,
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                //edit button on top right corner rounded
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
                                                    MediaQuery.of(context)
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
                                              return const SelectCoverImage(
                                                creatProject: true,
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
                                      child: const CircleAvatar(
                                        backgroundColor: Color(0xFFF5F5F5),
                                        child: Center(
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            //row containing circle avatar with an emoji and text
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
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
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.75,
                                          ),
                                          context: context,
                                          builder: (ctx) {
                                            return Stack(
                                              children: [
                                                ListView(
                                                  shrinkWrap: true,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                                  // physics: NeverScrollableScrollPhysics(),
                                                  children: [
                                                    const SizedBox(
                                                      height: 60,
                                                    ),
                                                    selected == 0
                                                        ? Wrap(
                                                            alignment:
                                                                WrapAlignment
                                                                    .center,
                                                            spacing: 6,
                                                            runSpacing: 6,
                                                            children:
                                                                emojisWidgets
                                                                    .map(
                                                                      (e) =>
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            selectedEmoji =
                                                                                e;
                                                                            showEMOJI =
                                                                                false;
                                                                          });

                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              40,
                                                                          height:
                                                                              40,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                CustomText(
                                                                              String.fromCharCode(int.parse(e)),
                                                                              type: FontStyle.H4,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                    .toList(),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                    ),
                                                    color: Colors.white,
                                                  ),

                                                  // height: 80,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 25),
                                                            child: CustomText(
                                                              'Choose your project icon',
                                                              type:
                                                                  FontStyle.H4,
                                                              fontWeight:
                                                                  FontWeightt
                                                                      .Semibold,
                                                            ),
                                                          ),
                                                          // const Spacer(),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 15),
                                                            child: IconButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: Icon(
                                                                Icons.close,
                                                                size: 27,
                                                                color: themeProvider
                                                                        .isDarkThemeEnabled
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
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
                                            // return ListView(
                                            //   padding:
                                            //       const EdgeInsets.symmetric(
                                            //           horizontal: 5),
                                            //   children: [
                                            //     Wrap(
                                            //       spacing: 10,
                                            //       runSpacing: 1,
                                            //       children: emojisWidgets
                                            //           .map(
                                            //             (e) => InkWell(
                                            //               onTap: () {
                                            //                 setState(() {
                                            //                   selectedEmoji = e;
                                            //                   showEMOJI = false;
                                            //                 });
                                            //               },
                                            //               child: CustomText(
                                            //                 e,
                                            //                 type: FontStyle
                                            //                     .heading,
                                            //               ),
                                            //             ),
                                            //           )
                                            //           .toList(),
                                            //     ),
                                            //   ],
                                            // );
                                          });
                                    },
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: const Color(0xFFF5F5F5),
                                      child: CustomText(
                                        String.fromCharCode(
                                            int.parse(selectedEmoji)),
                                        type: FontStyle.H5,
                                      ),
                                    ),
                                  ),

                                  //text with a dropdown button infront of it
                                  // SizedBox(
                                  //   height: 50,
                                  //   width: 81,
                                  //   child: DropdownButtonFormField(
                                  //       dropdownColor:
                                  //           themeProvider.isDarkThemeEnabled
                                  //               ? darkSecondaryBackgroundColor
                                  //               : Colors.white,
                                  //       icon: Icon(
                                  //         Icons.arrow_drop_down,
                                  //         color:
                                  //             themeProvider.isDarkThemeEnabled
                                  //                 ? darkPrimaryTextColor
                                  //                 : lightPrimaryTextColor,
                                  //       ),
                                  //       decoration: const InputDecoration(
                                  //         border: InputBorder.none,
                                  //       ),
                                  //       value: 2,
                                  //       items: [
                                  //         DropdownMenuItem(
                                  //           value: 2,
                                  //           child: CustomText(
                                  //             'Public',
                                  //             type: FontStyle.Small,
                                  //             fontWeight: FontWeight.bold,
                                  //           ),
                                  //         ),
                                  //         DropdownMenuItem(
                                  //           value: 0,
                                  //           child: CustomText(
                                  //             'Private',
                                  //             type: FontStyle.Small,
                                  //             fontWeight: FontWeight.bold,
                                  //           ),
                                  //         ),
                                  //       ],
                                  //       onChanged: (val) {
                                  //         setState(() {
                                  //           selectedVal = val!;
                                  //         });
                                  //       }),
                                  // ),

                                  //conver the abpve dropdown into a row of two radio buttons
                                  Row(
                                    children: [
                                      Radio(
                                        activeColor: primaryColor,
                                        visualDensity: const VisualDensity(
                                          horizontal:
                                              VisualDensity.minimumDensity,
                                          vertical:
                                              VisualDensity.minimumDensity,
                                        ),
                                        value: 2,
                                        groupValue: selectedVal,
                                        onChanged: (val) {
                                          setState(() {
                                            selectedVal = val as int;
                                          });
                                        },
                                      ),
                                      const CustomText(
                                        'Public',
                                        type: FontStyle.Medium,
                                        fontWeight: FontWeightt.Medium,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Radio(
                                        activeColor: primaryColor,
                                        visualDensity: const VisualDensity(
                                          horizontal:
                                              VisualDensity.minimumDensity,
                                          vertical:
                                              VisualDensity.minimumDensity,
                                        ),
                                        value: 0,
                                        groupValue: selectedVal,
                                        onChanged: (val) {
                                          setState(() {
                                            selectedVal = val as int;
                                          });
                                        },
                                      ),
                                      const CustomText(
                                        'Secret',
                                        type: FontStyle.Medium,
                                        fontWeight: FontWeightt.Medium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            //text field for title with grey border
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: TextFormField(
                                controller: name,
                                decoration: themeProvider
                                    .themeManager.textFieldDecoration
                                    .copyWith(labelText: 'Enter project name'),
                                onChanged: (value) {
                                  if (value.length < 6) {
                                    getIdentifier(name.text);
                                  }
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Name is required';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 17),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: TextFormField(
                                controller: identifier,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(5),
                                ],
                                decoration: themeProvider
                                    .themeManager.textFieldDecoration
                                    .copyWith(
                                        labelText: 'Enter project identifier'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Identifier is required';
                                  }
                                  if (!value.contains(RegExp(
                                    r'^[A-Z]+$',
                                  ))) {
                                    return 'Identifier must be uppercase text.';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 17),
                            //large text field for description with grey border.
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: TextFormField(
                                controller: description,
                                maxLines: 5,
                                decoration: themeProvider
                                    .themeManager.textFieldDecoration
                                    .copyWith(labelText: 'Enter description'),
                              ),
                            ),
                            // const SizedBox(
                            //   height: 50,
                            // ),
                            //    const Spacer(),
                            //blue button with white text at the bottom
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 16),
                            //   child: Button(
                            //     text: 'Create Project',
                            //     textColor: Colors.white,
                            //     ontap: () async {
                            //       if (validateSave()) {
                            //         if (coverImage != null) {
                            //           await ref
                            //               .read(ProviderList.fileUploadProvider)
                            //               .uploadFile(coverImage!,
                            //                   coverImage!.path.split('.').last);
                            //         }

                            //         await projectProvider.createProjects(
                            //             slug: ref
                            //                 .read(ProviderList.workspaceProvider)
                            //                 .workspaces
                            //                 .where((element) =>
                            //                     element['id'] ==
                            //                     ref
                            //                         .read(
                            //                             ProviderList.profileProvider)
                            //                         .userProfile
                            //                         .last_workspace_id)
                            //                 .first['slug'],
                            //             data: {
                            //               "cover_image": projectProvider.coverUrl,
                            //               "name": name.text,
                            //               "identifier": identifier.text,
                            //               "emoji": selectedEmoji,
                            //               "description": description.text,
                            //               "network": selectedVal
                            //             });
                            //         if (projectProvider.createProjectState ==
                            //             AuthStateEnum.success) {
                            //           Navigator.pop(context);
                            //         }
                            //       }
                            //     },
                            //   ),
                            // ),
                            // const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Button(
                      text: 'Create Project',
                      textColor: Colors.white,
                      ontap: () async {
                        if (validateSave()) {
                          if (coverImage != null) {
                            await ref
                                .read(ProviderList.fileUploadProvider)
                                .uploadFile(coverImage!,
                                    coverImage!.path.split('.').last);
                          }

                          await projectProvider.createProjects(
                              slug: ref
                                  .read(ProviderList.workspaceProvider)
                                  .selectedWorkspace!
                                  .workspaceSlug,
                              data: {
                                "cover_image": projectProvider.coverUrl,
                                "name": name.text,
                                "identifier": identifier.text,
                                "emoji": selectedEmoji,
                                "description": description.text,
                                "network": selectedVal
                              });
                          if (projectProvider.createProjectState ==
                              StateEnum.success) {
                            Navigator.pop(Const.globalKey.currentContext!);
                          }
                          //Navigator.pop(Const.globalKey.currentContext!);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  bool validateSave() {
    final form = gkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
