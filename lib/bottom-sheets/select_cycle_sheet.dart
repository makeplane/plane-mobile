// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/const.dart';
import 'package:plane/models/cycle/cycle_detail.model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_button.dart';
import '../mixins/widget_state_mixin.dart';
import '../utils/enums.dart';
import '../widgets/custom_text.dart';

class SelectCycleSheet extends ConsumerStatefulWidget {
  const SelectCycleSheet({required this.cycles, super.key});
  final List<CycleDetailModel> cycles;
  @override
  ConsumerState<SelectCycleSheet> createState() => _SelectCycleSheetState();
}

class _SelectCycleSheetState extends ConsumerState<SelectCycleSheet>
    with WidgetStateMixin {
  List<CycleDetailModel> cycles = [];
  int? selected;

  Future<void> handleTransferIssues() async {
    if (selected == null) {
      return;
    }
    final cycleNotifier = ref.read(ProviderList.cycleProvider.notifier);
    await cycleNotifier.transferIssues(
        cycles[selected!].id, cycles[selected!].id);
    Navigator.pop(Const.globalKey.currentContext!);
  }

  @override
  void initState() {
    cycles = widget.cycles;
    cycles.removeWhere((cycle) =>
        cycle.end_date != null &&
        DateTime.parse(cycle.end_date!).isBefore(DateTime.now()));
    super.initState();
  }

  @override
  Widget render(BuildContext context) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Wrap(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText('Transfer Issues',
                    type: FontStyle.H4,
                    fontWeight: FontWeightt.Semibold,
                    color: themeManager.primaryTextColor),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: themeManager.placeholderTextColor,
                    ))
              ],
            ),
            Container(
              height: 10,
            ),
            cycles.isNotEmpty
                ? ListView.builder(
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selected = index;
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                                height: 40,
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: CustomText(
                                  cycles[index].name,
                                  type: FontStyle.Medium,
                                )),
                            const Spacer(),
                            selected == index
                                ? Icon(
                                    Icons.done,
                                    color: themeManager.textSuccessColor,
                                  )
                                : const SizedBox()
                          ],
                        ),
                      );
                    },
                    itemCount: cycles.length,
                    shrinkWrap: true,
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 50, bottom: 50),
                    alignment: Alignment.center,
                    child: const CustomText(
                      'You don’t have any current cycle. Please create one to transfer the issues. ',
                      type: FontStyle.Medium,
                      textAlign: TextAlign.center,
                    ),
                  ),
            cycles.isNotEmpty
                ? Button(text: 'Tranfer Issues', ontap: handleTransferIssues)
                : const SizedBox()
          ],
        ));
  }
}
