import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';

import '../utils/enums.dart';

// ignore: must_be_immutable
class LabelSheet extends ConsumerStatefulWidget {
  LabelSheet({required this.pageIndex, this.selectedLabels, super.key});
  final int pageIndex;
  List? selectedLabels = [];
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LabelSheetState();
}

class _LabelSheetState extends ConsumerState<LabelSheet> {
  List<String> tags = [
    'Label 1',
    'Label 2',
    'Label 3',
    'Label 4',
    'Label 5',
    'Label 6',
    'Label 7',
    'Label 8',
    'Label 9',
  ];
  List selectedLabels = [];
  @override
  void initState() {
    selectedLabels = widget.selectedLabels!;
    super.initState();
  }

  var height = 0.0;
  TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    var pageProvider = ref.watch(ProviderList.pageProvider);
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var box = context.findRenderObject() as RenderBox;
      height = box.size.height;
    });
    return Container(
        padding: const EdgeInsets.only(top: 23, left: 23, right: 23),
        child: Stack(
          children: [
            Wrap(children: [
              //text heading
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    'Add Label',
                    type: FontStyle.H6,
                    fontWeight: FontWeightt.Semibold,
                  ),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: themeProvider.isDarkThemeEnabled
                            ? lightSecondaryBackgroundColor
                            : darkSecondaryBGC,
                      ))
                ],
              ),
              Container(height: 20),
              const CustomText(
                'Search',
                type: FontStyle.Small,
                // color: themeProvider.secondaryTextColor,
              ),
              Container(height: 5),
              TextField(
                controller: search,
                onChanged: (val) {},
                decoration:
                    themeProvider.themeManager.textFieldDecoration.copyWith(
                        // fillColor: themeProvider.isDarkThemeEnabled
                        //     ? darkBackgroundColor
                        //     : lightBackgroundColor,
                        // filled: true,
                        ),
              ),
              Container(height: 20),

              Wrap(
                children: issuesProvider.labels.map((label) {
                  return search.text.toLowerCase().contains(
                              label["name"].toString().toLowerCase()) ||
                          search.text.trim().isEmpty
                      ? GestureDetector(
                          onTap: () {
                            if (selectedLabels.contains(label["id"])) {
                              selectedLabels.remove(label["id"]);
                            } else {
                              selectedLabels.add(label["id"]);
                            }
                            setState(() {});
                            // print(selectedLabels);
                          },
                          child: Container(
                            margin:
                                const EdgeInsets.only(right: 10, bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: selectedLabels.contains(label["id"])
                                  ? primaryColor
                                  : (themeProvider.isDarkThemeEnabled
                                      ? darkBackgroundColor
                                      : lightBackgroundColor),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: themeProvider.isDarkThemeEnabled
                                    ? darkThemeBorder
                                    : const Color.fromARGB(255, 193, 192, 192),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 6,
                                  backgroundColor: Color(
                                    int.parse(
                                      label["color"]
                                          .toString()
                                          .replaceAll('#', '0xFF'),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                CustomText(
                                  label["name"],
                                  type: FontStyle.Small,
                                  color: selectedLabels.contains(label["id"])
                                      ? Colors.white
                                      : (themeProvider.isDarkThemeEnabled
                                          ? darkPrimaryTextColor
                                          : lightPrimaryTextColor),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(
                          width: 0,
                        );
                }).toList(),
              ),
              Container(height: 40),
              Button(
                ontap: () async {
                  await pageProvider.editPage(
                      slug: workspaceProvider.selectedWorkspace!.workspaceSlug,
                      projectId: projectProvider.currentProject['id'],
                      pageId: pageProvider.pages[pageProvider.selectedFilter]![
                          widget.pageIndex]['id'],
                      data: {
                        "labels_list": selectedLabels,
                      });
                  if (pageProvider.blockSheetState == StateEnum.success) {
                    pageProvider.selectedLabels.clear();
                    for (var element in (pageProvider.pages[
                            pageProvider.selectedFilter]![widget.pageIndex]
                        ['label_details'] as List)) {
                      pageProvider.selectedLabels.add(element['id']);
                    }
                    pageProvider.setState();
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                text: 'Add Labels',
              ),
              Container(height: 20),
            ]),
            pageProvider.blockSheetState == StateEnum.loading
                ? Container(
                    height: height - 32,
                    alignment: Alignment.center,
                    color: themeProvider.isDarkThemeEnabled
                        ? darkSecondaryBGC.withOpacity(0.7)
                        : lightSecondaryBackgroundColor.withOpacity(0.7),
                    // height: 25,
                    // width: 25,
                    child: Center(
                      child: SizedBox(
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
                    ),
                  )
                : const SizedBox(),
          ],
        ));
  }
}
