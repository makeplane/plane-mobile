import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';

import '../../utils/enums.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';

class DeleteEstimateSheet extends ConsumerStatefulWidget {
  const DeleteEstimateSheet({
    super.key,
    required this.estimateName,
    required this.estimateId,
  });
  final String estimateName;
  final String estimateId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeleteEstimateSheetState();
}

class _DeleteEstimateSheetState extends ConsumerState<DeleteEstimateSheet> {
  @override
  Widget build(BuildContext context) {
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
                    'Delete Estimate',
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
                'Are you sure you want to delete estimate - ${widget.estimateName}? The estimate will be removed from all the issues.',
                type: FontStyle.H5,
                fontSize: 20,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Button(
              ontap: () {
                ref.read(ProviderList.estimatesProvider).deleteEstimates(
                      slug: ref
                          .read(ProviderList.workspaceProvider)
                          .selectedWorkspace
                          .workspaceSlug,
                      projID: ref
                          .read(ProviderList.projectProvider)
                          .currentProject['id'],
                      estimateID: widget.estimateId,
                    );
                Navigator.of(context).pop();
              },
              text: 'Delete Estimate',
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}
