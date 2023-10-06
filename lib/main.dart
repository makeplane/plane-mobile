import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/plane_keys.dart';
import 'package:plane/screens/on_boarding/on_boarding_screen.dart';
import 'package:plane/services/shared_preference_service.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/startup/dependency_resolver.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/global_functions.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:upgrader/upgrader.dart';
import 'app.dart';
import 'config/const.dart';
import 'utils/enums.dart';
// ignore: depend_on_referenced_packages
import 'package:stack_trace/stack_trace.dart' as stack_trace;

import 'utils/app_theme.dart';

late String selectedTheme;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 300));
  await dotenv.load(fileName: '.env');

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  await SharedPrefrenceServices.init();
  SharedPrefrenceServices.getTokens();
  SharedPrefrenceServices.getUserID();
  sentryService();
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    DependencyResolver.resolve(ref: ref);
    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    final themeProvider = ref.read(ProviderList.themeProvider);
    final profileProvider = ref.read(ProviderList.profileProvider);

    if (profileProvider.userProfile.theme != null &&
        profileProvider.userProfile.theme!['theme'] == PlaneKeys.SYSTEM_THEME) {
      final theme = profileProvider.userProfile.theme;

      theme!['theme'] = fromTHEME(theme: THEME.systemPreferences);
      log(theme.toString());
      themeProvider.changeTheme(data: {'theme': theme}, context: ref.context);
    }
    super.didChangePlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    AppTheme.setUiOverlayStyle(
        theme: themeProvider.theme, themeManager: themeProvider.themeManager);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: PlaneKeys.APP_NAME,
        theme: AppTheme.getThemeData(themeProvider.themeManager),
        themeMode: AppTheme.getThemeMode(themeProvider.theme),
        navigatorKey: Const.globalKey,
        navigatorObservers: checkPostHog() ? [PosthogObserver()] : [],
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: Overlay(
            initialEntries: [
              OverlayEntry(builder: (context) {
                return UpgradeAlert(
                  child: Const.accessToken == null
                      ? const OnBoardingScreen()
                      : const App(),
                );
              })
            ],
          ),
        ));
  }

  bool checkPostHog() {
    bool enablePostHog = false;
    if (dotenv.env['ENABLE_TRACK_EVENTS'] != null &&
        dotenv.env['ENABLE_TRACK_EVENTS'] == '1' &&
        dotenv.env['POSTHOG_API'] != null &&
        dotenv.env['POSTHOG_API'] != '') {
      enablePostHog = true;
    } else {
      enablePostHog = false;
    }
    return enablePostHog;
  }
}
