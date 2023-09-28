import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/plane_keys.dart';
import 'package:plane/provider/dashboard_provider.dart';
import 'package:plane/provider/notification_provider.dart';
import 'package:plane/provider/profile_provider.dart';
import 'package:plane/provider/projects_provider.dart';
import 'package:plane/provider/whats_new_provider.dart';
import 'package:plane/provider/workspace_provider.dart';
import 'package:plane/screens/on_boarding/on_boarding_screen.dart';
import 'package:plane/services/shared_preference_service.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/global_functions.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:upgrader/upgrader.dart';
import 'app.dart';
import 'config/const.dart';
import 'provider/theme_provider.dart';
import 'utils/enums.dart';
// ignore: depend_on_referenced_packages
import 'package:stack_trace/stack_trace.dart' as stack_trace;

import 'utils/app_theme.dart';

late String selectedTheme;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    final ThemeProvider themeProv = ref.read(ProviderList.themeProvider);
    if (Const.accessToken != null) {
      final ProfileProvider profileProvider =
          ref.read(ProviderList.profileProvider);
      final WorkspaceProvider workspaceProv =
          ref.read(ProviderList.workspaceProvider);
      final ProjectsProvider projectProv =
          ref.read(ProviderList.projectProvider);
      final WhatsNewNotifier whatsNewProv =
          ref.read(ProviderList.whatsNewProvider.notifier);
      final DashBoardProvider dashProv =
          ref.read(ProviderList.dashboardProvider);
      final NotificationProvider notificationProvider =
          ref.read(ProviderList.notificationProvider);

      whatsNewProv.getWhatsNew();
      profileProvider.getProfile().then((value) {
        if (profileProvider.userProfile.isOnboarded == false) return;

        workspaceProv.getWorkspaces().then((value) async {
          if (workspaceProv.workspaces.isEmpty) {
            return;
          }
          var theme = profileProvider.userProfile.theme;

          if (profileProvider.userProfile.theme != null) {
            if (profileProvider.userProfile.theme!['theme'] ==
                PlaneKeys.DARK_THEME) {
              theme!['theme'] = fromTHEME(theme: THEME.dark);
              themeProv.changeTheme(data: {'theme': theme}, context: null);
            } else if (profileProvider.userProfile.theme!['theme'] ==
                PlaneKeys.LIGHT_THEME) {
              theme!['theme'] = fromTHEME(theme: THEME.light);
              themeProv.changeTheme(data: {'theme': theme}, context: null);
            } else if (profileProvider.userProfile.theme!['theme'] ==
                PlaneKeys.SYSTEM_THEME) {
              theme!['theme'] = fromTHEME(theme: THEME.systemPreferences);
              themeProv.changeTheme(data: {'theme': theme}, context: null);
            } else if (profileProvider.userProfile.theme!['theme'] ==
                PlaneKeys.DARK_CONTRAST_THEME) {
              theme!['theme'] = fromTHEME(theme: THEME.darkHighContrast);
              themeProv.changeTheme(data: {'theme': theme}, context: null);
            } else if (profileProvider.userProfile.theme!['theme'] ==
                PlaneKeys.LIGHT_CONTRAST_THEME) {
              theme!['theme'] = fromTHEME(theme: THEME.lightHighContrast);
              themeProv.changeTheme(data: {'theme': theme}, context: null);
            } else if (profileProvider.userProfile.theme!['theme'] ==
                PlaneKeys.CUSTOM_THEME) {
              theme!['theme'] = fromTHEME(theme: THEME.custom);
              themeProv.changeTheme(data: {'theme': theme}, context: null);
            } else {
              themeProv.changeTheme(data: {
                'theme': {
                  'primary': profileProvider.userProfile.theme!['primary'],
                  'background':
                      profileProvider.userProfile.theme!['background'],
                  'text': profileProvider.userProfile.theme!['text'],
                  'sidebarText':
                      profileProvider.userProfile.theme!['sidebarText'],
                  'sidebarBackground':
                      profileProvider.userProfile.theme!['sidebarBackground'],
                  'theme': 'custom',
                }
              }, context: null);
            }
          }

          workspaceProv.getWorkspaceMembers();
          dashProv.getDashboard();
          projectProv.getProjects(
              slug: workspaceProv.selectedWorkspace.workspaceSlug);

          ref.read(ProviderList.myIssuesProvider).getLabels();

          await ref
              .read(ProviderList.myIssuesProvider)
              .getMyIssuesView()
              .then((value) {
            ref
                .read(ProviderList.myIssuesProvider)
                .filterIssues(assigned: true);
          });

          notificationProvider.getUnreadCount();

          notificationProvider.getNotifications(type: 'assigned');
          notificationProvider.getNotifications(type: 'created');
          notificationProvider.getNotifications(type: 'watching');
          notificationProvider.getNotifications(
              type: 'unread', getUnread: true);
          notificationProvider.getNotifications(
              type: 'archived', getArchived: true);
          notificationProvider.getNotifications(
              type: 'snoozed', getSnoozed: true);
        });
      });
    }

    themeProv.getTheme();
    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    var themeProvider = ref.read(ProviderList.themeProvider);
    var profileProvider = ref.read(ProviderList.profileProvider);

    if (profileProvider.userProfile.theme != null &&
        profileProvider.userProfile.theme!['theme'] == PlaneKeys.SYSTEM_THEME) {
      var theme = profileProvider.userProfile.theme;

      theme!['theme'] = fromTHEME(theme: THEME.systemPreferences);
      log(theme.toString());
      themeProvider.changeTheme(data: {'theme': theme}, context: null);
    }
    super.didChangePlatformBrightness();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    AppTheme.setUiOverlayStyle(
        theme: themeProvider.theme, themeManager: themeProvider.themeManager);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: PlaneKeys.APP_NAME,
      theme: AppTheme.getAppThemeData(themeProvider.themeManager),
      themeMode:
          themeProvider.isDarkThemeEnabled ? ThemeMode.dark : ThemeMode.light,
      navigatorKey: Const.globalKey,
      navigatorObservers: checkPostHog() ? [PosthogObserver()] : [],
      home: UpgradeAlert(
        child:
            Const.accessToken == null ? const OnBoardingScreen() : const App(),
      ),
    );
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
