// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/Theming/prefrences.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_button.dart';
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
    BuildContext screenContext = context;
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);
    var fileUploadProvider = ref.watch(ProviderList.fileUploadProvider);
    log('${profileProvider.userProfile.avatar} photo');
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                          color: themeProvider.themeManager.borderDisabledColor,
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
                                            fileUploadProvider
                                                        .fileUploadState ==
                                                    StateEnum.loading
                                                ? CircleAvatar(
                                                    radius: 50,
                                                    backgroundColor: Colors
                                                        .white
                                                        .withOpacity(0.7),
                                                    child: const Center(
                                                      child: SizedBox(
                                                        width: 30,
                                                        height: 30,
                                                        child: LoadingIndicator(
                                                          indicatorType: Indicator
                                                              .lineSpinFadeLoader,
                                                          colors: [
                                                            Colors.black
                                                          ],
                                                          strokeWidth: 1.0,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
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
                                                    .themeManager
                                                    .tertiaryBackgroundDefaultColor,
                                              ),
                                              child: Icon(
                                                Icons.person_2_outlined,
                                                color: themeProvider
                                                    .themeManager
                                                    .placeholderTextColor,
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
                                          color: themeProvider.themeManager
                                              .borderSubtle01Color),
                                      borderRadius: BorderRadius.circular(5),
                                      color: themeProvider.themeManager
                                          .tertiaryBackgroundDefaultColor),
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.file_upload_outlined,
                                        color: themeProvider
                                            .themeManager.primaryTextColor,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      CustomText(
                                        'Upload',
                                        type: FontStyle.Medium,
                                        fontWeight: FontWeightt.Bold,
                                        color: themeProvider
                                            .themeManager.primaryTextColor,
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
                                          color: themeProvider.themeManager
                                              .borderSubtle01Color),
                                      borderRadius: BorderRadius.circular(5),
                                      color: themeProvider.themeManager
                                          .tertiaryBackgroundDefaultColor),
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      CustomText(
                                        'Remove',
                                        type: FontStyle.Medium,
                                        fontWeight: FontWeightt.Bold,
                                        color: themeProvider
                                            .themeManager.textErrorColor,
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
                          child: CustomText(
                            'Full Name *',
                            type: FontStyle.Medium,
                            color: themeProvider.themeManager.tertiaryTextColor,
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
                                  color: themeProvider
                                      .themeManager.primaryTextColor),
                              decoration: themeProvider
                                  .themeManager.textFieldDecoration),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // const Text('Email *', style: TextStylingWidget.description),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomText(
                            'Email *',
                            type: FontStyle.Medium,
                            color: themeProvider.themeManager.tertiaryTextColor,
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
                                color: themeProvider
                                    .themeManager.primaryTextColor),
                            decoration:
                                themeProvider.themeManager.textFieldDecoration,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomText('Role *',
                              type: FontStyle.Medium,
                              color:
                                  themeProvider.themeManager.tertiaryTextColor),
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
                                  color: themeProvider
                                      .themeManager.borderSubtle01Color),
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
                                    type: FontStyle.Small,
                                    color: themeProvider
                                        .themeManager.primaryTextColor,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: themeProvider
                                        .themeManager.primaryTextColor,
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
                              type: FontStyle.Medium,
                              color:
                                  themeProvider.themeManager.tertiaryTextColor),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PrefrencesScreen()));
                            // showModalBottomSheet(
                            //     context: context,
                            //     constraints: BoxConstraints(
                            //       maxHeight:
                            //           MediaQuery.of(context).size.height * 0.5,
                            //     ),
                            //     shape: const RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.only(
                            //         topLeft: Radius.circular(20),
                            //         topRight: Radius.circular(20),
                            //       ),
                            //     ),
                            //     builder: (context) {
                            //       return const ThemeSheet();
                            //     });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                  color: themeProvider
                                      .themeManager.borderSubtle01Color),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 16),
                                  child: CustomText(
                                    themeProvider.theme == THEME.light
                                        ? 'Light'
                                        : themeProvider.theme == THEME.dark
                                            ? 'Dark'
                                            : themeProvider.theme ==
                                                    THEME.lightHighContrast
                                                ? 'Light High Contrast'
                                                : themeProvider.theme ==
                                                        THEME.darkHighContrast
                                                    ? 'Dark High Contrast'
                                                    : 'Custom',
                                    type: FontStyle.Small,
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
                      margin: const EdgeInsets.only(
                          bottom: 15, left: 16, right: 16),
                      child: Button(
                        ontap: () async {
                          
                          await profileProvider.updateProfile(
                            data: {
                              "first_name": fullName.text,
                              "role": profileProvider.dropDownValue,
                              if (fileUploadProvider.downloadUrl != null)
                                "avatar": fileUploadProvider.downloadUrl
                            },
                          );
                          if (profileProvider.updateProfileState ==
                              StateEnum.success) {
                            Navigator.pop(Const.globalKey.currentContext!);
                            
                            CustomToast().showToast(screenContext,
                                'Profile updated successfully', themeProvider,
                                toastType: ToastType.success);
                          } else {
                            CustomToast().showToast(screenContext,
                                'Something went wrong', themeProvider,
                                toastType: ToastType.failure);
                          }
                        },
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
      ),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      int sizeOfImage = File(image.path).readAsBytesSync().lengthInBytes;
      if (sizeOfImage > 5000000) {
        CustomToast().showToast(context, 'File size should be less than 5MB',
            ref.read(ProviderList.themeProvider),
            toastType: ToastType.warning);
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
