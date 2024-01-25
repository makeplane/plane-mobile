import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/provider_list.dart';

class GotoPlaneWebNotifierSheet extends ConsumerStatefulWidget {
  const GotoPlaneWebNotifierSheet(
      {super.key,
      this.message =
          'This feature is not currently available on the mobile version. Please use the web version instead.'});
  final String message;

  @override
  ConsumerState<GotoPlaneWebNotifierSheet> createState() =>
      _GotoPlaneWebNotifierSheetState();
}

class _GotoPlaneWebNotifierSheetState
    extends ConsumerState<GotoPlaneWebNotifierSheet> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      //height: 250,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          CustomText(widget.message),
          const SizedBox(height: 50),
          //const Spacer(),
          Button(
              text: 'Open Plane Web',
              ontap: () {
                _launchUrl();
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }

  Future<void> _launchUrl() async {
    const String url = 'https://app.plane.so';
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
