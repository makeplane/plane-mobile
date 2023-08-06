import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/Authentication/google_sign_in.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/provider/activity_provider.dart';
import 'package:plane_startup/provider/auth_provider.dart';
import 'package:plane_startup/provider/cycles_provider.dart';
import 'package:plane_startup/provider/dashboard_provider.dart';
import 'package:plane_startup/provider/file_upload_provider.dart';
import 'package:plane_startup/provider/global_search_provider.dart';
import 'package:plane_startup/provider/issue_provider.dart';
import 'package:plane_startup/provider/my_issues_provider.dart';
import 'package:plane_startup/provider/page_provider.dart';
import 'package:plane_startup/provider/notification_provider.dart';
import 'package:plane_startup/provider/profile_provider.dart';
import 'package:plane_startup/provider/projects_provider.dart';
import 'package:plane_startup/provider/search_issue_provider.dart';
import 'package:plane_startup/provider/workspace_provider.dart';
import 'package:plane_startup/services/shared_preference_service.dart';

import 'estimates_provider.dart';
import 'integration_provider.dart';
import 'issues_provider.dart';
import 'modules_provider.dart';
import 'theme_provider.dart';
import 'views_provider.dart';

class ProviderList {
  static final authProvider =
      ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider(ref));
  static final profileProvider =
      ChangeNotifierProvider<ProfileProvider>((_) => ProfileProvider());
  static var workspaceProvider = ChangeNotifierProvider<WorkspaceProvider>(
      (ref) => WorkspaceProvider(ref));
  static var themeProvider =
      ChangeNotifierProvider<ThemeProvider>((_) => ThemeProvider());
  static var projectProvider =
      ChangeNotifierProvider<ProjectsProvider>((ref) => ProjectsProvider(ref));
  static var fileUploadProvider = ChangeNotifierProvider<FileUploadProvider>(
      (ref) => FileUploadProvider(ref));
  static var issuesProvider =
      ChangeNotifierProvider<IssuesProvider>((ref) => IssuesProvider(ref));
  static var issueProvider =
      ChangeNotifierProvider<IssueProvider>((ref) => IssueProvider(ref));
  static var searchIssueProvider =
      ChangeNotifierProvider<SearchIssueProvider>((_) => SearchIssueProvider());
  static var cyclesProvider =
      ChangeNotifierProvider<CyclesProvider>((ref) => CyclesProvider(ref));

  static var modulesProvider =
      ChangeNotifierProvider<ModuleProvider>((ref) => ModuleProvider(ref));
  static var estimatesProvider =
      ChangeNotifierProvider<EstimatesProvider>((_) => EstimatesProvider());
  static var myIssuesProvider =
      ChangeNotifierProvider<MyIssuesProvider>((_) => MyIssuesProvider());
  static var activityProvider =
      ChangeNotifierProvider<ActivityProvider>((_) => ActivityProvider());
  static var dashboardProvider = ChangeNotifierProvider<DashBoardProvider>(
      (ref) => DashBoardProvider(ref));
  static var integrationProvider = ChangeNotifierProvider<IntegrationProvider>(
      (ref) => IntegrationProvider(ref));
  static var viewsProvider = StateNotifierProvider<ViewsNotifier, ViewsModel>(
      (ref) => ViewsNotifier(ref));
  static var globalSearchProvider =
      StateNotifierProvider<GlobalSearchProvider, SearchModal>(
          (ref) => GlobalSearchProvider(ref));
  static var pageProvider =
      ChangeNotifierProvider<PageProvider>((ref) => PageProvider());

  static var notificationProvider =
      ChangeNotifierProvider<NotificationProvider>(
          (ref) => NotificationProvider(ref));

  static void clear({required WidgetRef ref}) {
    ref.read(issueProvider).clear();
    ref.read(issuesProvider).clear();
    ref.read(profileProvider).clear();
    ref.read(projectProvider).clear();
    ref.read(searchIssueProvider).clear();
    ref.read(workspaceProvider).clear();
    // ref.read(themeProvider).clear();
    GoogleSignInApi.logout();
    SharedPrefrenceServices.sharedPreferences!.clear();
    Const.appBearerToken = null;
    Const.isLoggedIn = false;
    Const.signUp = false;
  }
}
