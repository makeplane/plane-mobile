import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class TypeSheet extends ConsumerStatefulWidget {
  final Enum issueCategory;
  const TypeSheet({super.key, required this.issueCategory});

  @override
  ConsumerState<TypeSheet> createState() => _TypeSheetState();
}

class _TypeSheetState extends ConsumerState<TypeSheet> {
  var selected = 0;
  @override
  void initState() {
    var prov = ref.read(ProviderList.issuesProvider);
    selected = prov.issues.projectView == ProjectView.kanban
        ? 0
        : prov.issues.projectView == ProjectView.list
            ? 1
            : prov.issues.projectView == ProjectView.calendar
                ? 2
                : 3;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var prov = ref.watch(ProviderList.issuesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 23, left: 23, right: 23),
      child: Wrap(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  const CustomText(
                    'Layout',
                    type: FontStyle.H4,
                    fontWeight: FontWeightt.Semibold,
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
              Container(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selected = 1;
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                          visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          fillColor: selected == 1
                              ? null
                              : MaterialStateProperty.all<Color>(
                                   themeProvider.themeManager.borderSubtle01Color),
                          groupValue: selected,
                          activeColor:  themeProvider.themeManager.primaryColour,
                          value: 1,
                          onChanged: (val) {}),
                      const SizedBox(width: 10),
                       CustomText(
                        'List View',
                        type: FontStyle.H6,
                        color: themeProvider.themeManager.tertiaryTextColor,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1,
                width: double.infinity,
                child: Container(
                  color: themeProvider.themeManager.borderSubtle01Color,
                ),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selected = 0;
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                          visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          fillColor: selected == 0
                              ? null
                              : MaterialStateProperty.all<Color>(
                                  themeProvider.themeManager.borderSubtle01Color),
                          groupValue: selected,
                          activeColor:  themeProvider.themeManager.primaryColour,
                          value: 0,
                          onChanged: (val) {
                            // setState(() {
                            //   selected = 0;
                            // });
                          }),
                      const SizedBox(width: 10),
                      CustomText(
                        'Board View',
                        type: FontStyle.H6,
                        color: themeProvider.themeManager.tertiaryTextColor,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1,
                width: double.infinity,
                child: Container(
                 color:  themeProvider.themeManager.borderSubtle01Color
                ),
              ),
              SizedBox(
                height: 1,
                width: double.infinity,
                child: Container(
                color:  themeProvider.themeManager.borderSubtle01Color,
                ),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selected = 2;
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                          visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          fillColor: selected == 2
                              ? null
                              : MaterialStateProperty.all<Color>(
                                   themeProvider.themeManager.borderSubtle01Color),
                          groupValue: selected,
                          activeColor:  themeProvider.themeManager.primaryColour,
                          value: 2,
                          onChanged: (val) {}),
                      const SizedBox(width: 10),
                      CustomText(
                        'Calendar View',
                        type: FontStyle.H6,
                        color: themeProvider.themeManager.tertiaryTextColor,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1,
                width: double.infinity,
                child: Container(
                color:   themeProvider.themeManager.borderSubtle01Color,
                ),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selected = 3;
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                          visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          fillColor: selected == 3
                              ? null
                              : MaterialStateProperty.all<Color>(
                                 themeProvider.themeManager.borderSubtle01Color),
                          groupValue: selected,
                          activeColor:  themeProvider.themeManager.primaryColour,
                          value: 3,
                          onChanged: (val) {}),
                      const SizedBox(width: 10),
                      CustomText(
                        'Spreadsheet View',
                        type: FontStyle.H6,
                        color: themeProvider.themeManager.tertiaryTextColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          //long blue button to apply filter
          Container(
            margin: const EdgeInsets.only(bottom: 18, top: 20),
            child: Button(
              text: 'Apply Filter',
              ontap: () {
                if (selected == 0) {
                  prov.issues.projectView = ProjectView.kanban;
                  prov.tempProjectView = ProjectView.kanban;
                } else if (selected == 1) {
                  prov.issues.projectView = ProjectView.list;
                  prov.tempProjectView = ProjectView.list;
                } else if (selected == 2) {
                  prov.issues.projectView = ProjectView.calendar;
                  prov.tempProjectView = ProjectView.calendar;
                } else if (selected == 3) {
                  prov.issues.projectView = ProjectView.spreadsheet;
                  prov.tempProjectView = ProjectView.spreadsheet;
                }
                prov.setsState();
                if (widget.issueCategory == IssueCategory.issues) {
                  prov.updateProjectView();
                }

                Navigator.pop(context);
              },
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
