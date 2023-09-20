// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/const.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/provider/cycles_provider.dart';
import 'package:plane/provider/theme_provider.dart';
import 'package:plane/widgets/custom_button.dart';

import '../mixins/widget_state_mixin.dart';
import '../utils/enums.dart';
import '../widgets/custom_text.dart';

class SelectCycleSheet extends ConsumerStatefulWidget {
  const SelectCycleSheet({super.key});

  @override
  ConsumerState<SelectCycleSheet> createState() => _SelectCycleSheetState();
}

class _SelectCycleSheetState extends ConsumerState<SelectCycleSheet>
    with WidgetState {
  List<dynamic> cycles = [];
  int? selected;
  @override
  void initState() {
    CyclesProvider cyclesProvider = ref.read(ProviderList.cyclesProvider);
    cycles = List.from(cyclesProvider.cyclesAllData);
    cycles.removeWhere((element) =>
        DateTime.parse(element['end_date']).isBefore(DateTime.now()));

    super.initState();
  }

  @override
  LoadingType getLoading(WidgetRef ref) {
    return setWidgetState([
      ref.read(ProviderList.cyclesProvider).transferIssuesState,
    ], loadingType: LoadingType.wrap);
  }

  @override
  Widget render(BuildContext context) {
    CyclesProvider cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    ThemeProvider themeProvider = ref.watch(ProviderList.themeProvider);
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
                    color: themeProvider.themeManager.primaryTextColor),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: themeProvider.themeManager.placeholderTextColor,
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
                                  cycles[index]['name'],
                                  type: FontStyle.Medium,
                                )),
                            const Spacer(),
                            selected == index
                                ? Icon(
                                    Icons.done,
                                    color: themeProvider
                                        .themeManager.textSuccessColor,
                                   
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
                ? Button(
                    text: 'Tranfer Issues',
                    ontap: () async {
                      if (selected == null) {
                        return;
                      }
                      await cyclesProvider.transferIssues(
                          newCycleID: cycles[selected!]['id'],
                          context: context);
                      Navigator.of(Const.globalKey.currentContext!).pop();
                    },
                  )
                : const SizedBox()
          ],
        ));
  }
}
