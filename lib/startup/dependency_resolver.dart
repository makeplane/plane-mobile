import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/const.dart';
import 'package:plane/provider/projects_provider.dart';
import 'package:plane/provider/workspace_provider.dart';

import '../config/plane_keys.dart';
import '../provider/my_issues_provider.dart';
import '../provider/notification_provider.dart';
import '../provider/profile_provider.dart';
import '../provider/provider_list.dart';
import '../provider/theme_provider.dart';
import '../provider/whats_new_provider.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';

class DependencyResolver {
  static Future<void> resolve({required WidgetRef ref}) async {
    if (Const.accessToken == null) {
      return;
    }
    final ProfileProvider profileProvider =
        ref.read(ProviderList.profileProvider);
    final WorkspaceProvider workspaceProvider =
        ref.read(ProviderList.workspaceProvider);

    await _resolveUserProfile(ref);
    if (profileProvider.userProfile.isOnboarded == false) {
      return;
    }
    await _resolveWorkspaces(ref);
    if (workspaceProvider.workspaces.isEmpty) {
      return;
    }
    _resolveTheme(ref);
    _resolveDashBoard(ref);
    _resolveProjects(ref);
    _resolveMyIssues(ref);
    _resolveNotifications(ref);
    _resolveWhatsNew(ref);
  }

  static Future<void> _resolveDashBoard(WidgetRef ref) async {
    ref.read(ProviderList.dashboardProvider).getDashboard();
  }

  static Future<void> _resolveUserProfile(WidgetRef ref) async {
    final ProfileProvider profileProvider =
        ref.read(ProviderList.profileProvider);
    await profileProvider.getProfile();
  }

  static Future<void> _resolveWorkspaces(WidgetRef ref) async {
    final WorkspaceProvider workspaceProvider =
        ref.read(ProviderList.workspaceProvider);
    await workspaceProvider.getWorkspaces();
    if (workspaceProvider.workspaces.isEmpty) {
      return;
    }
    workspaceProvider.getWorkspaceMembers();
  }

  static void _resolveTheme(WidgetRef ref) {
    final ThemeProvider themeProvider = ref.read(ProviderList.themeProvider);
    final ProfileProvider profileProvider =
        ref.read(ProviderList.profileProvider);
    Map<dynamic, dynamic>? theme = profileProvider.userProfile.theme;
    if (profileProvider.userProfile.theme != null) {
      if (profileProvider.userProfile.theme!['theme'] == PlaneKeys.DARK_THEME) {
        theme!['theme'] = fromTHEME(theme: THEME.dark);
        themeProvider.changeTheme(data: {'theme': theme}, context: null);
      } else if (profileProvider.userProfile.theme!['theme'] ==
          PlaneKeys.LIGHT_THEME) {
        theme!['theme'] = fromTHEME(theme: THEME.light);
        themeProvider.changeTheme(data: {'theme': theme}, context: null);
      } else if (profileProvider.userProfile.theme!['theme'] ==
          PlaneKeys.SYSTEM_THEME) {
        theme!['theme'] = fromTHEME(theme: THEME.systemPreferences);
        themeProvider.changeTheme(data: {'theme': theme}, context: null);
      } else if (profileProvider.userProfile.theme!['theme'] ==
          PlaneKeys.DARK_CONTRAST_THEME) {
        theme!['theme'] = fromTHEME(theme: THEME.darkHighContrast);
        themeProvider.changeTheme(data: {'theme': theme}, context: null);
      } else if (profileProvider.userProfile.theme!['theme'] ==
          PlaneKeys.LIGHT_CONTRAST_THEME) {
        theme!['theme'] = fromTHEME(theme: THEME.lightHighContrast);
        themeProvider.changeTheme(data: {'theme': theme}, context: null);
      } else if (profileProvider.userProfile.theme!['theme'] ==
          PlaneKeys.CUSTOM_THEME) {
        theme!['theme'] = fromTHEME(theme: THEME.custom);
        themeProvider.changeTheme(data: {'theme': theme}, context: null);
      } else {
        themeProvider.changeTheme(data: {
          'theme': {
            'primary': profileProvider.userProfile.theme!['primary'],
            'background': profileProvider.userProfile.theme!['background'],
            'text': profileProvider.userProfile.theme!['text'],
            'sidebarText': profileProvider.userProfile.theme!['sidebarText'],
            'sidebarBackground':
                profileProvider.userProfile.theme!['sidebarBackground'],
            'theme': 'custom',
          }
        }, context: null);
      }
    }
  }

  static Future<void> _resolveProjects(WidgetRef ref) async {
    final ProjectsProvider projectProvider =
        ref.read(ProviderList.projectProvider);
    final WorkspaceProvider workspaceProvider =
        ref.read(ProviderList.workspaceProvider);
    projectProvider.getProjects(
        slug: workspaceProvider.selectedWorkspace.workspaceSlug);
  }

  static Future<void> _resolveMyIssues(WidgetRef ref) async {
    final MyIssuesProvider myIssuesProvider =
        ref.read(ProviderList.myIssuesProvider);

    myIssuesProvider.getLabels();
    await myIssuesProvider.getMyIssuesView();
    myIssuesProvider.filterIssues(assigned: true);
  }

  static Future<void> _resolveNotifications(WidgetRef ref) async {
    final NotificationProvider notificationProvider =
        ref.read(ProviderList.notificationProvider);

    notificationProvider.getUnreadCount();
    notificationProvider.getNotifications(type: 'assigned');
    notificationProvider.getNotifications(type: 'created');
    notificationProvider.getNotifications(type: 'watching');
    notificationProvider.getNotifications(type: 'unread', getUnread: true);
    notificationProvider.getNotifications(type: 'archived', getArchived: true);
    notificationProvider.getNotifications(type: 'snoozed', getSnoozed: true);
  }

  static Future<void> _resolveWhatsNew(WidgetRef ref) async {
    final WhatsNewNotifier whatsNewProvider =
        ref.read(ProviderList.whatsNewProvider.notifier);
    whatsNewProvider.getWhatsNew();
  }
}
