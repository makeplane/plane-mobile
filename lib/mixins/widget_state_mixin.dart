// ignore_for_file: override_on_non_overriding_member, unnecessary_null_comparison

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/utils/theme_manager.dart';
import 'package:plane/widgets/error_state.dart';

import '../provider/provider_list.dart';
import '../utils/enums.dart';

mixin WidgetState<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  LoadingType loadingType = LoadingType.none;
  late ThemeManager themeManager;
  double? _height;
  int _count = 1;

  void setHeight() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var box = context.findRenderObject() as RenderBox;
      _height = box.size.height;
      if (_count > 0) {
        setState(() {
          _count--;
        });
      }
    });
  }

  LoadingType getLoading(WidgetRef ref) {
    return LoadingType.none;
  }

  LoadingType setWidgetState(List<StateEnum> states,
      {LoadingType loadingType = LoadingType.translucent}) {
    for (var state in states) {
      if (state == StateEnum.loading) {
        return loadingType;
      } else if (state == StateEnum.error) {
        return LoadingType.error;
      }
    }
    return LoadingType.none;
  }

  @override
  Widget build(BuildContext context) {
    themeManager = ref.read(ProviderList.themeProvider).themeManager;
    loadingType = getLoading(ref);
    setHeight();
    return loadingType == LoadingType.error
        ? errorState(context: context)
        : loadingType == LoadingType.opaque
            ? Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: LoadingIndicator(
                      indicatorType: Indicator.lineSpinFadeLoader,
                      colors: [themeManager.primaryTextColor],
                      strokeWidth: 1.0,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              )
            : Stack(children: [
                render(context),
                loadingType == LoadingType.translucent ||
                        loadingType == LoadingType.wrap
                    ? Container(
                        height:
                            loadingType == LoadingType.wrap ? _height : null,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: themeManager.primaryBackgroundDefaultColor.withOpacity(0.3),
                        ),
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: LoadingIndicator(
                            indicatorType: Indicator.lineSpinFadeLoader,
                            colors: [themeManager.primaryTextColor],
                            strokeWidth: 1.0,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ]);
  }

  Widget render(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text("BASE WIDGET MIXIN"),
    );
  }
}
