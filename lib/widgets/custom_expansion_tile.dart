import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/provider_list.dart';
import 'custom_text.dart';
import '../utils/enums.dart';

class CustomExpansionTile extends ConsumerStatefulWidget {
  const CustomExpansionTile(
      {super.key,
      this.textColor,
      this.type,
      required this.title,
      required this.child});

  final String title;
  final Widget child;
  final FontStyle? type;
  final Color? textColor;

  @override
  ConsumerState<CustomExpansionTile> createState() =>
      _CustomExpansionTileState();
}

class _CustomExpansionTileState extends ConsumerState<CustomExpansionTile> {
  final double _iconAngleWhenCollapsed = 0;
  final double _iconAngleWhenExpanded = 1.6;
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        child: ExpansionTile(
          onExpansionChanged: (value) {
            setState(() {
              _isExpanded = value;
            });
          },
          expandedAlignment: Alignment.centerLeft,
          tilePadding: const EdgeInsets.all(0),
          // childrenPadding: const EdgeInsets.only(left: 0),

          title: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                transform: Matrix4.rotationZ(_isExpanded
                    ? _iconAngleWhenExpanded
                    : _iconAngleWhenCollapsed),
                transformAlignment: Alignment.center,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: themeProvider.themeManager.tertiaryTextColor,
                ),
              ),
              const SizedBox(width: 10),
              CustomText(
                widget.title,
                type: widget.type ?? FontStyle.H6,
                color: widget.textColor ??
                    themeProvider.themeManager.tertiaryTextColor,
              ),
            ],
          ),
          trailing: const SizedBox.shrink(),
          children: [widget.child, const SizedBox(height: 10)],
        ),
      ),
    );
  }
}
