// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/bottom_sheets/emoji_sheet.dart';
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

  // var showEMOJI = false;
  bool isEmoji = true;
  String selectedColor = "#3A3A3A";
  List<String> emojisWidgets = [];
  String selectedEmoji = (emojis[855]);
  IconData? selectedIcon;
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
      identifier.text = id!.trim().toUpperCase().replaceAll(" ", "");
    });
    return identifier;
  }

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // backgroundColor: themeProvider.backgroundColor,
        appBar: CustomAppBar(
          onPressed: () {
            Navigator.pop(context);
          },
          text: 'Create Project',
          fontType: FontStyle.H6,
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
                                                image: Image.file(coverImage!)
                                                    .image)
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
                                          Map<String, dynamic> url = {};
                                          await showModalBottomSheet(
                                              isScrollControlled: true,
                                              enableDrag: true,
                                              constraints: BoxConstraints(
                                                  maxHeight:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.85),
                                              shape:
                                                  const RoundedRectangleBorder(
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
                                          setState(() {
                                            projectProvider.coverUrl =
                                                url['url'];
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: themeProvider
                                              .themeManager
                                              .primaryBackgroundDefaultColor,
                                          child: Center(
                                            child: Icon(
                                              Icons.edit,
                                              color: themeProvider.themeManager
                                                  .primaryTextColor,
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
                                          enableDrag: true,
                                          isScrollControlled: true,
                                          constraints: BoxConstraints(
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8,
                                          ),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: const EmojiSheet(),
                                            );
                                          },
                                        ).then((value) {
                                          setState(() {
                                            selectedEmoji = value['name'];
                                            isEmoji = value['is_emoji'];
                                            selectedColor =
                                                value['color'] ?? "#3A3A3A";
                                          });
                                        });
                                      },
                                      child: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: themeProvider
                                              .themeManager
                                              .secondaryBackgroundDefaultColor,
                                          child: isEmoji
                                              ? CustomText(
                                                  String.fromCharCode(
                                                      int.parse(selectedEmoji)),
                                                  type: FontStyle.H5,
                                                )
                                              : Icon(
                                                  iconList[selectedEmoji],
                                                  color: Color(
                                                    int.parse(
                                                      selectedColor
                                                          .toString()
                                                          .replaceAll(
                                                              '#', '0xFF'),
                                                    ),
                                                  ),
                                                )),
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          activeColor: themeProvider
                                              .themeManager.primaryColour,
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
                                        CustomText(
                                          'Public',
                                          type: FontStyle.Medium,
                                          fontWeight: FontWeightt.Medium,
                                          color: themeProvider
                                              .themeManager.primaryTextColor,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Radio(
                                          activeColor: themeProvider
                                              .themeManager.primaryColour,
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
                                        CustomText(
                                          'Secret',
                                          type: FontStyle.Medium,
                                          fontWeight: FontWeightt.Medium,
                                          color: themeProvider
                                              .themeManager.primaryTextColor,
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
                                      .copyWith(
                                          labelText: 'Enter project name'),
                                  onChanged: (value) {
                                    String tempVal =
                                        value.trim().replaceAll(" ", "");
                                    //replace all special characters
                                    tempVal = tempVal.replaceAll(
                                        RegExp(r'[^\w\s]+'), '');

                                    if (tempVal.length < 6) {
                                      getIdentifier(tempVal);
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
                                    LengthLimitingTextInputFormatter(12),
                                    //replace all special characters allow alphanumeric
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z0-9]')),
                                  ],
                                  onChanged: (value) {
                                    //if the entered character is in lowercase then convert it to uppercase
                                    if (value.isNotEmpty) {
                                      if (value[value.length - 1] !=
                                          value[value.length - 1]
                                              .toUpperCase()) {
                                        identifier.text = value.toUpperCase();
                                        identifier.selection =
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset: identifier
                                                        .text.length));
                                      }
                                    }
                                  },
                                  decoration: themeProvider
                                      .themeManager.textFieldDecoration
                                      .copyWith(
                                          labelText:
                                              'Enter project identifier'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Identifier is required';
                                    }
                                    //condition for containing lowercase
                                    else if (value.contains(RegExp(
                                      r'[a-z]+',
                                    ))) {
                                      return 'Identifier must not contain lowercase.';
                                    }

                                    // condition for containing special characters
                                    else if (value.contains(RegExp(
                                      r'[^\w\s]+',
                                    ))) {
                                      return 'Identifier must not contain special characters.';
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
                                      .copyWith(
                                          labelText: 'Enter description',
                                          contentPadding:
                                              const EdgeInsets.all(15)),
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
                        textColor: themeProvider.themeManager.textonColor,
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
                                  "emoji": isEmoji ? selectedEmoji : null,
                                  "description": description.text,
                                  "network": selectedVal,
                                  "icon_prop": !isEmoji
                                      ? {
                                          "name": selectedEmoji,
                                          "color": selectedColor,
                                        }
                                      : null
                                },
                                ref: ref);
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
