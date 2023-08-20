// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/services/dio_service.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class SelectCoverImage extends ConsumerStatefulWidget {
  final bool creatProject;
  const SelectCoverImage({required this.creatProject, super.key});

  @override
  ConsumerState<SelectCoverImage> createState() => _SelectCoverImageState();
}

class _SelectCoverImageState extends ConsumerState<SelectCoverImage> {
  var selected = 0;
  File? coverImage;
  final searchController = TextEditingController();
  var page = 1;
  final perPage = 18;
  bool isLoading = false;
  bool isSearched = false;

  @override
  void initState() {
    // if (ref.read(ProviderList.projectProvider).unsplashImages.isEmpty) {
    //    ref.read(ProviderList.projectProvider).getUnsplashImages();
    // }
    getImages(true);

    super.initState();
  }

  List images = [];
  var dio = Dio();
  final unspalshApi = dotenv.env['UNSPLASH_API'];

  Future getImages(bool isFirstReq) async {
    if (!isFirstReq) {
      FocusScope.of(context).unfocus();
    } else {
      isSearched = false;
      searchController.text = '';
    }

    setState(() {
      // images.clear();
      // page = 1;
      // isSearching = true;
      isLoading = true;
    });
    //unfocus keyboard

    try {
      var url = searchController.text.isEmpty
          ? 'https://api.unsplash.com/photos/?client_id=$unspalshApi&page=$page&per_page=$perPage'
          : 'https://api.unsplash.com/search/photos/?client_id=$unspalshApi&query=${searchController.text}&page=$page&per_page=$perPage ';
      log(url);
      var response = await DioConfig().dioServe(
        hasAuth: false,
        url: url,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      //var res = jsonDecode(response.toString());
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
    } catch (e) {
      log(e.toString());
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

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var fileProvider = ref.watch(ProviderList.fileUploadProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return NotificationListener<ScrollNotification>(
      onNotification: onNotification,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                // const Text(
                //   'Views',
                //   style: TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
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
          Container(
            //bottom border
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: lightGreeyColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
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
                                color: themeProvider.themeManager.primaryColour,
                              )
                            : Container(
                                height: 2,
                                color: lightGreeyColor,
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
                                : lightGreyTextColor,
                            type: FontStyle.H5,
                            fontWeight: FontWeightt.Medium,
                          ),
                        ),
                        selected == 1
                            ? Container(
                                height: 2,
                                color: themeProvider.themeManager.primaryColour,
                              )
                            : Container(
                                height: 2,
                                color: lightGreeyColor,
                              )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: pageController,
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
                          //   height: 50,
                          width: MediaQuery.of(context).size.width - 130,
                          child: TextFormField(
                              controller: searchController,
                              decoration: themeProvider
                                  .themeManager.textFieldDecoration
                                  .copyWith(
                                labelText: 'Search for images',
                                // labelStyle: TextStyle(
                                //     color: themeProvider.isDarkThemeEnabled
                                //         ? darkSecondaryTextColor
                                //         : lightSecondaryTextColor),
                              )),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              images.clear();
                              page = 1;

                              isSearched ? getImages(true) : getImages(false);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10, top: 15),
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: themeProvider.themeManager.primaryColour,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: CustomText(
                                isSearched ? 'Clear' : 'Search',
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
                                      if (!widget.creatProject) {
                                        projectProvider.projectDetailModel!
                                            .coverImage = images[index];
                                        projectProvider.setState();
                                      } else {
                                        projectProvider.changeCoverUrl(
                                            url: images[index]);
                                      }
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
                                      Icon(Icons.file_upload_outlined,
                                          color: themeProvider.themeManager
                                              .placeholderTextColor),
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
                        : Container(),
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
                                    int sizeOfImage = coverImage!
                                        .readAsBytesSync()
                                        .lengthInBytes;

                                    if (sizeOfImage > 5000000) {
                                      CustomToast().showToast(
                                          context,
                                          'File size should be less than 5MB',
                                          themeProvider,
                                          toastType: ToastType.warning);
                                      return;
                                    }

                                    var url = await fileProvider.uploadFile(
                                      coverImage!,
                                      coverImage!.path.split('.').last,
                                    );
                                    if (url != null) {
                                      projectProvider.changeCoverUrl(url: url);
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
