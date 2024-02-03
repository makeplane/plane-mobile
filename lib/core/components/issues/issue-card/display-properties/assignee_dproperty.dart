// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/square_avatar_widget.dart';

class AssigneeDProperty extends ConsumerWidget {
  const AssigneeDProperty({required this.assignee_ids, super.key});
  final List<String> assignee_ids;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;

    return (assignee_ids.isNotEmpty)
        ? Container(
            margin: const EdgeInsets.only(right: 5),
            child: SquareAvatarWidget(
              member_ids: assignee_ids,
            ),
          )
        : Container(
            height: 30,
            margin: const EdgeInsets.only(right: 5),
            padding: const EdgeInsets.only(left: 8, right: 8),
            decoration: BoxDecoration(
                border: Border.all(
                  color: themeManager.borderSubtle01Color,
                ),
                borderRadius: BorderRadius.circular(4)),
            child: Icon(
              Icons.groups_2_outlined,
              size: 18,
              color: themeManager.tertiaryTextColor,
            ),
          );
  }
}
