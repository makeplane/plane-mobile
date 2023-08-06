//craete custom appbar class named CustomAppBar
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';

import 'custom_text.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final Function onPressed;
  final String text;
  final List<Widget>? actions;
  final bool leading;
  final bool elevation;
  final bool centerTitle;
  final IconData icon;
  final FontStyle fontType;
  const CustomAppBar({
    super.key,
    required this.onPressed,
    required this.text,
    this.leading = true,
    this.elevation = true,
    this.centerTitle = true,
    this.icon = Icons.close,
    this.fontType = FontStyle.paragraphLargeSemiBold,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return AppBar(
      elevation: elevation ? 1 : 0,
      shadowColor:
          themeProvider.isDarkThemeEnabled ? darkThemeBorder : strokeColor,
      leading: leading
          ? IconButton(
              onPressed: () {
                onPressed();
              },
              icon: Icon(
                icon,
                color: themeProvider.isDarkThemeEnabled
                    ? darkPrimaryTextColor
                    : lightPrimaryTextColor,
              ),
            )
          : Container(),
      leadingWidth: leading ? 60 : 0,
      actions: actions,
      centerTitle: centerTitle ? true : false,
      backgroundColor: themeProvider.isDarkThemeEnabled
          ? darkPrimaryBackgroundDefaultColor
          : lightPrimaryBackgroundDefaultColor,
      title: CustomText(
        text,
        type: fontType,
        fontWeight: FontWeight.w600,
        color: themeProvider.isDarkThemeEnabled
            ? darkPrimaryTextColor
            : lightPrimaryTextColor,
        maxLines: 1,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
