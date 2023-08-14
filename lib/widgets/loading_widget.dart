import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import '../utils/enums.dart';
import 'custom_text.dart';

class LoadingWidget extends ConsumerStatefulWidget {
  final Widget widgetClass;
  final bool loading;
  final bool allowBorderRadius;
  const LoadingWidget(
      {required this.widgetClass,
      required this.loading,
      this.allowBorderRadius = false,
      super.key});

  @override
  ConsumerState<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends ConsumerState<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Stack(
      children: [
        widget.loading ? const SizedBox() : widget.widgetClass,
        widget.loading
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: widget.allowBorderRadius
                      ? BorderRadius.circular(30)
                      : BorderRadius.zero,
                  color: themeProvider.theme == THEME.dark ||
                          themeProvider.theme == THEME.darkHighContrast
                      ? Colors.black.withOpacity(0.1)
                      : Colors.white.withOpacity(0.1),
                ),
                height: height,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: LoadingIndicator(
                          indicatorType: Indicator.lineSpinFadeLoader,
                          colors: themeProvider.theme == THEME.dark ||
                                  themeProvider.theme == THEME.darkHighContrast
                              ? [Colors.white]
                              : themeProvider.theme == THEME.custom
                                  ? [
                                      themeProvider.themeManager
                                          .secondaryBackgroundDefaultColor
                                    ]
                                  : [Colors.black],
                          strokeWidth: 1.0,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Text(
                      //   'processing...',
                      //   style: TextStylingWidget.smallText,
                      // )
                      CustomText(
                        'Loading...',
                        type: FontStyle.Medium,
                        fontWeight: FontWeightt.Medium,
                        color: themeProvider.themeManager.secondaryTextColor,
                      ),
                    ],
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
