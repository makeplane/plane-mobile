// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
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

  @override
  Widget build(BuildContext context) {
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var fileProvider = ref.watch(ProviderList.fileUploadProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return NotificationListener<ScrollNotification>(
      onNotification: onNotification,
      child: Stack(
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = 0;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            height: 35,
                            width: 100,
                            decoration: BoxDecoration(
                                color: selected == 0 ? primaryColor : null,
                                borderRadius: BorderRadius.circular(5)),
                            child: CustomText(
                              'Unsplash',
                              type: FontStyle.title,
                              color: selected == 0
                                  ? Colors.white
                                  : themeProvider.isDarkThemeEnabled
                                      ? darkPrimaryTextColor
                                      : lightPrimaryTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = 1;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            height: 35,
                            width: 80,
                            decoration: BoxDecoration(
                                color: selected == 1 ? primaryColor : null,
                                borderRadius: BorderRadius.circular(5)),
                            child: CustomText(
                              'Upload',
                              type: FontStyle.title,
                              color: selected == 1
                                  ? Colors.white
                                  : themeProvider.isDarkThemeEnabled
                                      ? darkPrimaryTextColor
                                      : lightPrimaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          color: themeProvider.isDarkThemeEnabled
                              ? lightBackgroundColor
                              : darkBackgroundColor,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                selected == 1
                    ? Container()
                    : Row(
                        children: [
                          SizedBox(
                            //   height: 50,
                            width: MediaQuery.of(context).size.width - 130,
                            child: TextFormField(
                                controller: searchController,
                                decoration: kTextFieldDecoration.copyWith(
                                  labelText: 'Search for images',
                                  labelStyle: TextStyle(
                                      color: themeProvider.isDarkThemeEnabled
                                          ? darkSecondaryTextColor
                                          : lightSecondaryTextColor),
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
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: CustomText(
                                  isSearched ? 'Clear' : 'Search',
                                  type: FontStyle.buttonText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                (selected == 0 && images.isNotEmpty)
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
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: primaryColor,
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
                // Wrap(
                //   children: projectProvider.unsplashImages.map((e) => GestureDetector(
                //     onTap: (){
                //     },
                //     child:
                //       Container(
                //           height: 100,
                //           width: 120,
                //           decoration: BoxDecoration(
                //               color: Colors.grey[300],
                //               image:  DecorationImage(
                //                       fit: BoxFit.cover,
                //                       image: Image.network(e['urls']['raw']!).image)
                //                  ),

                //         ),
                //   )).toList()

                // )

                selected == 1 && coverImage == null
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
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.file_upload_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  CustomText(
                                    'Upload',
                                    type: FontStyle.subheading,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),

                selected == 1 && coverImage != null
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
                    : Container(),
                selected == 1 && coverImage != null
                    ? Column(
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
                                CustomToast()
                                    .showToast(context, 'file exceeding 5MB');
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
                        ],
                      )
                    : Container()
              ],
            ),
          ),
          projectProvider.unsplashImageState == StateEnum.loading ||
                  fileProvider.fileUploadState == StateEnum.loading
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkThemeEnabled
                        ? darkSecondaryBGC.withOpacity(0.7)
                        : lightSecondaryBackgroundColor.withOpacity(0.7),
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
                                ? darkPrimaryTextColor
                                : lightPrimaryTextColor
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
      ),
    );
  }
}
