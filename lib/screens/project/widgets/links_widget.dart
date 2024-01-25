import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/bottom-sheets/add_link_sheet.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

Widget links({required WidgetRef ref, required BuildContext context}) {
  final themeProvider = ref.watch(ProviderList.themeProvider);
  final moduleProvider = ref.read(ProviderList.modulesProvider);
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          'Links',
          type: FontStyle.Medium,
          fontWeight: FontWeightt.Medium,
          color: themeProvider.themeManager.primaryTextColor,
        ),
        GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                enableDrag: true,
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
                context: context,
                builder: (ctx) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: const AddLinkSheet(),
                    ),
                  );
                },
              );
            },
            child: Icon(
              Icons.add,
              color: themeProvider.themeManager.primaryTextColor,
            ))
      ],
    ),
    const SizedBox(height: 10),
    moduleProvider.moduleDetailsData['link_module'].isNotEmpty
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: themeProvider.themeManager.primaryBackgroundDefaultColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: themeProvider.themeManager.borderSubtle01Color,
              ),
            ),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    moduleProvider.moduleDetailsData['link_module'].length,
                itemBuilder: (ctx, index) {
                  return SizedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Transform.rotate(
                            angle: -20,
                            child: Icon(
                              Icons.link,
                              color:
                                  themeProvider.themeManager.primaryTextColor,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            moduleProvider.moduleDetailsData['link_module']
                                        [index]['title'] !=
                                    null
                                ? CustomText(
                                    moduleProvider
                                        .moduleDetailsData['link_module'][index]
                                            ['title']
                                        .toString(),
                                    type: FontStyle.Medium,
                                  )
                                : Container(),
                            CustomText(
                              'by ${moduleProvider.moduleDetailsData['link_module'][index]['created_by_detail']['display_name']}',
                              type: FontStyle.Small,
                              color: themeProvider
                                  .themeManager.placeholderTextColor,
                            )
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
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
                              )),
                              context: context,
                              builder: (ctx) {
                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: AddLinkSheet(
                                      id: moduleProvider
                                              .moduleDetailsData['link_module']
                                          [index]['id'],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Icon(
                            Icons.edit_outlined,
                            color:
                                themeProvider.themeManager.placeholderTextColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            moduleProvider.handleLinks(
                                linkID: moduleProvider
                                        .moduleDetailsData['link_module'][index]
                                    ['id'],
                                data: {},
                                method: HttpMethod.delete,
                                context: context);
                          },
                          child: Icon(
                            Icons.delete_outline,
                            color:
                                themeProvider.themeManager.placeholderTextColor,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          )
        : Container()
  ]);
}
