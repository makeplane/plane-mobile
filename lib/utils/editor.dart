// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/config/config_variables.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/project/issues/issue_detail.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'dart:developer';

class EDITOR extends ConsumerStatefulWidget {
  const EDITOR(
      {required this.url,
      required this.title,
      this.fromCreateIssue = false,
      this.controller,
      this.from,
      super.key});
  final InAppWebViewController? controller;
  final String url;
  final String title;
  final bool fromCreateIssue;
  final PreviousScreen? from;
  @override
  ConsumerState<EDITOR> createState() => _EDITORState();
}

class _EDITORState extends ConsumerState<EDITOR> {
  bool isLoading = true;
  late InAppWebViewController controller;
  Uri baseWebUrl = Uri.parse(Config.webUrl!);
  final cookieManager = CookieManager.instance();

  @override
  void initState() {
    if (!widget.fromCreateIssue) {
      ref.read(ProviderList.issueProvider).initCookies();
    }
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.reload();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final issueProvider = ref.watch(ProviderList.issueProvider);

    return Scaffold(
      appBar: CustomAppBar(
        text: widget.title,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SizedBox(
        // height: 500,
        child: issueProvider.cookiesState == DataState.loading
            ? Container(
                alignment: Alignment.center,
                color: themeProvider.themeManager.primaryBackgroundDefaultColor,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: LoadingIndicator(
                    indicatorType: Indicator.lineSpinFadeLoader,
                    colors: [themeProvider.themeManager.primaryTextColor],
                    strokeWidth: 1.0,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              )
            : Stack(
                children: [
                  InAppWebView(
                    gestureRecognizers: {
                      Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer(),
                      ),
                    },
                    contextMenu: ContextMenu(
                      menuItems: [],
                      options: ContextMenuOptions(
                        hideDefaultSystemContextMenuItems: true,
                      ),
                    ),
                    onLoadStart: (controller, url) => setState(() {
                      isLoading = true;
                    }),
                    onLoadStop: (controller, url) => setState(() {
                      isLoading = false;
                    }),
                    onConsoleMessage: (controller, msg) async {
                      log(msg.message);
                      if (msg.message.startsWith("submitted")) {
                        final Map data = json.decode(msg.message.substring(10));
                        final String descriptionHtml = data['data_html'];

                        // issuesProvider.createIssuedata['description_html'] =
                        //     descriptionHtml;
                        log(descriptionHtml);
                        issueProvider.setCookies(
                            key: 'data_html', value: descriptionHtml);
                        Navigator.pop(context);
                      } else {
                        issueProvider.handleIssueDetailRedirection(
                            context: context,
                            msg: msg,
                            previousScreen: widget.from!);
                      }
                    },
                    onWebViewCreated: (controller) =>
                        this.controller = controller,
                    pullToRefreshController: PullToRefreshController(
                      options: PullToRefreshOptions(
                        color: themeProvider.themeManager.primaryTextColor,
                      ),
                      onRefresh: () async {
                        controller.reload();
                      },
                    ),
                    initialUrlRequest: URLRequest(
                      url: Uri.parse(widget.url),
                    ),
                  ),
                  isLoading
                      ? Container(
                          alignment: Alignment.center,
                          color: themeProvider
                              .themeManager.primaryBackgroundDefaultColor,
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: LoadingIndicator(
                              indicatorType: Indicator.lineSpinFadeLoader,
                              colors: [
                                themeProvider.themeManager.primaryTextColor
                              ],
                              strokeWidth: 1.0,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
      ),
    );
  }
}
