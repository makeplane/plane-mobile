import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_rich_text.dart';
import '../widgets/custom_text.dart';
import '../utils/enums.dart';

class CreateEstimate extends ConsumerStatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final estimatedata;
  const CreateEstimate({super.key, this.estimatedata});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateEstimateState();
}

class _CreateEstimateState extends ConsumerState<CreateEstimate> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController point_1 = TextEditingController();
  final TextEditingController point_2 = TextEditingController();
  final TextEditingController point_3 = TextEditingController();
  final TextEditingController point_4 = TextEditingController();
  final TextEditingController point_5 = TextEditingController();
  final TextEditingController point_6 = TextEditingController();

  @override
  void initState() {
    super.initState();
    // log('data ${widget.estimatedata}');
    if (widget.estimatedata != null) {
      titleController.text = widget.estimatedata['name'];
      descriptionController.text = widget.estimatedata['description'];
      point_1.text = widget.estimatedata['points'][0]['value'];
      point_2.text = widget.estimatedata['points'][1]['value'];
      point_3.text = widget.estimatedata['points'][2]['value'];
      point_4.text = widget.estimatedata['points'][3]['value'];
      point_5.text = widget.estimatedata['points'][4]['value'];
      point_6.text = widget.estimatedata['points'][5]['value'];
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    point_1.dispose();
    point_2.dispose();
    point_3.dispose();
    point_4.dispose();
    point_5.dispose();
    point_6.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final estimateProvider = ref.watch(ProviderList.estimatesProvider);
    return Stack(
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
                        decoration:
                            themeProvider.themeManager.textFieldDecoration,
                        maxLines: 6,
                      ),
                      Container(
                        height: 20,
                      ),
                      const CustomRichText(
                        widgets: [
                          TextSpan(text: 'Point 1'),
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
                            return 'Please enter a point';
                          }
                          return null;
                        },
                        controller: point_1,
                        decoration:
                            themeProvider.themeManager.textFieldDecoration,
                      ),
                      Container(
                        height: 20,
                      ),
                      const CustomRichText(
                        widgets: [
                          TextSpan(text: 'Point 2'),
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
                            return 'Please enter a point';
                          }
                          return null;
                        },
                        controller: point_2,
                        decoration:
                            themeProvider.themeManager.textFieldDecoration,
                      ),
                      Container(
                        height: 20,
                      ),
                      const CustomRichText(
                        widgets: [
                          TextSpan(text: 'Point 3'),
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
                            return 'Please enter a point';
                          }
                          return null;
                        },
                        controller: point_3,
                        decoration:
                            themeProvider.themeManager.textFieldDecoration,
                      ),
                      Container(
                        height: 20,
                      ),
                      const CustomRichText(
                        widgets: [
                          TextSpan(text: 'Point 4'),
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
                            return 'Please enter a point';
                          }
                          return null;
                        },
                        controller: point_4,
                        decoration:
                            themeProvider.themeManager.textFieldDecoration,
                      ),
                      Container(
                        height: 20,
                      ),
                      const CustomRichText(
                        widgets: [
                          TextSpan(text: 'Point 5'),
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
                            return 'Please enter a point';
                          }
                          return null;
                        },
                        controller: point_5,
                        decoration:
                            themeProvider.themeManager.textFieldDecoration,
                      ),
                      Container(
                        height: 20,
                      ),
                      const CustomRichText(
                        widgets: [
                          TextSpan(text: 'Point 6'),
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
                            return 'Please enter a point';
                          }
                          return null;
                        },
                        controller: point_6,
                        decoration:
                            themeProvider.themeManager.textFieldDecoration,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 20,
                ),
                Button(
                  text: widget.estimatedata != null
                      ? 'Update Estimate'
                      : 'Create Estimate',
                  ontap: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    var data = widget.estimatedata != null
                        ? {
                            'estimate': {
                              'name': titleController.text,
                              'description': descriptionController.text,
                            },
                            'estimate_points': [
                              {
                                'key': 0,
                                'value': point_1.text,
                                'id': widget.estimatedata['points'][0]['id'],
                              },
                              {
                                'key': 1,
                                'value': point_2.text,
                                'id': widget.estimatedata['points'][1]['id'],
                              },
                              {
                                'key': 2,
                                'value': point_3.text,
                                'id': widget.estimatedata['points'][2]['id'],
                              },
                              {
                                'key': 3,
                                'value': point_4.text,
                                'id': widget.estimatedata['points'][3]['id'],
                              },
                              {
                                'key': 4,
                                'value': point_5.text,
                                'id': widget.estimatedata['points'][4]['id'],
                              },
                              {
                                'key': 5,
                                'value': point_6.text,
                                'id': widget.estimatedata['points'][5]['id'],
                              },
                            ],
                          }
                        : {
                            'estimate': {
                              'name': titleController.text,
                              'description': descriptionController.text,
                            },
                            'estimate_points': [
                              {
                                'key': 0,
                                'value': point_1.text,
                              },
                              {
                                'key': 1,
                                'value': point_2.text,
                              },
                              {
                                'key': 2,
                                'value': point_3.text,
                              },
                              {
                                'key': 3,
                                'value': point_4.text,
                              },
                              {
                                'key': 4,
                                'value': point_5.text,
                              },
                              {
                                'key': 5,
                                'value': point_6.text,
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
                            estimateID: widget.estimatedata['id'],
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
                widget.estimatedata != null ? 'Edit Estimate' : 'Create Estimate',
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
    );
  }
}
