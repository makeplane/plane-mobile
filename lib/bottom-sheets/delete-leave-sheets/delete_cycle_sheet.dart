// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/mixins/widget_state_mixin.dart';
import 'package:plane/models/cycle/cycle_detail.model.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';

class DeleteCycleSheet extends ConsumerStatefulWidget {
  const DeleteCycleSheet({required this.cycle, super.key});
  final CycleDetailModel cycle;

  @override
  ConsumerState<DeleteCycleSheet> createState() => _DeleteCycleSheetState();
}

class _DeleteCycleSheetState extends ConsumerState<DeleteCycleSheet>
    with WidgetStateMixin {
  bool isDeleting = false;

  Future<void> handleDeleteCycle() async {
    final cycleNotifier = ref.read(ProviderList.cycleProvider.notifier);
    final projectProvider = ref.read(ProviderList.projectProvider);
    if (projectProvider.role != Role.admin &&
        projectProvider.role != Role.member) {
      Navigator.of(context).pop();
      CustomToast.showToast(context,
          message: accessRestrictedMSG, toastType: ToastType.failure);
      return;
    }

    cycleNotifier
        .deleteCycle(widget.cycle.id)
        .then((value) {
      value.fold((err) {
        CustomToast.showToast(context,
            message: err.messsage, toastType: ToastType.failure);
      }, (_) {
        CustomToast.showToast(context,
            message: 'Cycle deleted successfully',
            toastType: ToastType.success);
      });
    });
    Navigator.pop(context);
  }

  @override
  Widget render(BuildContext context) {
    final themeProvider = ref.read(ProviderList.themeProvider);
    return Wrap(
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
            minHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          child: Container(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          'Delete Cycle',
                          type: FontStyle.H4,
                          fontWeight: FontWeightt.Semibold,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close,
                            color:
                                themeProvider.themeManager.placeholderTextColor,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomText(
                      'Are you sure you want to delete cycle - ${widget.cycle.name}? All of the data related to the cycle will be permanently removed. This action cannot be undone.',
                      maxLines: 5,
                      type: FontStyle.H6,
                      textAlign: TextAlign.left,
                      color: themeProvider.themeManager.primaryTextColor,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                Button(
                  color: Colors.redAccent,
                  text: 'Delete',
                  ontap: handleDeleteCycle,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
