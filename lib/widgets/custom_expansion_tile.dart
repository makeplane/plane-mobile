import 'package:flutter/material.dart';
import 'custom_text.dart';
import '../utils/enums.dart';

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile(
      {super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  final double _iconAngleWhenCollapsed = 0;
  final double _iconAngleWhenExpanded = 1.6;
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
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
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Color.fromRGBO(65, 65, 65, 1),
                ),
              ),
              const SizedBox(width: 10),
              CustomText(
                widget.title,
                type: FontStyle.Small,
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
