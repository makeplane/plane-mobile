import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/settings_screen.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_app_bar.dart';

// ignore: non_constant_identifier_names
PreferredSizeWidget ProjectDetailAppbar(
  BuildContext context, {
  required WidgetRef ref,
  required VoidCallback settingsOntap,
}) {
  final themeProvider = ref.read(ProviderList.themeProvider);
  final projectProvider = ref.read(ProviderList.projectProvider);
  final statesProvider = ref.watch(ProviderList.statesProvider);
  return CustomAppBar(
    elevation: false,
    onPressed: () {
      Navigator.pop(context);
    },
    text: projectProvider.currentProject['name'],
    actions: [
      (projectProvider.currentProject['archive_in'] > 0 &&
              (projectProvider.role == Role.admin ||
                  projectProvider.role == Role.member) &&
              (statesProvider.statesState == StateEnum.success))
          ? IconButton(
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (ctx) => const ArchivedIssues(),
                //   ),
                // );
              },
              icon: Icon(
                Icons.archive_outlined,
                color: themeProvider.themeManager.placeholderTextColor,
              ))
          : Container(),
      (statesProvider.statesState == StateEnum.success)
          ? IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingScreen(),
                  ),
                ).then((value) {
                  settingsOntap();
                });
              },
              icon: statesProvider.statesState == StateEnum.restricted
                  ? Container()
                  : Icon(
                      Icons.settings_outlined,
                      color: themeProvider.themeManager.placeholderTextColor,
                    ),
            )
          : Container(),
    ],
  );
}
