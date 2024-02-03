// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';

class DeleteLabelSheet extends ConsumerStatefulWidget {
  const DeleteLabelSheet(
      {required this.labelName, required this.labelId, super.key});
  final String labelName;
  final String labelId;

  @override
  ConsumerState<DeleteLabelSheet> createState() => _DeleteLabelSheetState();
}

class _DeleteLabelSheetState extends ConsumerState<DeleteLabelSheet> {
  @override
  Widget build(BuildContext context) {
    final labelNotifier = ref.read(ProviderList.labelProvider.notifier);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  const CustomText(
                    'Delete Label',
                    type: FontStyle.H6,
                    fontWeight: FontWeightt.Semibold,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 27,
                      color: Color.fromRGBO(143, 143, 147, 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CustomText(
                'Are you sure you want to delete label- ${widget.labelName}? The label will be removed from all the issues.',
                type: FontStyle.H5,
                fontSize: 20,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Button(
              ontap: () async {
                await labelNotifier.deleteLabel(widget.labelId);
                ref
                    .read(ProviderList.projectIssuesProvider.notifier)
                    .fetchIssues();

                Navigator.of(context).pop();
              },
              text: 'Delete Label',
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}
