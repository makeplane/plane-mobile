import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/models/project/issue-filter-properties-and-view/issue_filter_and_properties.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class DisplayPropertiesList extends ConsumerStatefulWidget {
  const DisplayPropertiesList(
      {required this.onchange,
      required this.dProperties,
      required this.layout,
      super.key});
  final DisplayPropertiesModel dProperties;
  final Function(DisplayPropertiesModel dProperties) onchange;
  final IssuesLayout layout;
  @override
  ConsumerState<DisplayPropertiesList> createState() =>
      _DisplayPropertiesListState();
}

class _DisplayPropertiesListState extends ConsumerState<DisplayPropertiesList> {
  List properties = [];

  @override
  void initState() {
    properties = [
      {
        'name': 'Assignee',
        'selected': widget.dProperties.assignee,
      },
      {
        'name': 'ID',
        'selected': widget.dProperties.key,
      },
      {
        'name': 'Due Date',
        'selected': widget.dProperties.due_date,
      },
      {
        'name': 'Label',
        'selected': widget.dProperties.labels,
      },
      {
        'name': 'Priority',
        'selected': widget.dProperties.priority,
      },
      // {
      //   'name': 'State',
      //   'selected': widget.dProperties.state,
      // },
      {
        'name': 'Sub Issue Count',
        'selected': widget.dProperties.sub_issue_count,
      },
      {
        'name': 'Attachment Count',
        'selected': widget.dProperties.attachment_count,
      },
      {
        'name': 'Link',
        'selected': widget.dProperties.link,
      },
      {
        'name': 'Estimate',
        'selected': widget.dProperties.estimate,
      },
      // {
      //   'name': 'Created on',
      //   'selected': widget.dProperties.created_on,
      // },
      // {
      //   'name': 'Updated on',
      //   'selected': widget.dProperties.updated_on,
      // },
      {
        'name': 'Start Date',
        'selected': widget.dProperties.start_date,
      }
    ];
    super.initState();
  }

  DisplayPropertiesModel fromProperties() {
    return DisplayPropertiesModel(
      assignee: properties[0]['selected'] ?? false,
      due_date: properties[2]['selected'] ?? false,
      labels: properties[3]['selected'] ?? false,
      priority: properties[4]['selected'] ?? false,
      state: properties[5]['selected'] ?? false,
      sub_issue_count: properties[6]['selected'] ?? false,
      attachment_count: properties[7]['selected'] ?? false,
      link: properties[8]['selected'] ?? false,
      estimate: properties[9]['selected'] ?? false,
      created_on: properties[10]['selected'] ?? false,
      updated_on: properties[11]['selected'] ?? false,
      start_date: properties[12]['selected'] ?? false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ref.watch(ProviderList.themeProvider).themeManager;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText('Display Properties',
              type: FontStyle.Large,
              fontWeight: FontWeightt.Semibold,
              textAlign: TextAlign.start),
          Container(height: 20),
          Wrap(
              runSpacing: 10,
              children: properties
                  .map((tag) => ((tag['name'] != 'Priority' &&
                              tag['name'] != 'ID' &&
                              tag['name'] != 'Assignee') &&
                          widget.layout == IssuesLayout.list)
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              tag['selected'] = !tag['selected'];
                            });
                            widget.onchange(fromProperties());
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: tag['selected'] ?? false
                                  ? themeManager.primaryColour
                                  : themeManager.primaryBackgroundDefaultColor,
                              border: Border.all(
                                color: tag['selected'] ?? false
                                    ? Colors.transparent
                                    : themeManager.borderSubtle01Color,
                              ),
                            ),
                            child: CustomText(tag['name'],
                                textAlign: TextAlign.center,
                                type: FontStyle.Medium,
                                overrride: true,
                                height: 1,
                                fontWeight: FontWeightt.Regular,
                                color: tag['selected'] ?? false
                                    ? Colors.white
                                    : themeManager.primaryTextColor),
                          ),
                        ))
                  .toList()),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
