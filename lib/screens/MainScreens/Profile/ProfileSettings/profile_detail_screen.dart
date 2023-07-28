import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/bottom_sheets/theme_sheet.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/bottom_sheets/role_sheet.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

class ProfileDetailScreen extends ConsumerStatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  ConsumerState<ProfileDetailScreen> createState() =>
      _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends ConsumerState<ProfileDetailScreen> {
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();

  String? dropDownValue;
  List<String> dropDownItems = [
    'Founder or Leadership team',
    'Product Manager',
    'Designer',
    'Software Developer',
    'Freelancer',
    'Other'
  ];
  String theme = 'Light';
  List<String> themes = ['Light', 'Dark'];
  File? pickedImage;

  @override
  void initState() {
    super.initState();
    var profileProvier = ref.read(ProviderList.profileProvider);
    fullName.text = profileProvier.userProfile.firstName!;
    email.text = profileProvier.userProfile.email!;
    profileProvier.dropDownValue = profileProvier.userProfile.role;
    profileProvier.roleIndex = profileProvier.dropDownItems
        .indexWhere((element) => element == profileProvier.dropDownValue);
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);
    var fileUploadProvider = ref.watch(ProviderList.fileUploadProvider);
    log('${profileProvider.userProfile.avatar} photo');
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        text: 'General',
      ),
      body: LoadingWidget(
        loading: profileProvider.updateProfileState == StateEnum.loading,
        widgetClass:
            LayoutBuilder(builder: (context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width,
                        color: themeProvider.isDarkThemeEnabled
                            ? darkThemeBorder
                            : Colors.grey[300],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Hero(
                                tag: 'photo',
                                child: pickedImage != null
                                    ? Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 50,
                                            backgroundImage:
                                                FileImage(pickedImage!),
                                          ),
                                          fileUploadProvider.fileUploadState ==
                                                  StateEnum.loading
                                              ? CircleAvatar(
                                                  radius: 50,
                                                  backgroundColor: Colors.white
                                                      .withOpacity(0.7),
                                                  child: const Center(
                                                    child: SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child: LoadingIndicator(
                                                        indicatorType: Indicator
                                                            .lineSpinFadeLoader,
                                                        colors: [Colors.black],
                                                        strokeWidth: 1.0,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      )
                                    : profileProvider.userProfile.avatar !=
                                                null &&
                                            profileProvider
                                                    .userProfile.avatar !=
                                                ""
                                        ? CircleAvatar(
                                            radius: 50,
                                            backgroundImage: NetworkImage(
                                                profileProvider
                                                    .userProfile.avatar!),
                                          )
                                        : Container(
                                            height: 75,
                                            width: 75,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: themeProvider
                                                      .isDarkThemeEnabled
                                                  ? darkThemeBorder
                                                  : Colors.white,
                                            ),
                                            child: Icon(
                                              Icons.person_2_outlined,
                                              color: themeProvider
                                                      .isDarkThemeEnabled
                                                  ? Colors.grey.shade500
                                                  : Colors.grey,
                                              size: 35,
                                            ))),
                            const SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                pickImage();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: themeProvider.isDarkThemeEnabled
                                            ? darkThemeBorder
                                            : strokeColor),
                                    borderRadius: BorderRadius.circular(5),
                                    color: themeProvider.isDarkThemeEnabled
                                        ? darkSecondaryBGC
                                        : Colors.white),
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.file_upload_outlined,
                                      color: themeProvider.isDarkThemeEnabled
                                          ? darkSecondaryTextColor
                                          : Colors.black,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    CustomText(
                                      'Upload',
                                      type: FontStyle.buttonText,
                                      color: themeProvider.isDarkThemeEnabled
                                          ? const Color.fromRGBO(
                                              142, 148, 146, 1)
                                          : Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                log(profileProvider.userProfile.avatar!
                                    .toString());
                                if (profileProvider
                                    .userProfile.avatar!.isNotEmpty) {
                                  profileProvider.deleteAvatar();
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: themeProvider.isDarkThemeEnabled
                                            ? darkThemeBorder
                                            : strokeColor),
                                    borderRadius: BorderRadius.circular(5),
                                    color: themeProvider.isDarkThemeEnabled
                                        ? darkSecondaryBGC
                                        : Colors.white),
                                padding: const EdgeInsets.all(8),
                                child: const Row(
                                  children: [
                                    CustomText(
                                      'Remove',
                                      type: FontStyle.buttonText,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      // const Text('Full Name *', style: TextStylingWidget.description),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: const CustomText(
                          'Full Name *',
                          type: FontStyle.description,
                          //color: const Color.fromRGBO(142, 148, 146, 1),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: fullName,
                          style: TextStyle(
                              color: themeProvider.isDarkThemeEnabled
                                  ? Colors.white
                                  : Colors.black),
                          decoration: kTextFieldDecoration.copyWith(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: themeProvider.isDarkThemeEnabled
                                      ? darkThemeBorder
                                      : const Color(0xFFE5E5E5),
                                  width: 1.0),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: themeProvider.isDarkThemeEnabled
                                      ? darkThemeBorder
                                      : const Color(0xFFE5E5E5),
                                  width: 1.0),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // const Text('Email *', style: TextStylingWidget.description),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: const CustomText(
                          'Email *',
                          type: FontStyle.description,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: email,
                          enabled: false,
                          style: TextStyle(
                              color: themeProvider.isDarkThemeEnabled
                                  ? Colors.white
                                  : Colors.black),
                          decoration: kTextFieldDecoration.copyWith(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: themeProvider.isDarkThemeEnabled
                                      ? darkThemeBorder
                                      : const Color(0xFFE5E5E5),
                                  width: 1.0),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: themeProvider.isDarkThemeEnabled
                                      ? darkThemeBorder
                                      : const Color(0xFFE5E5E5),
                                  width: 1.0),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomText('Role *',
                            type: FontStyle.description,
                            color: themeProvider.isDarkThemeEnabled
                                ? darkSecondaryTextColor
                                : Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.5,
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              builder: (context) {
                                return const RoleSheet();
                              });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: themeProvider.isDarkThemeEnabled
                                    ? darkThemeBorder
                                    : Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 16),
                                child: CustomText(
                                  profileProvider.dropDownValue == null
                                      ? 'Select Role'
                                      : profileProvider.dropDownValue!,
                                  type: FontStyle.text,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: themeProvider.isDarkThemeEnabled
                                      ? darkPrimaryTextColor
                                      : lightPrimaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                      // const Text('Theme', style: TextStylingWidget.description),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomText('Theme',
                            type: FontStyle.description,
                            color: themeProvider.isDarkThemeEnabled
                                ? darkSecondaryTextColor
                                : Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.5,
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              builder: (context) {
                                return const ThemeSheet();
                              });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: themeProvider.isDarkThemeEnabled
                                    ? darkThemeBorder
                                    : Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 16),
                                child: CustomText(
                                  profileProvider.theme,
                                  type: FontStyle.text,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: themeProvider.isDarkThemeEnabled
                                      ? darkPrimaryTextColor
                                      : lightPrimaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // Expanded(child: Container()),
                      // Button(
                      //   ontap: () => profileProvier.updateProfile(data: {
                      //     "first_name": fullName.text,
                      //     "role": dropDownValue,
                      //     if (fileUploadProvider.downloadUrl != null)
                      //       "avatar": fileUploadProvider.downloadUrl
                      //   }),
                      //   text: 'Update',
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // )
                    ],
                  ),
                  Container(
                    height: 50,
                    alignment: Alignment.bottomCenter,
                    margin:
                        const EdgeInsets.only(bottom: 15, left: 16, right: 16),
                    child: Button(
                      ontap: () => profileProvider.updateProfile(data: {
                        "first_name": fullName.text,
                        "role": profileProvider.dropDownValue,
                        if (fileUploadProvider.downloadUrl != null)
                          "avatar": fileUploadProvider.downloadUrl
                      }),
                      text: 'Update',
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),

      // bottomNavigationBar: Container(
      //   height: 50,
      //   alignment: Alignment.bottomCenter,
      //   margin: const EdgeInsets.only(bottom: 15, left: 16, right: 16),
      //   child: Button(
      //     ontap: () => profileProvier.updateProfile(data: {
      //       "first_name": fullName.text,
      //       "role": dropDownValue,
      //       if (fileUploadProvider.downloadUrl != null)
      //         "avatar": fileUploadProvider.downloadUrl
      //     }),
      //     text: 'Update',
      //   ),
      // ),

      //custom floating action buttom at bottom center
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      int sizeOfImage = File(image.path).readAsBytesSync().lengthInBytes;
      if (sizeOfImage > 5000000) {
        // ignore: use_build_context_synchronously
        CustomToast().showToast(context, 'File size should be less than 5MB');
        return;
      }
      setState(() {
        pickedImage = File(image.path);
      });

      ref
          .read(ProviderList.fileUploadProvider)
          .uploadFile(pickedImage!, 'image');
    } on PlatformException catch (e) {
      log(e.toString());
    }
  }
}
