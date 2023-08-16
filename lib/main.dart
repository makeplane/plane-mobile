import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/screens/on_boarding/on_boarding_screen.dart';
import 'package:plane_startup/services/connection_service.dart';

import 'package:plane_startup/services/shared_preference_service.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:plane_startup/provider/provider_list.dart';

import 'package:plane_startup/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'config/const.dart';
import 'utils/enums.dart';

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
  var pref = await SharedPreferences.getInstance();
  // SharedPrefrenceServices.sharedPreferences!.clear();
  // Const.appBearerToken = null;
  ConnectionService().checkConnectivity();
  prefs = pref;
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
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

        workspaceProv.getWorkspaces().then((value) {
          if (workspaceProv.workspaces.isEmpty) {
            return;
          }
          workspaceProv.getWorkspaceMembers();
          // log(prov.userProfile.last_workspace_id.toString());
          dashProv.getDashboard();
          projectProv.getProjects(
              slug: workspaceProv.selectedWorkspace!.workspaceSlug);

          ref.read(ProviderList.myIssuesProvider).getLabels();

          ref
              .read(ProviderList.myIssuesProvider)
              .getMyIssuesView()
              .then((value) {
            ref.read(ProviderList.myIssuesProvider).filterIssues();
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
    // themeProvider.getTheme();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
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
          backgroundColor: themeProvider.themeManager.primaryBackgroundDefaultColor,
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
      home:
          Const.appBearerToken == null ? const OnBoardingScreen() : const App(),
    );
  }
}
