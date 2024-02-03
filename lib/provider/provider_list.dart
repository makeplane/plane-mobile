import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/authentication/google_sign_in.dart';
import 'package:plane/config/const.dart';
import 'package:plane/provider/activity_provider.dart';
import 'package:plane/provider/auth_provider.dart';
import 'package:plane/provider/bottom_nav_provider.dart';
import 'package:plane/provider/config_provider.dart';
import 'package:plane/provider/cycles_provider.dart';
import 'package:plane/provider/dashboard_provider.dart';
import 'package:plane/provider/file_upload_provider.dart';
import 'package:plane/provider/global_search_provider.dart';
import 'package:plane/provider/issue_provider.dart';
import 'package:plane/provider/issues/cycle-issues/cycle_issues_notifier.dart';
import 'package:plane/provider/issues/cycle-issues/cycle_issues_state.dart';
import 'package:plane/provider/issues/project-issues/project_issues_state.dart';
import 'package:plane/provider/issues/project-issues/project_issues_notifier.dart';
import 'package:plane/provider/labels/labels_notifier.dart';
import 'package:plane/provider/my_issues_provider.dart';
import 'package:plane/provider/page_provider.dart';
import 'package:plane/provider/notification_provider.dart';
import 'package:plane/provider/profile_provider.dart';
import 'package:plane/provider/projects_provider.dart';
import 'package:plane/provider/search_issue_provider.dart';
import 'package:plane/provider/states/project_state_notifier.dart';
import 'package:plane/provider/states/project_states_state.dart';
import 'package:plane/provider/whats_new_provider.dart';
import 'package:plane/provider/workspace_provider.dart';
import 'package:plane/repository/issues/cycle_issues_repository.dart';
import 'package:plane/repository/issues/project_issues.repository.dart';
import 'package:plane/repository/project_state_service.dart';
import 'package:plane/repository/labels.service.dart';
import 'package:plane/services/shared_preference_service.dart';
import '../repository/dashboard_service.dart';
import '../repository/profile_provider_service.dart';
import '../repository/workspace_service.dart';
import '../services/dio_service.dart';
import 'estimates_provider.dart';
import 'integration_provider.dart';
import 'labels/labels_state.dart';
import 'member_profile_provider.dart';
import 'modules_provider.dart';
import 'theme_provider.dart';
import 'views_provider.dart';

class ProviderList {
  // Auth Provider
  static final authProvider =
      ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider(ref));
  // Profile Provider
  static ChangeNotifierProvider<ProfileProvider> profileProvider =
      ChangeNotifierProvider<ProfileProvider>(
          (_) => ProfileProvider(profileService: ProfileService(DioConfig())));
  // Workspace Provider
  static ChangeNotifierProvider<WorkspaceProvider> workspaceProvider =
      ChangeNotifierProvider<WorkspaceProvider>((ref) => WorkspaceProvider(
          ref: ref, workspaceService: WorkspaceService(DioConfig())));
  // Theme Provider
  static ChangeNotifierProvider<ThemeProvider> themeProvider =
      ChangeNotifierProvider<ThemeProvider>((ref) => ThemeProvider(ref));
  // Project Provider
  static ChangeNotifierProvider<ProjectsProvider> projectProvider =
      ChangeNotifierProvider<ProjectsProvider>((ref) => ProjectsProvider(ref));
  // File Upload Provider
  static ChangeNotifierProvider<FileUploadProvider> fileUploadProvider =
      ChangeNotifierProvider<FileUploadProvider>(
          (ref) => FileUploadProvider(ref));
  // Issue Provider
  static ChangeNotifierProvider<IssueProvider> issueProvider =
      ChangeNotifierProvider<IssueProvider>((ref) => IssueProvider(ref));
  // Search Issue Provider
  static ChangeNotifierProvider<SearchIssueProvider> searchIssueProvider =
      ChangeNotifierProvider<SearchIssueProvider>((_) => SearchIssueProvider());
  // Bottom Nav Provider
  static ChangeNotifierProvider<BottomNavProvider> bottomNavProvider =
      ChangeNotifierProvider<BottomNavProvider>((_) => BottomNavProvider());
  // Cycles Provider
  static ChangeNotifierProvider<CyclesProvider> cyclesProvider =
      ChangeNotifierProvider<CyclesProvider>((ref) => CyclesProvider(ref));
  // Modules Provider
  static ChangeNotifierProvider<ModuleProvider> modulesProvider =
      ChangeNotifierProvider<ModuleProvider>((ref) => ModuleProvider(ref));
  // Estimates Provider
  static ChangeNotifierProvider<EstimatesProvider> estimatesProvider =
      ChangeNotifierProvider<EstimatesProvider>((_) => EstimatesProvider());
  // My Issues Provider
  static ChangeNotifierProvider<MyIssuesProvider> myIssuesProvider =
      ChangeNotifierProvider<MyIssuesProvider>((ref) => MyIssuesProvider(ref));
  // Activity Provider
  static ChangeNotifierProvider<ActivityProvider> activityProvider =
      ChangeNotifierProvider<ActivityProvider>((_) => ActivityProvider());
  // Dashboard Provider
  static ChangeNotifierProvider<DashBoardProvider> dashboardProvider =
      ChangeNotifierProvider<DashBoardProvider>((ref) => DashBoardProvider(
          ref: ref, dashboardService: DashboardService(DioConfig())));
  // Integration Provider
  static ChangeNotifierProvider<IntegrationProvider> integrationProvider =
      ChangeNotifierProvider<IntegrationProvider>(
          (ref) => IntegrationProvider(ref));
  // Views Provider
  static StateNotifierProvider<ViewsNotifier, ViewsModel> viewsProvider =
      StateNotifierProvider<ViewsNotifier, ViewsModel>(
          (ref) => ViewsNotifier(ref));
  // Global Search Provider
  static StateNotifierProvider<GlobalSearchProvider, SearchModal>
      globalSearchProvider =
      StateNotifierProvider<GlobalSearchProvider, SearchModal>(
          (ref) => GlobalSearchProvider(ref));
  // Page Provider
  static ChangeNotifierProvider<PageProvider> pageProvider =
      ChangeNotifierProvider<PageProvider>((ref) => PageProvider());
  // Notification Provider
  static ChangeNotifierProvider<NotificationProvider> notificationProvider =
      ChangeNotifierProvider<NotificationProvider>(
          (ref) => NotificationProvider(ref));
  // Member Profile Provider
  static StateNotifierProvider<MemberProfileProvider, MemberProfileStateModel>
      memberProfileProvider =
      StateNotifierProvider<MemberProfileProvider, MemberProfileStateModel>(
          (ref) => MemberProfileProvider(ref));
  // Whats New Provider
  static StateNotifierProvider<WhatsNewNotifier, WhatsNew> whatsNewProvider =
      StateNotifierProvider<WhatsNewNotifier, WhatsNew>(
          (ref) => WhatsNewNotifier(WhatsNew(null)));
  // Config Provider
  static StateNotifierProvider<ConfigProvider, ConfigModel> configProvider =
      StateNotifierProvider<ConfigProvider, ConfigModel>(
          (ref) => ConfigProvider(ref));

  static StateNotifierProvider<StatesProvider, ProjectStatesState> statesProvider =
      StateNotifierProvider<StatesProvider, ProjectStatesState>(
          (ref) => StatesProvider(ref, StatesService()));
  // Label Provider
  static StateNotifierProvider<LabelNotifier, LabelState> labelProvider =
      StateNotifierProvider<LabelNotifier, LabelState>(
          (ref) => LabelNotifier(ref, LabelsService()));

  static StateNotifierProvider<ProjectIssuesNotifier, ProjectIssuesState>
      projectIssuesProvider =
      StateNotifierProvider<ProjectIssuesNotifier, ProjectIssuesState>(
          (ref) => ProjectIssuesNotifier(ref, ProjectIssuesRepository()));
  static StateNotifierProvider<CycleIssuesNotifier, CycleIssuesState>
      cycleIssuesProvider =
      StateNotifierProvider<CycleIssuesNotifier, CycleIssuesState>(
          (ref) => CycleIssuesNotifier(ref, CycleIssuesRepository()));

  static void clear({required WidgetRef ref}) {
    ref.read(issueProvider).clear();
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
