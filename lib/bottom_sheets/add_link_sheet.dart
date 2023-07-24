import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class AddLinkSheet extends ConsumerStatefulWidget {
  final String issueId;
  final int index;
  const AddLinkSheet({required this.issueId, required this.index, super.key});

  @override
  ConsumerState<AddLinkSheet> createState() => _AddLinkSheetState();
}

class _AddLinkSheetState extends ConsumerState<AddLinkSheet> {
  TextEditingController title = TextEditingController();
  TextEditingController url = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.read(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issueProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: themeProvider.isDarkThemeEnabled
            ? darkBackgroundColor
            : lightBackgroundColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    'Add Link',
                    type: FontStyle.heading,
                    // color: themeProvider.secondaryTextColor,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        color: themeProvider.isDarkThemeEnabled
                            ? lightBackgroundColor
                            : darkBackgroundColor,
                      ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const CustomText(
                'Title',
                type: FontStyle.description,
                // color: themeProvider.secondaryTextColor,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: title,
                decoration: kTextFieldDecoration,
              ),
              const SizedBox(
                height: 20,
              ),
              const CustomText(
                'URL',
                type: FontStyle.description,
                // color: themeProvider.secondaryTextColor,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: url,
                decoration: kTextFieldDecoration,
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Button(
            text: 'Add Link',
            ontap: () {
              if (title.text.isNotEmpty && url.text.isNotEmpty) {
                issueProvider.addLink(
                    projectId: ref
                        .watch(ProviderList.projectProvider)
                        .currentProject['id'],
                    slug: ref
                        .watch(ProviderList.workspaceProvider)
                        .selectedWorkspace!
                        .workspaceSlug,
                    issueId: widget.issueId,
                    index: widget.index,
                    data: {
                      'metadata': {},
                      'title': title.text.trim(),
                      'url': url.text.trim(),
                    },
                    method: CRUD.create,
                    linkId: '');
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }
}
