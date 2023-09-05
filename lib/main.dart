import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/screens/on_boarding/on_boarding_screen.dart';

import 'package:plane_startup/services/shared_preference_service.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:plane_startup/provider/provider_list.dart';

import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/global_functions.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'config/const.dart';
import 'utils/enums.dart';
// ignore: depend_on_referenced_packages
import 'package:stack_trace/stack_trace.dart' as stack_trace;

late SharedPreferences prefs;
late String selectedTheme;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
    //status bar icons' color
    statusBarIconBrightness: Brightness.dark,
  ));
  await SharedPrefrenceServices.init();
  Const.appBearerToken =
      SharedPrefrenceServices.sharedPreferences!.getString("token");
  Const.userId =
      SharedPrefrenceServices.sharedPreferences!.getString("user_id");
  var pref = await SharedPreferences.getInstance();
  // SharedPrefrenceServices.sharedPreferences!.clear();
  // Const.appBearerToken = null;
  // ConnectionService().checkConnectivity();
  prefs = pref;
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

    var themeProv = ref.read(ProviderList.themeProvider);
    if (Const.appBearerToken != null) {
      log(Const.appBearerToken.toString());
      var prov = ref.read(ProviderList.profileProvider);
      var workspaceProv = ref.read(ProviderList.workspaceProvider);
      var projectProv = ref.read(ProviderList.projectProvider);

      var dashProv = ref.read(ProviderList.dashboardProvider);

      prov.getProfile().then((value) {
        // log(prov.userProfile.workspace.toString());

        if (prov.userProfile.isOnboarded == false) return;

        workspaceProv.getWorkspaces().then((value) async {
          if (workspaceProv.workspaces.isEmpty) {
            return;
          }
          var theme = prov.userProfile.theme;

          if (prov.userProfile.theme != null) {
            if (prov.userProfile.theme!['theme'] == 'dark') {
              theme!['theme'] = fromTHEME(theme: THEME.dark);
              themeProv.changeTheme(data: {'theme': theme}, context: null);
            } else if (prov.userProfile.theme!['theme'] == 'light') {
              theme!['theme'] = fromTHEME(theme: THEME.light);
              themeProv.changeTheme(data: {'theme': theme}, context: null);
            } else if (prov.userProfile.theme!['theme'] == 'system') {
              theme!['theme'] = fromTHEME(theme: THEME.systemPreferences);
              themeProv.changeTheme(data: {'theme': theme}, context: null);
            } else if (prov.userProfile.theme!['theme'] == 'dark-contrast') {
              theme!['theme'] = fromTHEME(theme: THEME.darkHighContrast);
              themeProv.changeTheme(data: {'theme': theme}, context: null);
            } else if (prov.userProfile.theme!['theme'] == 'light-contrast') {
              theme!['theme'] = fromTHEME(theme: THEME.lightHighContrast);
              themeProv.changeTheme(data: {'theme': theme}, context: null);
            } else {
              theme!['theme'] = fromTHEME(theme: THEME.light);
              themeProv.changeTheme(data: {'theme': theme}, context: null);
            }
          }
          workspaceProv.getWorkspaceMembers();
          // log(prov.userProfile.last_workspace_id.toString());
          dashProv.getDashboard();
          projectProv.getProjects(
              slug: workspaceProv.selectedWorkspace!.workspaceSlug);

          ref.read(ProviderList.myIssuesProvider).getLabels();

          await ref
              .read(ProviderList.myIssuesProvider)
              .getMyIssuesView()
              .then((value) {
            ref
                .read(ProviderList.myIssuesProvider)
                .filterIssues(assigned: true);
          });

          ref.read(ProviderList.notificationProvider).getUnreadCount();

          ref
              .read(ProviderList.notificationProvider)
              .getNotifications(type: 'assigned');
          ref
              .read(ProviderList.notificationProvider)
              .getNotifications(type: 'created');
          ref
              .read(ProviderList.notificationProvider)
              .getNotifications(type: 'watching');
          ref
              .read(ProviderList.notificationProvider)
              .getNotifications(type: 'unread', getUnread: true);
          ref
              .read(ProviderList.notificationProvider)
              .getNotifications(type: 'archived', getArchived: true);
          ref
              .read(ProviderList.notificationProvider)
              .getNotifications(type: 'snoozed', getSnoozed: true);
        });
      });
    }

    themeProv.prefs = prefs;
    themeProv.getTheme();
    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    var themeProvider = ref.read(ProviderList.themeProvider);
    var profileProvider = ref.read(ProviderList.profileProvider);

    if (profileProvider.userProfile.theme != null &&
        profileProvider.userProfile.theme!['theme'] == 'system') {
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
      //status bar icons' color
      statusBarIconBrightness: themeProvider.theme == THEME.dark ||
              themeProvider.theme == THEME.darkHighContrast
          ? Brightness.light
          : Brightness.dark,
    ));

    themeProvider.setUiOverlayStyle(fromTHEME(theme: themeProvider.theme));

    // themeProvider.getTheme();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plane',
      theme: ThemeData(
        // theme the entire app with list of colors

        textTheme: TextTheme(
          titleMedium: TextStyle(
            color: themeProvider.themeManager.primaryTextColor,
          ),
        ),

        // cursor color

        textSelectionTheme: TextSelectionThemeData(
            cursorColor: primaryColor,
            selectionColor: primaryColor.withOpacity(0.2),
            selectionHandleColor: primaryColor),

        primaryColor: themeProvider.themeManager.primaryBackgroundDefaultColor,

        scaffoldBackgroundColor:
            themeProvider.themeManager.primaryBackgroundDefaultColor,
        //bottom sheet theme
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor:
              themeProvider.themeManager.primaryBackgroundDefaultColor,
        ),

        //dialog theme
        dialogTheme: DialogTheme(
          backgroundColor: themeProvider.isDarkThemeEnabled
              ? const Color.fromRGBO(29, 30, 32, 1)
              : Colors.white,
        ),

        //expansion tile trailing icon color
        unselectedWidgetColor:
            themeProvider.isDarkThemeEnabled ? Colors.white : Colors.black,
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return null;
            }
            if (states.contains(MaterialState.selected)) {
              return primaryColor;
            }
            return null;
          }),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return null;
            }
            if (states.contains(MaterialState.selected)) {
              return primaryColor;
            }
            return null;
          }),
        ),

        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return null;
            }
            if (states.contains(MaterialState.selected)) {
              return primaryColor;
            }
            return null;
          }),
          trackColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return null;
            }
            if (states.contains(MaterialState.selected)) {
              return primaryColor;
            }
            return null;
          }),
        ),
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: const MaterialColor(
          //white color
          0xFFFFFFFF,
          <int, Color>{
            50: Color(0xFFFFFFFF),
            100: Color(0xFFFFFFFF),
            200: Color(0xFFFFFFFF),
            300: Color(0xFFFFFFFF),
            400: Color(0xFFFFFFFF),
            500: Color(0xFFFFFFFF),
            600: Color(0xFFFFFFFF),
            700: Color(0xFFFFFFFF),
            800: Color(0xFFFFFFFF),
            900: Color(0xFFFFFFFF),
          },
        )).copyWith(
          background: themeProvider.themeManager.primaryBackgroundDefaultColor,
        ),

        //expansion tile expansion icon color when expanded not accent color
      ),
      themeMode:
          themeProvider.isDarkThemeEnabled ? ThemeMode.dark : ThemeMode.light,
      navigatorKey: Const.globalKey,
      navigatorObservers: checkPostHog() ? [PosthogObserver()] : [],
      home:
          Const.appBearerToken == null ? const OnBoardingScreen() : const App(),
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
