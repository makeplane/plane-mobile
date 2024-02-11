// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/core/dio/dio_service.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';

// ignore: must_be_immutable
class SelectCoverImage extends ConsumerStatefulWidget {
  SelectCoverImage({required this.uploadedUrl, super.key});
  Map<String, dynamic> uploadedUrl;
  @override
  ConsumerState<SelectCoverImage> createState() => _SelectCoverImageState();
}

class _SelectCoverImageState extends ConsumerState<SelectCoverImage> {
  int selected = 0;
  File? coverImage;
  final searchController = TextEditingController();
  int page = 1;
  final perPage = 18;
  bool isLoading = false;
  bool isSearched = false;
  PageController pageController = PageController();

  @override
  void initState() {
    // if (ref.read(ProviderList.projectProvider).unsplashImages.isEmpty) {
    //    ref.read(ProviderList.projectProvider).getUnsplashImages();
    // }

    if (isEnableAuth()) {
      getImages(true);
    } else {
      selected = 1;
      pageController = PageController(initialPage: 1);
    }

    super.initState();
  }

  bool isEnableAuth() {
    bool enableAuth = false;
    final String enableOAuth = dotenv.env['ENABLE_O_AUTH'] ?? '';
    final int enableOAuthValue = int.tryParse(enableOAuth) ?? 0;
    if (enableOAuthValue == 1) {
      enableAuth = true;
    } else {
      enableAuth = false;
    }
    return enableAuth;
  }

  List images = [];
  final dio = Dio();
  // final unspalshApi = dotenv.env['UNSPLASH_API'];

  Future getImages(bool isFirstReq) async {
    if (!isFirstReq) {
      FocusScope.of(context).unfocus();
    } else {
      isSearched = false;
      // searchController.text = '';
    }

    setState(() {
      // images.clear();
      // page = 1;
      // isSearching = true;
      isLoading = true;
    });
    //unfocus keyboard

    try {
      final url = searchController.text.isEmpty
          ? 'https://api/unsplash/&page=$page&per_page=$perPage'
          : 'https://api.unsplash/&query=${searchController.text}&page=$page&per_page=$perPage ';
      log(url);
      final response = await DioClient().request(
        hasAuth: false,
        url: url,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      //final res = jsonDecode(response.toString());
      // log(response.toString());

      searchController.text.isEmpty
          ? response.data.forEach((e) {
              images.add(e['urls']['regular']);
            })
          : response.data['results'].forEach((e) {
              images.add(e['urls']['regular']);
            });
      log(images.length.toString());
      log(images.toString());
      isLoading = false;
      if (!isFirstReq) isSearched = true;
      setState(() {});
    } on DioException catch (e) {
      log(e.error.toString());
    }
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if ((notification.metrics.pixels ==
              notification.metrics.maxScrollExtent) &&
          !isLoading &&
          images.isNotEmpty &&
          searchController.text.isNotEmpty) {
        page++;
        getImages(false);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final fileProvider = ref.watch(ProviderList.fileUploadProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return NotificationListener<ScrollNotification>(
      onNotification: onNotification,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                CustomText(
                  'Choose Cover Image',
                  type: FontStyle.H4,
                  fontWeight: FontWeightt.Semibold,
                  color: themeProvider.themeManager.primaryTextColor,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    size: 27,
                    color: themeProvider.themeManager.placeholderTextColor,
                  ),
                ),
              ],
            ),
          ),
          isEnableAuth()
              ? Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          pageController.jumpToPage(0);
                        },
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: CustomText(
                                'Unsplash',
                                color: selected == 0
                                    ? themeProvider.themeManager.primaryColour
                                    : themeProvider
                                        .themeManager.placeholderTextColor,
                                type: FontStyle.H5,
                                fontWeight: FontWeightt.Medium,
                              ),
                            ),
                            selected == 0
                                ? Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                        color: themeProvider
                                            .themeManager.primaryColour,
                                        borderRadius:
                                            BorderRadius.circular(10)))
                                : Container(
                                    height: 2,
                                    color: themeProvider
                                        .themeManager.borderSubtle01Color,
                                  )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          pageController.jumpToPage(1);
                        },
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: CustomText(
                                'Upload',
                                color: selected == 1
                                    ? themeProvider.themeManager.primaryColour
                                    : themeProvider
                                        .themeManager.placeholderTextColor,
                                type: FontStyle.H5,
                                fontWeight: FontWeightt.Medium,
                              ),
                            ),
                            selected == 1
                                ? Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                        color: themeProvider
                                            .themeManager.primaryColour,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  )
                                : Container(
                                    height: 2,
                                    color: themeProvider
                                        .themeManager.borderSubtle01Color,
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
          Expanded(
            child: PageView(
              controller: pageController,
              physics: !isEnableAuth()
                  ? const NeverScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),
              onPageChanged: (value) {
                setState(() {
                  selected = value;
                });
              },
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 15, left: 10),
                          width: MediaQuery.of(context).size.width - 130,
                          child: TextFormField(
                            controller: searchController,
                            onChanged: (value) {
                              if (value.length == 1 || value.isEmpty) {
                                setState(() {});
                              }
                            },
                            decoration: themeProvider
                                .themeManager.textFieldDecoration
                                .copyWith(
                                    hintText: 'Search for images',
                                    hintStyle: TextStyle(
                                        color: themeProvider
                                            .themeManager.placeholderTextColor),
                                    suffixIcon: searchController.text.isNotEmpty
                                        ? GestureDetector(
                                            onTap: () => setState(() {
                                              searchController.clear();
                                            }),
                                            child: const Icon(
                                              Icons.cancel,
                                              size: 20,
                                            ),
                                          )
                                        : const SizedBox()),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              images.clear();
                              page = 1;

                              getImages(true);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10, top: 15),
                              height: 46,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: themeProvider.themeManager.primaryColour,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: CustomText(
                                'Search',
                                type: FontStyle.Medium,
                                fontWeight: FontWeightt.Bold,
                                color: themeProvider.themeManager.textonColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    (images.isNotEmpty)
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child:
                                  // isSearching
                                  //     ? const Center(
                                  //         child: CircularProgressIndicator(
                                  //           color: primaryColor,
                                  //         ),
                                  //       )
                                  // :
                                  GridView.builder(
                                itemCount: images.length + 1,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 5 / 3,
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                itemBuilder: (context, index) {
                                  if (index == images.length) {
                                    return isLoading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: themeProvider
                                                  .themeManager.primaryColour,
                                            ),
                                          )
                                        : Container();
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      widget.uploadedUrl['url'] = images[index];
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: Image.network(
                                              images[index],
                                            ).image,
                                          )),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                Column(
                  children: [
                    coverImage == null
                        ? Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () async {
                                  final file = await ImagePicker()
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
                                    color: themeProvider.themeManager
                                        .tertiaryBackgroundDefaultColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.file_upload_outlined,
                                          color: themeProvider
                                              .themeManager.primaryTextColor),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      CustomText(
                                        'Upload',
                                        type: FontStyle.Small,
                                        color: themeProvider
                                            .themeManager.primaryTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    coverImage != null
                        ? GestureDetector(
                            onTap: () async {
                              final file = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (file != null) {
                                setState(() {
                                  coverImage = File(file.path);
                                });
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
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
                        : Container(),
                    coverImage != null
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                child: Button(
                                  text: 'UPLOAD',
                                  ontap: () async {
                                    final int sizeOfImage = coverImage!
                                        .readAsBytesSync()
                                        .lengthInBytes;

                                    if (sizeOfImage > 5000000) {
                                      CustomToast.showToast(context,
                                          message:
                                              'File size should be less than 5MB',
                                          toastType: ToastType.warning);
                                      return;
                                    }

                                    final url = await fileProvider.uploadFile(
                                      coverImage!,
                                      coverImage!.path.split('.').last,
                                    );
                                    if (url != null) {
                                      widget.uploadedUrl['url'] = url;
                                    }
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
