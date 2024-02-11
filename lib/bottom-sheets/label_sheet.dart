import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/core/extensions/string_extensions.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_text.dart';

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

  double height = 0.0;
  TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final labelProvider = ref.watch(ProviderList.labelProvider);
    final pageProvider = ref.watch(ProviderList.pageProvider);
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final box = context.findRenderObject() as RenderBox;
      height = box.size.height;
    });
    return Container(
        padding: const EdgeInsets.only(top: 23, left: 23, right: 23),
        child: Stack(
          children: [
            Wrap(children: [
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
                        color: themeProvider.themeManager.placeholderTextColor,
                      ))
                ],
              ),
              Container(height: 20),
              const CustomText(
                'Search',
                type: FontStyle.Small,
              ),
              Container(height: 5),
              TextField(
                controller: search,
                onChanged: (val) {},
                decoration:
                    themeProvider.themeManager.textFieldDecoration.copyWith(),
              ),
              Container(height: 20),
              Wrap(
                children: labelProvider.projectLabels.values.map((label) {
                  return search.text
                              .toLowerCase()
                              .contains(label.name.toLowerCase()) ||
                          search.text.trim().isEmpty
                      ? GestureDetector(
                          onTap: () {
                            if (selectedLabels.contains(label.id)) {
                              selectedLabels.remove(label.id);
                            } else {
                              selectedLabels.add(label.id);
                            }
                            setState(() {});
                          },
                          child: Container(
                            margin:
                                const EdgeInsets.only(right: 10, bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: selectedLabels.contains(label.id)
                                  ? themeProvider.themeManager.primaryColour
                                  : (themeProvider.themeManager
                                      .primaryBackgroundDefaultColor),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: themeProvider
                                    .themeManager.borderSubtle01Color,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                    radius: 6,
                                    backgroundColor: label.color.toColor()),
                                const SizedBox(
                                  width: 10,
                                ),
                                CustomText(
                                  label.name,
                                  type: FontStyle.Small,
                                  overrride: true,
                                  color: selectedLabels.contains(label.id)
                                      ? Colors.white
                                      : (themeProvider
                                          .themeManager.primaryTextColor),
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
                      context: context,
                      slug: workspaceProvider.selectedWorkspace.workspaceSlug,
                      projectId: projectProvider.currentProject['id'],
                      pageId: pageProvider.pages[pageProvider.selectedFilter]![
                          widget.pageIndex]['id'],
                      data: {
                        "labels_list": selectedLabels,
                      },
                      ref: ref);
                  if (pageProvider.blockSheetState == DataState.success) {
                    pageProvider.selectedLabels.clear();
                    for (final element in (pageProvider.pages[
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
            pageProvider.blockSheetState == DataState.loading
                ? Container(
                    height: height - 32,
                    alignment: Alignment.center,
                    color: themeProvider
                        .themeManager.primaryBackgroundDefaultColor,
                    child: Center(
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: LoadingIndicator(
                          indicatorType: Indicator.lineSpinFadeLoader,
                          colors: [themeProvider.themeManager.primaryTextColor],
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
