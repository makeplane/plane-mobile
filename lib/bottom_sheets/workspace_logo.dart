// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plane/mixins/widget_state_mixin.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_button.dart';

import 'package:plane/widgets/custom_text.dart';

class WorkspaceLogo extends ConsumerStatefulWidget {
  const WorkspaceLogo({super.key});

  @override
  ConsumerState<WorkspaceLogo> createState() => _WorkspaceLogoState();
}

class _WorkspaceLogoState extends ConsumerState<WorkspaceLogo>
    with WidgetStateMixin {
  File? coverImage;
  final searchController = TextEditingController();

  @override
  LoadingType getLoading(WidgetRef ref) {
    return setWidgetState([
      ref.read(ProviderList.fileUploadProvider).fileUploadState,
      ref.read(ProviderList.workspaceProvider).updateWorkspaceState
    ], allowError: false, loadingType: LoadingType.wrap);
  }

  @override
  Widget render(BuildContext context) {
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var fileProvider = ref.watch(ProviderList.fileUploadProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
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
          coverImage == null
              ? Expanded(
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.file_upload_outlined,
                              color: themeProvider
                                  .themeManager.placeholderTextColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const CustomText(
                              'Upload',
                              type: FontStyle.Small,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : GestureDetector(
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
                    margin: const EdgeInsets.only(bottom: 20),
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.file(coverImage!).image,
                      ),
                    ),
                  ),
                ),
          Button(
            text: 'UPLOAD',
            ontap: () async {
              int sizeOfImage = coverImage!.readAsBytesSync().lengthInBytes;

              if (sizeOfImage > 5000000) {
                CustomToast.showToast(context,
                    message: 'file exceeding 5MB',
                    toastType: ToastType.warning);
                return;
              }
              var url = await fileProvider.uploadFile(
                coverImage!,
                coverImage!.path.split('.').last,
              );
              if (url != null) {
                workspaceProvider.updateWorkspace(data: {
                  'logo': url,
                }, ref: ref);
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
