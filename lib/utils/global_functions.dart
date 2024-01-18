import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/config_variables.dart';
import 'package:plane/main.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void sentryService() {
  if (Config.sentryDsn != '' && Config.sentryDsn != null) {
    SentryFlutter.init(
      (options) {
        options.dsn = Config.sentryDsn;
      },
      appRunner: () => runApp(const ProviderScope(child: MyApp())),
    );
  } else {
    runApp(const ProviderScope(child: MyApp()));
  }
}

void postHogService(
    {required String eventName,
    required Map<String, dynamic> properties,
    required String userID,
    required String userEmail}) {
  if (Config.posthogApiKey != null && Config.posthogApiKey != '') {
    properties.addAll(
      {
        'USER_ID': userID,
        'USER_EMAIL': userEmail,
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
