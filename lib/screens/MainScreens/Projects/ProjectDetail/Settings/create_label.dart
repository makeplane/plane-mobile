import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_rich_text.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class CreateLabel extends ConsumerStatefulWidget {
  final String? label;
  final String? labelColor;
  final CRUD method;
  final String? labelId;
  const CreateLabel(
      {this.label,
      this.labelColor,
      required this.method,
      this.labelId,
      super.key});

  @override
  ConsumerState<CreateLabel> createState() => _CreateLabelState();
}

class _CreateLabelState extends ConsumerState<CreateLabel> {
  TextEditingController lableController = TextEditingController();
  String lable = '';
  List colors = [
    '#FF6900',
    '#FCB900',
    '#7BDCB5',
    '#00D084',
    '#8ED1FC',
    '#0693E3',
    '#ABB8C3',
    '#EB144C',
    '#F78DA7',
    '#9900EF'
  ];
  bool showColoredBox = false;

  @override
  void initState() {
    super.initState();
    lableController.text = widget.label ?? '';
    lable = widget.labelColor ?? '#ABB8C3';
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issuesProvider = ref.read(ProviderList.issuesProvider);
    return GestureDetector(
      onTap: () {
        setState(() {
          showColoredBox = false;
        });
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: SingleChildScrollView(
              child: Wrap(
                //  crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    //  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            widget.method == CRUD.update
                                ? ' Edit Label'
                                : 'Add Label',
                            type: FontStyle.H6,
                            fontWeight: FontWeightt.Semibold,
                            fontSize: 22,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.close,
                              color: themeProvider.isDarkThemeEnabled
                                  ? lightSecondaryBackgroundColor
                                  : darkSecondaryBGC,
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 20,
                      ),
                      const CustomText(
                        'Color',
                        type: FontStyle.Small,
                      ),
                      Container(
                        height: 10,
                      ),
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                setState(() {
                                  showColoredBox = !showColoredBox;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(int.parse(
                                        '0xFF${lable.toString().replaceAll('#', '')}'))),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          showColoredBox
                              ? Container(
                                  width: 300,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: themeProvider.isDarkThemeEnabled
                                        ? darkSecondaryBGC
                                        : lightBackgroundColor,
                                    boxShadow: const [
                                      BoxShadow(
                                          blurRadius: 2.0, color: greyColor),
                                    ],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: colors
                                        .map((e) => GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  lable = e;
                                                  showColoredBox = false;
                                                });
                                              },
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Color(int.parse(
                                                      '0xFF${e.toString().replaceAll('#', '')}')),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                      Container(
                        height: 20,
                      ),
                      const CustomRichText(
                        widgets: [
                          TextSpan(text: 'Title'),
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                        type: FontStyle.Small,
                      ),
                      Container(
                        height: 10,
                      ),
                      TextField(
                        controller: lableController,
                        decoration: kTextFieldDecoration,
                      ),
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Button(
                    text: widget.method == CRUD.update
                        ? 'Update Label'
                        : 'Add Label',
                    ontap: () {
                      issuesProvider.issueLabels(
                          slug: ref
                              .watch(ProviderList.workspaceProvider)
                              .selectedWorkspace!
                              .workspaceSlug,
                          projID: ref
                              .watch(ProviderList.projectProvider)
                              .currentProject['id'],
                          method: widget.method,
                          data: {
                            "name": lableController.text,
                            "color": lable,
                          },
                          labelId: widget.labelId);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
