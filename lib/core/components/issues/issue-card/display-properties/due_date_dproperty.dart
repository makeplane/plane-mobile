import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class DueDateDProperties extends ConsumerWidget {
  const DueDateDProperties({this.dueDate, super.key});
  final String? dueDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;

    return Container(
      margin: const EdgeInsets.only(right: 5),
      alignment: Alignment.center,
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      decoration: BoxDecoration(
          border: Border.all(color: themeManager.borderSubtle01Color),
          borderRadius: BorderRadius.circular(4)),
      child: CustomText(
        dueDate != null
            ?
            //convert yyyy-mm-dd to Aug 12, 2021
            DateFormat('MMM dd, yyyy').format(DateTime.parse(dueDate!))
            : 'Due date',
        type: FontStyle.XSmall,
        height: 1,
        color: themeManager.tertiaryTextColor,
      ),
    );
  }
}
