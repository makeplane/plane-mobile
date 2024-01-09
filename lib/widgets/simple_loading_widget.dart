import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/utils/constants.dart';

class SimpleLoadingWidget extends ConsumerStatefulWidget {
  const SimpleLoadingWidget(
      {super.key, required this.isLoading, required this.child});

  final Widget child;
  final bool isLoading;

  @override
  ConsumerState<SimpleLoadingWidget> createState() =>
      _SimpleLoadingWidgetState();
}

class _SimpleLoadingWidgetState extends ConsumerState<SimpleLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: Center(
              child: CircularProgressIndicator(
                color: greyColor,
                strokeWidth: 2,
              ),
            ),
          )
        : widget.child;
  }
}
