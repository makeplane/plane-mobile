import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/core/dio/dio_service.dart';
import 'package:plane/utils/enums.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationProvider(
      ChangeNotifierProviderRef<NotificationProvider> this.ref);
  Ref? ref;
  DataState getCreatedState = DataState.idle;
  DataState getAssignedState = DataState.idle;
  DataState getWatchingState = DataState.idle;
  DataState getUnreadState = DataState.idle;
  DataState getArchivedState = DataState.idle;
  DataState getSnoozedState = DataState.idle;
  DataState markAllAsReadState = DataState.idle;

  int getCreatedCount = 0;
  int getAssignedCount = 0;
  int getWatchingCount = 0;
  int totalUnread = 0;

  List<dynamic> created = [];
  List<dynamic> assigned = [];
  List<dynamic> watching = [];
  List<dynamic> unread = [];
  List<dynamic> archived = [];
  List<dynamic> snoozed = [];
  DateTime? snoozedDate;

  Future getAllNotifications() async {
    getUnreadCount();
    getNotifications(type: 'assigned');
    getNotifications(type: 'created');
    getNotifications(type: 'watching');
    getNotifications(type: 'unread', getUnread: true);
    getNotifications(type: 'archived', getArchived: true);
    getNotifications(type: 'snoozed', getSnoozed: true);
  }

  Future getNotifications({
    required String type,
    bool getUnread = false,
    bool getArchived = false,
    bool getSnoozed = false,
  }) async {
    type == 'created'
        ? getCreatedState = DataState.loading
        : type == 'assigned'
            ? getAssignedState = DataState.loading
            : type == 'watching'
                ? getWatchingState = DataState.loading
                : type == 'unread'
                    ? getUnreadState = DataState.loading
                    : type == 'archived'
                        ? getArchivedState = DataState.loading
                        : type == 'snoozed'
                            ? getSnoozedState = DataState.loading
                            : null;
    notifyListeners();
    final String slug = ref!
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: getUnread
            ? '${APIs.notifications.replaceAll('\$SLUG', slug)}?read=false'
            : getArchived
                ? '${APIs.notifications.replaceAll('\$SLUG', slug)}?archived=true'
                : getSnoozed
                    ? '${APIs.notifications.replaceAll('\$SLUG', slug)}?snoozed=true'
                    : '${APIs.notifications.replaceAll('\$SLUG', slug)}?type=$type',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      if (type == 'created') {
        created = response.data;
      } else if (type == 'assigned') {
        assigned = response.data;
      } else if (type == 'watching') {
        watching = response.data;
      }

      if (getUnread) {
        // log('getUnread: ${response.data.toString()}');
        unread = response.data;
      }
      if (getArchived) {
        // log('getArchived: ${response.data.toString()}');
        archived = response.data;
      }
      if (getSnoozed) {
        // log('getSnoozed: ${response.data.toString()}');
        snoozed = response.data;
      }
      type == 'created'
          ? getCreatedState = DataState.success
          : type == 'assigned'
              ? getAssignedState = DataState.success
              : type == 'watching'
                  ? getWatchingState = DataState.success
                  : type == 'unread'
                      ? getUnreadState = DataState.success
                      : type == 'archived'
                          ? getArchivedState = DataState.success
                          : type == 'snoozed'
                              ? getSnoozedState = DataState.success
                              : null;
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
      type == 'created'
          ? getCreatedState = DataState.error
          : type == 'assigned'
              ? getAssignedState = DataState.error
              : getWatchingState = DataState.error;
      notifyListeners();
    }
  }

  Future getUnreadCount() async {
    final String slug = ref!
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;

    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: '${APIs.notifications.replaceAll('\$SLUG', slug)}unread',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      getCreatedCount = response.data['created_issues'];
      getAssignedCount = response.data['my_issues'];
      getWatchingCount = response.data['watching_issues'];

      totalUnread = getCreatedCount + getAssignedCount + getWatchingCount;

      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
    }
  }

  Future markAsRead(String notificationId) async {
    final String slug = ref!
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;

    log('${APIs.notifications.replaceAll('\$SLUG', slug)}$notificationId/read');
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url:
            '${APIs.notifications.replaceAll('\$SLUG', slug)}$notificationId/read/',
        hasBody: true,
        data: {},
        httpMethod: HttpMethod.post,
      );
      log('markAsRead: ${response.data.toString()}');
      getUnreadCount();
      getNotifications(type: '', getUnread: true);
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
    }
  }

  Future markAllAsRead(String type) async {
    final String slug = ref!
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;

    // log('${APIs.notifications.replaceAll('\$SLUG', slug)}/mark-all-read/');
    try {
      type == 'created'
          ? getCreatedState = DataState.loading
          : type == 'assigned'
              ? getAssignedState = DataState.loading
              : getWatchingState = DataState.loading;
      notifyListeners();
      await DioClient().request(
        hasAuth: true,
        url: '${APIs.notifications.replaceAll('\$SLUG', slug)}mark-all-read/',
        hasBody: true,
        data: {
          "archived": false,
          "snoozed": false,
          "type": type,
        },
        httpMethod: HttpMethod.post,
      );

      type == 'created'
          ? getCreatedState = DataState.success
          : type == 'assigned'
              ? getAssignedState = DataState.success
              : getWatchingState = DataState.success;
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
      type == 'created'
          ? getCreatedState = DataState.error
          : type == 'assigned'
              ? getAssignedState = DataState.error
              : getWatchingState = DataState.error;
      notifyListeners();
    }
  }

  Future archiveNotification(
      String notificationId, HttpMethod httpMethod) async {
    final String slug = ref!
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;

    log('${APIs.notifications.replaceAll('\$SLUG', slug)}$notificationId');
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url:
            '${APIs.notifications.replaceAll('\$SLUG', slug)}$notificationId/archive/',
        hasBody: httpMethod == HttpMethod.post ? true : false,
        data: {},
        httpMethod: httpMethod,
      );
      log('archiveNotification: ${response.data.toString()}');
      getUnreadCount();
      getNotifications(type: 'archived', getArchived: true);
      getNotifications(type: 'assigned');
      getNotifications(type: 'created');
      getNotifications(type: 'watching');

      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
    }
  }

  Future updateSnooze(String notificationId) async {
    if (snoozedDate == null) {
      return;
    }
    final String slug = ref!
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;
    log('${APIs.notifications.replaceAll('\$SLUG', slug)}$notificationId');
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: '${APIs.notifications.replaceAll('\$SLUG', slug)}$notificationId/',
        hasBody: true,
        data: {
          'snoozed_till': snoozedDate!.toIso8601String(),
        },
        httpMethod: HttpMethod.patch,
      );
      log('updateSnooze: ${response.data.toString()}');
      snoozedDate = null;
      getUnreadCount();
      getNotifications(type: 'snoozed', getSnoozed: true);
      getNotifications(type: 'assigned');
      getNotifications(type: 'created');
      getNotifications(type: 'watching');

      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
    }
  }
}
