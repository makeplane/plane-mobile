import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/main.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void sentryService() {
  if (dotenv.env['SENTRY_DSN'] != '' && dotenv.env['SENTRY_DSN'] != null) {
    SentryFlutter.init(
      (options) {
        options.dsn = dotenv.env['SENTRY_DSN'];
      },
      appRunner: () => runApp(const ProviderScope(child: MyApp())),
    );
  } else {
    runApp(ProviderScope(
        child: Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: [
          OverlayEntry(builder: (context) {
            return const MyApp();
          })
        ],
      ),
    )));
  }
}

void postHogService(
    {required String eventName,
    required Map<String, dynamic> properties,
    required WidgetRef ref}) {
  if (dotenv.env['POSTHOG_API'] != null &&
      dotenv.env['POSTHOG_API'] != '' &&
      dotenv.env['ENABLE_TRACK_EVENTS'] == '1' &&
      dotenv.env['ENABLE_TRACK_EVENTS'] != null) {
    final profileProvider = ref.watch(ProviderList.profileProvider);
    properties.addAll(
      {
        'USER_ID': profileProvider.userProfile.id,
        'USER_EMAIL': profileProvider.userProfile.email,
      },
    );
    try {
      Posthog().capture(
        eventName: eventName,
        properties: properties,
      );
    } catch (e) {
      sentryService();
    }
  } else {
    return;
  }
}
