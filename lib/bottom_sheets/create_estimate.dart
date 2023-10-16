import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_rich_text.dart';
import '../widgets/custom_text.dart';
import '../utils/enums.dart';

class CreateEstimate extends ConsumerStatefulWidget {
  const CreateEstimate({super.key, this.estimatedata});
  final Map? estimatedata;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateEstimateState();
}

class _CreateEstimateState extends ConsumerState<CreateEstimate> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<TextEditingController> pointControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.estimatedata != null) {
      titleController.text = widget.estimatedata!['name'];
      descriptionController.text = widget.estimatedata!['description'];

      for (int i = 0; i < pointControllers.length; i++) {
        pointControllers[i].text = widget.estimatedata!['points'][i]['value'];
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    for (int i = 0; i < pointControllers.length; i++) {
      pointControllers[i].dispose();
    }
    super.dispose();
  }

  bool checkDuplicatePoints() {
    for (int i = 0; i < pointControllers.length; i++) {
      for (int j = i + 1; j < pointControllers.length; j++) {
        if (pointControllers[i].text == pointControllers[j].text) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final estimateProvider = ref.watch(ProviderList.estimatesProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
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
                  Container(
                    height: 30,
                  ),
                  Form(
                    key: formKey,
                    child: Wrap(
                      //  crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 25,
                        ),
                        const CustomRichText(
                          widgets: [
                            TextSpan(text: 'Name'),
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
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                          controller: titleController,
                          decoration:
                              themeProvider.themeManager.textFieldDecoration,
                        ),
                        Container(
                          height: 20,
                        ),
                        const CustomRichText(
                          widgets: [
                            TextSpan(text: 'Description'),
                          ],
                          type: FontStyle.Small,
                        ),
                        Container(
                          height: 10,
                        ),
                        TextFormField(
                          controller: descriptionController,
                          decoration: themeProvider
                              .themeManager.textFieldDecoration
                              .copyWith(
                                  contentPadding: const EdgeInsets.all(15)),
                          maxLines: 6,
                        ),
                        for (int i = 0; i < pointControllers.length; i++)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                              ),
                              CustomRichText(
                                widgets: [
                                  TextSpan(text: 'Point ${i + 1}'),
                                  const TextSpan(
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
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a point';
                                  }
                                  return null;
                                },
                                controller: pointControllers[i],
                                decoration: themeProvider
                                    .themeManager.textFieldDecoration,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Container(
                    height: bottomSheetConstBottomPadding,
                  ),
                  Button(
                    text: widget.estimatedata != null
                        ? 'Update Estimate'
                        : 'Create Estimate',
                    ontap: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      if (checkDuplicatePoints()) {
                        CustomToast.showToast(context,
                            message: 'Duplicate points are not allowed',
                            toastType: ToastType.warning);

                        return;
                      }

                      final data = widget.estimatedata != null
                          ? {
                              'estimate': {
                                'name': titleController.text,
                                'description': descriptionController.text,
                              },
                              'estimate_points': [
                                for (int i = 0;
                                    i < pointControllers.length;
                                    i++)
                                  {
                                    'key': i,
                                    'value': pointControllers[i].text,
                                    'id': widget.estimatedata!['points'][i]
                                        ['id'],
                                  },
                              ],
                            }
                          : {
                              'estimate': {
                                'name': titleController.text,
                                'description': descriptionController.text,
                              },
                              'estimate_points': [
                                for (int i = 0;
                                    i < pointControllers.length;
                                    i++)
                                  {
                                    'key': i,
                                    'value': pointControllers[i].text,
                                  },
                              ],
                            };

                      widget.estimatedata != null
                          ? estimateProvider.updateEstimates(
                              slug: ref
                                  .read(ProviderList.workspaceProvider)
                                  .selectedWorkspace
                                  .workspaceSlug,
                              projID: ref
                                  .read(ProviderList.projectProvider)
                                  .currentProject['id'],
                              body: data,
                              estimateID: widget.estimatedata!['id'],
                            )
                          : estimateProvider.createEstimates(
                              slug: ref
                                  .read(ProviderList.workspaceProvider)
                                  .selectedWorkspace
                                  .workspaceSlug,
                              projID: ref
                                  .read(ProviderList.projectProvider)
                                  .currentProject['id'],
                              body: data,
                            );
                      Navigator.of(context).pop();
                    },
                  ),
                  Container(
                    height: bottomSheetConstBottomPadding,
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: themeProvider.themeManager.primaryBackgroundDefaultColor,
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  widget.estimatedata != null
                      ? 'Edit Estimate'
                      : 'Create Estimate',
                  type: FontStyle.H4,
                  fontWeight: FontWeightt.Semibold,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: themeProvider.themeManager.placeholderTextColor,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
