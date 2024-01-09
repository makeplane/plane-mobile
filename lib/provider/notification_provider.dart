import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/enums.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationProvider(
      ChangeNotifierProviderRef<NotificationProvider> this.ref);
  Ref? ref;
  StateEnum getCreatedState = StateEnum.idle;
  StateEnum getAssignedState = StateEnum.idle;
  StateEnum getWatchingState = StateEnum.idle;
  StateEnum getUnreadState = StateEnum.idle;
  StateEnum getArchivedState = StateEnum.idle;
  StateEnum getSnoozedState = StateEnum.idle;
  StateEnum markAllAsReadState = StateEnum.idle;

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
        ? getCreatedState = StateEnum.loading
        : type == 'assigned'
            ? getAssignedState = StateEnum.loading
            : type == 'watching'
                ? getWatchingState = StateEnum.loading
                : type == 'unread'
                    ? getUnreadState = StateEnum.loading
                    : type == 'archived'
                        ? getArchivedState = StateEnum.loading
                        : type == 'snoozed'
                            ? getSnoozedState = StateEnum.loading
                            : null;
    notifyListeners();
    final String slug = ref!
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;
    try {
      final response = await DioConfig().dioServe(
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
          ? getCreatedState = StateEnum.success
          : type == 'assigned'
              ? getAssignedState = StateEnum.success
              : type == 'watching'
                  ? getWatchingState = StateEnum.success
                  : type == 'unread'
                      ? getUnreadState = StateEnum.success
                      : type == 'archived'
                          ? getArchivedState = StateEnum.success
                          : type == 'snoozed'
                              ? getSnoozedState = StateEnum.success
                              : null;
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
      type == 'created'
          ? getCreatedState = StateEnum.error
          : type == 'assigned'
              ? getAssignedState = StateEnum.error
              : getWatchingState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getUnreadCount() async {
    final String slug = ref!
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;

    try {
      final response = await DioConfig().dioServe(
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
      final response = await DioConfig().dioServe(
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
          ? getCreatedState = StateEnum.loading
          : type == 'assigned'
              ? getAssignedState = StateEnum.loading
              : getWatchingState = StateEnum.loading;
      notifyListeners();
      await DioConfig().dioServe(
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
          ? getCreatedState = StateEnum.success
          : type == 'assigned'
              ? getAssignedState = StateEnum.success
              : getWatchingState = StateEnum.success;
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
      type == 'created'
          ? getCreatedState = StateEnum.error
          : type == 'assigned'
              ? getAssignedState = StateEnum.error
              : getWatchingState = StateEnum.error;
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
      final response = await DioConfig().dioServe(
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
      final response = await DioConfig().dioServe(
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
