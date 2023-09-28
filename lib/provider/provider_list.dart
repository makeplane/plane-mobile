import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/Authentication/google_sign_in.dart';
import 'package:plane/config/const.dart';
import 'package:plane/provider/activity_provider.dart';
import 'package:plane/provider/auth_provider.dart';
import 'package:plane/provider/bottom_nav_provider.dart';
import 'package:plane/provider/cycles_provider.dart';
import 'package:plane/provider/dashboard_provider.dart';
import 'package:plane/provider/file_upload_provider.dart';
import 'package:plane/provider/global_search_provider.dart';
import 'package:plane/provider/issue_provider.dart';
import 'package:plane/provider/my_issues_provider.dart';
import 'package:plane/provider/page_provider.dart';
import 'package:plane/provider/notification_provider.dart';
import 'package:plane/provider/profile_provider.dart';
import 'package:plane/provider/projects_provider.dart';
import 'package:plane/provider/search_issue_provider.dart';
import 'package:plane/provider/whats_new_provider.dart';
import 'package:plane/provider/workspace_provider.dart';
import 'package:plane/services/shared_preference_service.dart';

import '../repository/dashboard_service.dart';
import '../repository/profile_provider_service.dart';
import '../repository/workspace_service.dart';
import '../services/dio_service.dart';
import 'estimates_provider.dart';
import 'integration_provider.dart';
import 'issues_provider.dart';
import 'member_profile_provider.dart';
import 'modules_provider.dart';
import 'theme_provider.dart';
import 'views_provider.dart';

class ProviderList {
  static final authProvider =
      ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider(ref));
  static var profileProvider = ChangeNotifierProvider<ProfileProvider>(
      (_) => ProfileProvider(profileService: ProfileService(DioConfig())));
  static var workspaceProvider = ChangeNotifierProvider<WorkspaceProvider>(
      (ref) => WorkspaceProvider(
          ref: ref, workspaceService: WorkspaceService(DioConfig())));
  static var themeProvider =
      ChangeNotifierProvider<ThemeProvider>((ref) => ThemeProvider(ref));
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
  static var bottomNavProvider =
      ChangeNotifierProvider<BottomNavProvider>((_) => BottomNavProvider());
  static var cyclesProvider =
      ChangeNotifierProvider<CyclesProvider>((ref) => CyclesProvider(ref));

  static var modulesProvider =
      ChangeNotifierProvider<ModuleProvider>((ref) => ModuleProvider(ref));
  static var estimatesProvider =
      ChangeNotifierProvider<EstimatesProvider>((_) => EstimatesProvider());
  static var myIssuesProvider =
      ChangeNotifierProvider<MyIssuesProvider>((ref) => MyIssuesProvider(ref));
  static var activityProvider =
      ChangeNotifierProvider<ActivityProvider>((_) => ActivityProvider());
  static var dashboardProvider = ChangeNotifierProvider<DashBoardProvider>(
      (ref) => DashBoardProvider(
          ref: ref, dashboardService: DashboardService(DioConfig())));
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
  static var memberProfileProvider =
      StateNotifierProvider<MemberProfileProvider, MemberProfileStateModel>(
          (ref) => MemberProfileProvider(ref));

  static var whatsNewProvider =
      StateNotifierProvider<WhatsNewNotifier, WhatsNew>(
          (ref) => WhatsNewNotifier(WhatsNew(null)));

  static void clear({required WidgetRef ref}) {
    ref.read(issueProvider).clear();
    ref.read(themeProvider).clear();
    ref.read(issuesProvider).clear();
    ref.read(profileProvider).clear();
    ref.read(projectProvider).clear();
    ref.read(searchIssueProvider).clear();

    ref.read(workspaceProvider).clear();
    GoogleSignInApi.logout();
    SharedPrefrenceServices.instance.clear();
    Const.accessToken = null;
    Const.userId = null;
  }
}
