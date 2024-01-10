import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/const.dart';
import 'package:plane/provider/projects_provider.dart';
import 'package:plane/provider/workspace_provider.dart';
import '../models/user_profile_model.dart';
import '../provider/my_issues_provider.dart';
import '../provider/notification_provider.dart';
import '../provider/profile_provider.dart';
import '../provider/provider_list.dart';
import '../provider/theme_provider.dart';
import '../provider/whats_new_provider.dart';
import '../utils/custom_toast.dart';
import '../utils/enums.dart';
import '../utils/theme_manager.dart';

class DependencyResolver {
  static Future<void> resolve({required WidgetRef ref}) async {
    await _resolveConfig(ref).then((_) async {
      if (Const.accessToken == null) {
        CustomToast(manager: ThemeManager(THEME.light));
        FlutterNativeSplash.remove();
        return;
      }
      final ProfileProvider profileProvider =
          ref.read(ProviderList.profileProvider);
      final WorkspaceProvider workspaceProvider =
          ref.read(ProviderList.workspaceProvider);

      await _resolveUserProfile(ref).then((value) {
        value.fold((userProfile) => null, (error) {
          FlutterNativeSplash.remove();
          OverlayEntry entry = OverlayEntry(builder: (context) {
            return Positioned(
              width: MediaQuery.of(context).size.width,
              bottom: 0,
              child: CustomToast.getToastWithColorWidget(
                  'Something went wrong while fetching your data, Please try again.',
                  toastType: ToastType.failure),
            );
          });
          Overlay.of(ref.context).insert(entry);
          Future.delayed(const Duration(seconds: 1), () {
            entry.remove();
          });
          return;
        });
      });
      if (profileProvider.userProfile.isOnboarded == false) {
        FlutterNativeSplash.remove();
        return;
      }

      await _resolveProfileSetting(ref);

      await _resolveWorkspaces(ref);
      if (workspaceProvider.workspaces.isEmpty) {
        FlutterNativeSplash.remove();
        return;
      }
      _resolveTheme(ref);
      _resolveDashBoard(ref);
      _resolveProjects(ref);
      _resolveMyIssues(ref);
      _resolveNotifications(ref);
      _resolveWhatsNew(ref);
      FlutterNativeSplash.remove();
    });
  }

  static Future<void> _resolveConfig(WidgetRef ref) async {
    return await ref.read(ProviderList.configProvider.notifier).getConfig();
  }

  static Future<void> _resolveDashBoard(WidgetRef ref) async {
    ref.read(ProviderList.dashboardProvider).getDashboard();
  }

  static Future<Either<UserProfile, DioException>> _resolveUserProfile(
      WidgetRef ref) async {
    final ProfileProvider profileProvider =
        ref.read(ProviderList.profileProvider);
    return await profileProvider.getProfile();
  }

  static Future<void> _resolveProfileSetting(WidgetRef ref) async {
    final ProfileProvider profileProvider =
        ref.read(ProviderList.profileProvider);
    await profileProvider.getProfileSetting();
  }

  static Future<void> _resolveWorkspaces(WidgetRef ref) async {
    final WorkspaceProvider workspaceProvider =
        ref.read(ProviderList.workspaceProvider);
    await workspaceProvider.getWorkspaces();
    if (workspaceProvider.workspaces.isEmpty) {
      FlutterNativeSplash.remove();
      return;
    }
    await workspaceProvider.retrieveUserRole();
    workspaceProvider.getWorkspaceMembers();
  }

  static void _resolveTheme(WidgetRef ref) {
    final ThemeProvider themeProvider = ref.read(ProviderList.themeProvider);
    themeProvider.getTheme();
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
