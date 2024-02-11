import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane/models/user_activity_model.dart';
import 'package:plane/models/user_assigned_issue_model.dart';
import 'package:plane/models/user_created_issues_model.dart';
import 'package:plane/models/user_stats_model.dart';
import 'package:plane/models/user_susbscribed_issues_model.dart';
import 'package:plane/utils/enums.dart';

import '../config/apis.dart';
import '../core/dio/dio_service.dart';
import 'provider_list.dart';

class MemberProfileStateModel {
  MemberProfileStateModel(
      {required this.memberProfile,
      required this.getMemberProfileState,
      required this.userStats,
      required this.getUserStatsState,
      required this.userActivity,
      required this.getUserActivityState,
      required this.createdIssues,
      required this.getCreatedIssuesState,
      required this.userAssignedIssues,
      required this.getUserAssingedIssuesState,
      required this.userSubscribedIssues,
      required this.getUserSubscribedIssuesState,
      required this.issuesCountByState,
      required this.issuesByPriority,
      required this.profileData,
      required this.projectData,
      required this.expanded});
  Map<String, dynamic> memberProfile;
  UserStatsModel userStats;
  UserActivityModel userActivity;
  List<CreatedIssuesModel>? createdIssues;
  List<UserAssingedIssuesModel> userAssignedIssues;
  List<UserSubscribedIssuesModel> userSubscribedIssues;
  DataState getMemberProfileState;
  DataState getUserStatsState;
  DataState getUserActivityState;
  DataState getCreatedIssuesState;
  DataState getUserAssingedIssuesState;
  DataState getUserSubscribedIssuesState;
  List<Map<String, dynamic>> issuesCountByState;
  List<Map<String, dynamic>> issuesByPriority;
  Map profileData;
  List projectData;
  List<bool> expanded;

  MemberProfileStateModel copyWith(
      {Map<String, dynamic>? memberProfile,
      DataState? getMemberProfileState,
      UserStatsModel? userStats,
      DataState? getUserStatsState,
      UserActivityModel? userActivity,
      DataState? getUserActivityState,
      List<CreatedIssuesModel>? createdIssues,
      List<UserAssingedIssuesModel>? userAssignedIssues,
      List<UserSubscribedIssuesModel>? userSubscribedIssues,
      DataState? getCreatedIssuesState,
      DataState? getUserAssingedIssuesState,
      DataState? getUserSubscribedIssuesState,
      List<Map<String, dynamic>>? issuesCountByState,
      List<Map<String, dynamic>>? issuesByPriority,
      Map? profileData,
      List? projectData,
      List<bool>? expanded}) {
    return MemberProfileStateModel(
        memberProfile: memberProfile ?? this.memberProfile,
        getMemberProfileState:
            getMemberProfileState ?? this.getMemberProfileState,
        userStats: userStats ?? this.userStats,
        getUserStatsState: getUserStatsState ?? this.getUserStatsState,
        userActivity: userActivity ?? this.userActivity,
        getUserActivityState: getUserActivityState ?? this.getUserActivityState,
        createdIssues: createdIssues ?? this.createdIssues,
        getCreatedIssuesState:
            getCreatedIssuesState ?? this.getCreatedIssuesState,
        userAssignedIssues: userAssignedIssues ?? this.userAssignedIssues,
        getUserAssingedIssuesState:
            getUserAssingedIssuesState ?? this.getUserAssingedIssuesState,
        userSubscribedIssues: userSubscribedIssues ?? this.userSubscribedIssues,
        getUserSubscribedIssuesState:
            getUserSubscribedIssuesState ?? this.getUserSubscribedIssuesState,
        issuesCountByState: issuesCountByState ?? this.issuesCountByState,
        issuesByPriority: issuesByPriority ?? this.issuesByPriority,
        profileData: profileData ?? this.profileData,
        projectData: projectData ?? this.projectData,
        expanded: expanded ?? this.expanded);
  }
}

class MemberProfileProvider extends StateNotifier<MemberProfileStateModel> {
  MemberProfileProvider(this.ref)
      : super(
          MemberProfileStateModel(
            getMemberProfileState: DataState.loading,
            memberProfile: {},
            userStats: UserStatsModel().emptyData(),
            getUserStatsState: DataState.loading,
            userActivity: UserActivityModel.userActivityEmpty(),
            getUserActivityState: DataState.loading,
            createdIssues: [],
            getCreatedIssuesState: DataState.loading,
            userAssignedIssues: [],
            getUserAssingedIssuesState: DataState.loading,
            userSubscribedIssues: [],
            getUserSubscribedIssuesState: DataState.loading,
            issuesCountByState: [
              {
                'state_group': 'backlog',
                'state': 'Backlog',
                'count': 0,
                'color': const Color.fromRGBO(217, 217, 217, 1)
              },
              {
                'state_group': 'unstarted',
                'state': 'Not Started',
                'count': 0,
                'color': const Color.fromRGBO(63, 118, 255, 1)
              },
              {
                'state_group': 'started',
                'state': 'Working on',
                'count': 0,
                'color': const Color.fromRGBO(245, 158, 11, 1)
              },
              {
                'state_group': 'completed',
                'state': 'Completed',
                'count': 0,
                'color': const Color.fromRGBO(22, 163, 74, 1)
              },
              {
                'state_group': 'cancelled',
                'state': 'Cancelled',
                'count': 0,
                'color': const Color.fromRGBO(220, 38, 38, 1)
              },
            ],
            issuesByPriority: [],
            profileData: {
              'Username': '',
              'Joined on': '',
              'Timezone': '',
              'Status': 'Online',
            },
            projectData: [
              {
                'name': 'Created',
                'color': const Color.fromRGBO(32, 59, 128, 1),
                'key': 'created_issues'
              },
              {
                'name': 'Assigned',
                'color': const Color.fromRGBO(63, 118, 255, 1),
                'key': 'assigned_issues'
              },
              {
                'name': 'Due',
                'color': const Color.fromRGBO(245, 158, 11, 1),
                'key': 'pending_issues'
              },
              {
                'name': 'Completed',
                'color': const Color.fromRGBO(22, 163, 74, 1),
                'key': 'completed_issues'
              },
            ],
            expanded: [],
          ),
        );
  Ref ref;
  Future getMemberProfile({required String userID}) async {
    state.getMemberProfileState = DataState.loading;
    try {
      final workspaceSlug = ref
          .read(ProviderList.workspaceProvider)
          .selectedWorkspace
          .workspaceSlug;
      final response = await DioClient().request(
        url: APIs.memberProfile
            .replaceAll('\$SLUG', workspaceSlug)
            .replaceAll('\$USERID', userID),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      state.profileData['Username'] =
          response.data['user_data']['display_name'];
      state.profileData['Joined on'] = DateFormat('MMM dd, yyyy')
          .format(DateTime.parse(response.data['user_data']['date_joined']));
      state.profileData['Timezone'] =
          response.data['user_data']['user_timezone'];

      state.expanded =
          List.generate(response.data['project_data'].length, (index) => false);
      state = state.copyWith(
          getMemberProfileState: DataState.success,
          memberProfile: response.data,
          profileData: state.profileData,
          expanded: state.expanded);
      return state.memberProfile;
    } on DioException catch (err) {
      state = state.copyWith(getMemberProfileState: DataState.error);
      log(err.message.toString());
    }
  }

  Future getUserStats({required String userId}) async {
    try {
      state = state.copyWith(
          userStats: UserStatsModel().emptyData(),
          getUserStatsState: DataState.loading);
      final String workspaceSlug = ref
          .read(ProviderList.workspaceProvider)
          .selectedWorkspace
          .workspaceSlug;
      final response = await DioClient().request(
        url: APIs.userStats
            .replaceAll('\$SLUG', workspaceSlug)
            .replaceAll('\$USERID', userId),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      state = state.copyWith(
          userStats: UserStatsModel.fromJson(response.data),
          getUserStatsState: DataState.success);
    } on DioException {
      state = state.copyWith(getUserStatsState: DataState.error);
    }
  }

  Future getUserActivity({required String userId}) async {
    try {
      state = state.copyWith(
          getUserActivityState: DataState.loading,
          userActivity: UserActivityModel.userActivityEmpty());
      final String workspaceSlug = ref
          .read(ProviderList.workspaceProvider)
          .selectedWorkspace
          .workspaceSlug;
      final response = await DioClient().request(
        url: APIs.userActivity
            .replaceAll('\$SLUG', workspaceSlug)
            .replaceAll('\$USERID', userId),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      state = state.copyWith(
          userActivity: UserActivityModel.fromJson(response.data),
          getUserActivityState: DataState.success);
    } on DioException catch (e) {
      log(e.error.toString());
      state = state.copyWith(getUserActivityState: DataState.error);
    }
  }

  Future getuserCreeatedIssues(
      {required String userId, required String createdByUserId}) async {
    state = state
        .copyWith(getCreatedIssuesState: DataState.loading, createdIssues: []);
    final String workspaceSlug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;
    try {
      final response = await DioClient().request(
        url:
            '${APIs.userIssues.replaceAll('\$SLUG', workspaceSlug).replaceAll('\$USERID', userId)}?created_by=$createdByUserId&order_by=-created_at',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );

      for (final element in (response.data as List)) {
        state.createdIssues!.add(CreatedIssuesModel.fromJson(element));
      }
      state = state.copyWith(
          createdIssues: state.createdIssues!,
          getCreatedIssuesState: DataState.success);
    } on DioException catch (e) {
      log(e.error.toString());
      state = state.copyWith(getCreatedIssuesState: DataState.error);
    }
  }

  Future getuserAssingedIssues(
      {required String userId, required String assignedUserId}) async {
    state = state.copyWith(
        getUserAssingedIssuesState: DataState.loading, userAssignedIssues: []);
    final String workspaceSlug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;
    try {
      final response = await DioClient().request(
        url:
            '${APIs.userIssues.replaceAll('\$SLUG', workspaceSlug).replaceAll('\$USERID', userId)}?assignees=$assignedUserId&order_by=-created_at',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );

      for (final element in (response.data as List)) {
        state.userAssignedIssues.add(UserAssingedIssuesModel.fromJson(element));
      }
      state = state.copyWith(
          userAssignedIssues: state.userAssignedIssues,
          getUserAssingedIssuesState: DataState.success);
    } on DioException catch (e) {
      log(e.error.toString());
      state = state.copyWith(getUserAssingedIssuesState: DataState.error);
    }
  }

  Future getuserSubscribedIssues(
      {required String userId, required String subscribedByUserId}) async {
    state = state.copyWith(
        getUserSubscribedIssuesState: DataState.loading,
        userSubscribedIssues: []);
    final String workspaceSlug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;
    try {
      final response = await DioClient().request(
        url:
            '${APIs.userIssues.replaceAll('\$SLUG', workspaceSlug).replaceAll('\$USERID', userId)}?subscriber=$subscribedByUserId&order_by=-created_at',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );

      for (final element in (response.data as List)) {
        state.userSubscribedIssues
            .add(UserSubscribedIssuesModel.fromJson(element));
      }
      state = state.copyWith(
          userSubscribedIssues: state.userSubscribedIssues,
          getUserSubscribedIssuesState: DataState.success);
    } on DioException catch (e) {
      log(e.error.toString());
      state = state.copyWith(getUserSubscribedIssuesState: DataState.error);
    }
  }

  void getIssuesCountByState() {
    final List<Map<String, dynamic>> issues = state.issuesCountByState;

    final Map<String, int> stateCount = {
      'backlog': 0,
      'unstarted': 0,
      'started': 0,
      'completed': 0,
      'cancelled': 0
    };

    for (final element1 in state.userStats.stateDistribution!) {
      stateCount[element1['state_group']] =
          stateCount[element1['state_group']] != null
              ? stateCount[element1['state_group']]! + 1
              : 0;
      for (final element2 in issues) {
        if (element1['state_group'] == element2['state_group']) {
          element2['count'] = element1['state_count'];
        }
      }
    }

    for (final element in issues) {
      if (stateCount[element['state_group']] == 0) {
        element['count'] = 0;
      }
    }
    state = state.copyWith(issuesCountByState: issues);
  }

  void addColors() {
    final List<Color> colors = [
      const Color.fromRGBO(153, 27, 27, 1),
      const Color.fromRGBO(239, 68, 68, 1),
      const Color.fromRGBO(245, 158, 11, 1),
      const Color.fromRGBO(229, 229, 229, 1)
      // const Color.fromRGBO(22, 163, 74, 1),
    ];
    state.issuesByPriority = state.userStats.priorityDistribution!;
    for (int i = 0; i < state.issuesByPriority.length; i++) {
      state.issuesByPriority[i]["color"] = colors[i];
    }
    state = state.copyWith(issuesByPriority: state.issuesByPriority);
  }
}
