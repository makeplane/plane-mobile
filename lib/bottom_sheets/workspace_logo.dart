// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_button.dart';

import 'package:plane_startup/widgets/custom_text.dart';

class WorkspaceLogo extends ConsumerStatefulWidget {
  const WorkspaceLogo({super.key});

  @override
  ConsumerState<WorkspaceLogo> createState() => _WorkspaceLogoState();
}

class _WorkspaceLogoState extends ConsumerState<WorkspaceLogo> {
  File? coverImage;
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var fileProvider = ref.watch(ProviderList.fileUploadProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            //color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () async {
                      var file = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (file != null) {
                        setState(() {
                          coverImage = File(file.path);
                        });
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.file_upload_outlined),
                          SizedBox(
                            width: 10,
                          ),
                          CustomText(
                            'Upload',
                            type: FontStyle.Small,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              coverImage != null
                  ? GestureDetector(
                      onTap: () async {
                        var file = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (file != null) {
                          setState(() {
                            coverImage = File(file.path);
                          });
                        }
                      },
                      child: Container(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.file(coverImage!).image,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Button(
                    text: 'UPLOAD',
                    ontap: () async {
                      int sizeOfImage =
                          coverImage!.readAsBytesSync().lengthInBytes;

                      if (sizeOfImage > 5000000) {
                        CustomToast().showToast(
                            context, 'file exceeding 5MB', themeProvider,
                            toastType: ToastType.warning);
                        return;
                      }
                      var url = await fileProvider.uploadFile(
                        coverImage!,
                        coverImage!.path.split('.').last,
                      );
                      if (url != null) {
                        workspaceProvider.changeLogo(logo: url);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        fileProvider.fileUploadState == StateEnum.loading
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: themeProvider.isDarkThemeEnabled
                      ? Colors.black.withOpacity(0.7)
                      : Colors.white.withOpacity(0.7),
                  //color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                alignment: Alignment.center,

                // height: 25,
                // width: 25,
                child: Wrap(
                  children: [
                    SizedBox(
                      height: 25,
                      width: 25,
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineSpinFadeLoader,
                        colors: [
                          themeProvider.isDarkThemeEnabled
                              ? Colors.white
                              : Colors.black
                        ],
                        strokeWidth: 1.0,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
