// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/const.dart';
import 'package:plane/models/workspace/workspace_model.dart';
import 'package:plane/models/current_route_detail.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/core/dio/dio_service.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/global_functions.dart';

import '../repository/workspace_service.dart';

class WorkspaceProvider extends ChangeNotifier {
  WorkspaceProvider(
      {required ChangeNotifierProviderRef<WorkspaceProvider>? this.ref,
      required this.workspaceService});
  Ref? ref;
  WorkspaceService workspaceService;
  TextEditingController invitingMembersRole = TextEditingController();
  List workspaceInvitations = [];
  List workspaces = [];
  String companySize = '';
  List<dynamic> workspaceIntegrations = [];
  dynamic githubIntegration;
  dynamic slackIntegration;
  WorkspaceModel selectedWorkspace = WorkspaceModel.initialize();
  bool urlAvailable = false;
  // final currentWorkspace = {};
  List workspaceMembers = [];
  List workspaceInvitationsMembers = [];
  String tempLogo = '';
  WorkspaceModel? workspace;
  DataState workspaceInvitationState = DataState.empty;
  DataState checkWorkspaceState = DataState.empty;
  DataState selectWorkspaceState = DataState.empty;
  DataState uploadImageState = DataState.empty;
  DataState getMembersState = DataState.empty;
  DataState getMembersInvitationsState = DataState.empty;
  DataState removeMembersInvitationsState = DataState.empty;
  DataState joinWorkspaceState = DataState.empty;
  DataState createWorkspaceState = DataState.empty;
  DataState updateWorkspaceState = DataState.empty;
  DataState leaveWorspaceState = DataState.empty;
  Role role = Role.none;
  void clear() {
    workspaceInvitations = [];
    workspaces = [];
    workspaceIntegrations = [];
    selectedWorkspace = WorkspaceModel.initialize();
    urlAvailable = false;
    // currentWorkspace = {};
    checkWorkspaceState = DataState.empty;
    joinWorkspaceState = DataState.empty;
    createWorkspaceState = DataState.empty;
    updateWorkspaceState = DataState.empty;
    leaveWorspaceState = DataState.empty;
    getMembersInvitationsState = DataState.empty;
    removeMembersInvitationsState = DataState.empty;
    workspaceMembers = [];
    workspaceInvitationsMembers = [];
  }

  String get slug => selectedWorkspace.workspaceSlug;

  void changeLogo({required String logo}) {
    tempLogo = logo;
    notifyListeners();
  }

  void removeLogo() {
    tempLogo = '';
    notifyListeners();
  }

  void changeCompanySize({required String size}) {
    companySize = size;
    notifyListeners();
  }

  Future getWorkspaceInvitations() async {
    workspaceInvitationState = DataState.loading;
    notifyListeners();
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: APIs.listWorkspaceInvitaion,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      workspaceInvitationState = DataState.success;
      workspaceInvitations = response.data;
      //log(response.data.toString());
      notifyListeners();
      // return response.data;
    } on DioException catch (e) {
      log(e.error.toString());
      workspaceInvitationState = DataState.error;
      notifyListeners();
    }
  }

  Future joinWorkspaces({required List data}) async {
    joinWorkspaceState = DataState.loading;
    notifyListeners();

    try {
      await DioClient().request(
        hasAuth: true,
        url: APIs.listWorkspaceInvitaion,
        hasBody: true,
        data: {"invitations": data},
        httpMethod: HttpMethod.post,
      );
      joinWorkspaceState = DataState.success;
      // postHogService(eventName: 'WORKSPACE_USER_INVITE_ACCEPT', properties: {
      //   'WORKSPACE_ID': data
      // });
      getWorkspaces();
      notifyListeners();
      // return response.data;
    } catch (e) {
      if (e is DioException) {
        log(e.message.toString());
        log(e.error.toString());
        log(e.response.toString());
      }
      log("ERROR$e");
      joinWorkspaceState = DataState.error;
      notifyListeners();
    }
  }

  Future createWorkspace(
      {required String name,
      required String slug,
      required String size,
      required WidgetRef refs,
      required BuildContext context}) async {
    createWorkspaceState = DataState.loading;
    notifyListeners();
    // return;
    try {
      final response = await DioClient().request(
          hasAuth: true,
          url: APIs.createWorkspace,
          hasBody: true,
          httpMethod: HttpMethod.post,
          data: {"name": name, "slug": slug, "organization_size": size});

      final projectProv = ref!.read(ProviderList.projectProvider);
      final profileProv = ref!.read(ProviderList.profileProvider);
      final myissuesProv = ref!.read(ProviderList.myIssuesProvider);
      profileProv.userProfile.lastWorkspaceId = response.data['id'];
      postHogService(
          eventName: 'CREATE_WORKSPACE',
          properties: {
            'WORKSPACE_ID': response.data['id'],
            'WORKSPACE_NAME': response.data['name'],
            'WORKSPACE_SLUG': response.data['slug']
          },
          userEmail: profileProv.userProfile.email!,
          userID: profileProv.userProfile.id!);
      await profileProv.updateProfile(data: {
        "last_workspace_id": response.data['id'],
      });
      await getWorkspaces();
      ref!.read(ProviderList.dashboardProvider).getDashboard();
      projectProv.projects = [];
      projectProv.getProjects(slug: slug);
      myissuesProv.getMyIssuesView().then((value) {
        myissuesProv.filterIssues(assigned: true);
      });

      ref!.read(ProviderList.notificationProvider).getUnreadCount();
      ref!.read(ProviderList.myIssuesProvider).getLabels();

      ref!
          .read(ProviderList.notificationProvider)
          .getNotifications(type: 'assigned');
      ref!
          .read(ProviderList.notificationProvider)
          .getNotifications(type: 'created');
      ref!
          .read(ProviderList.notificationProvider)
          .getNotifications(type: 'watching');
      ref!
          .read(ProviderList.notificationProvider)
          .getNotifications(type: 'unread', getUnread: true);
      ref!
          .read(ProviderList.notificationProvider)
          .getNotifications(type: 'archived', getArchived: true);
      ref!
          .read(ProviderList.notificationProvider)
          .getNotifications(type: 'snoozed', getSnoozed: true);
      createWorkspaceState = DataState.success;
      notifyListeners();
      return response.statusCode!;
      // return response.data;
    } catch (e) {
      log('Create Workspace Error ');

      if (e is DioException) {
        log(e.response!.data.toString());
        log(e.message.toString());
        CustomToast.showToast(context,
            message: e.response.toString(), toastType: ToastType.failure);
      } else {
        log(e.toString());
      }
      createWorkspaceState = DataState.error;
      notifyListeners();
    }
  }

  bool isAdminOrMember() => (role == Role.admin || role == Role.member);

  Future checkWorspaceSlug({required String slug}) async {
    checkWorkspaceState = DataState.loading;
    notifyListeners();
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: APIs.workspaceSlugCheck.replaceFirst('SLUG', slug),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      if (response.data['status'] == false) {
        urlAvailable = false;
      } else {
        urlAvailable = true;
      }
      checkWorkspaceState = DataState.success;
      notifyListeners();
      return urlAvailable;
    } catch (e) {
      if (e is DioException) {
        //  log(e.response.data.toString());
        log(e.message.toString());
      }
      log(e.toString());
      checkWorkspaceState = DataState.error;
      notifyListeners();
    }
  }

  Future inviteToWorkspace(
      // ignore: type_annotate_public_apis
      {required String slug,
      // ignore: type_annotate_public_apis
      required email,
      String? role}) async {
    workspaceInvitationState = DataState.loading;
    notifyListeners();
    try {
      log(APIs.inviteToWorkspace.replaceAll('\$SLUG', slug));
      log(role == null ? "ROLE NULL" : "ROLE NOT NULL");
      await DioClient().request(
        hasAuth: true,
        url: APIs.inviteToWorkspace.replaceAll('\$SLUG', slug),
        hasBody: true,
        data: role == null
            ? {"emails": email}
            : {
                "emails": [
                  {"email": email, "role": role}
                ]
              },
        httpMethod: HttpMethod.post,
      );
      workspaceInvitationState = DataState.success;
      notifyListeners();
      return !urlAvailable;
    } on DioException catch (e) {
      log(e.response!.data.toString());
      log(e.message.toString());
      workspaceInvitationState = DataState.error;
      notifyListeners();
    } catch (e) {
      log(e.toString());
      workspaceInvitationState = DataState.error;
      notifyListeners();
    }
  }

  Future getWorkspaces() async {
    workspaceInvitationState = DataState.loading;
    final response = await workspaceService.getWorkspaces();
    if (response.isLeft()) {
      workspaces = response.fold((l) => l, (r) => []);

      final isWorkspacePresent = workspaces.where((element) {
        if (element['id'] ==
            ref!
                .read(ProviderList.profileProvider)
                .userSetting
                .workspace
                .lastWorkspaceId) {
          selectedWorkspace = WorkspaceModel.fromJson(element);
          currentRouteDetails.update(
              workspaceSlug: selectedWorkspace.workspaceSlug);
          tempLogo = selectedWorkspace.workspaceLogo;
          return true;
        }
        return false;
      });

      final projectProv = ref!.read(ProviderList.projectProvider);
      final myissuesProv = ref!.read(ProviderList.myIssuesProvider);

      if (isWorkspacePresent.isEmpty) {
        if (workspaces.isEmpty) {
          workspaceInvitationState = DataState.error;
          notifyListeners();
          return;
        }
        selectedWorkspace = WorkspaceModel.fromJson(workspaces[0]);
        final slug = selectedWorkspace.workspaceSlug;
        ref!.read(ProviderList.dashboardProvider).getDashboard();
        projectProv.projects = [];
        projectProv.getProjects(slug: slug);
        myissuesProv.getMyIssuesView().then((value) {
          myissuesProv.filterIssues(assigned: true);
        });

        ref!.read(ProviderList.notificationProvider).getUnreadCount();
        ref!.read(ProviderList.myIssuesProvider).getLabels();

        ref!
            .read(ProviderList.notificationProvider)
            .getNotifications(type: 'assigned');
        ref!
            .read(ProviderList.notificationProvider)
            .getNotifications(type: 'created');
        ref!
            .read(ProviderList.notificationProvider)
            .getNotifications(type: 'watching');
        ref!
            .read(ProviderList.notificationProvider)
            .getNotifications(type: 'unread', getUnread: true);
        ref!
            .read(ProviderList.notificationProvider)
            .getNotifications(type: 'archived', getArchived: true);
        ref!
            .read(ProviderList.notificationProvider)
            .getNotifications(type: 'snoozed', getSnoozed: true);
        createWorkspaceState = DataState.success;
        notifyListeners();
      }

      getWorkspaceMembers();
      retrieveWorkspaceIntegration(slug: selectedWorkspace.workspaceSlug);
      workspaceInvitationState = DataState.success;
      notifyListeners();
      return selectedWorkspace;
    } else {
      log(response.fold((l) => l.toString(), (r) => r.error.toString()));
      workspaceInvitationState = DataState.error;
      notifyListeners();
    }
  }

  Future<Either<WorkspaceModel, DioException>> selectWorkspace(
      {required BuildContext context, required String id}) async {
    selectWorkspaceState = DataState.loading;
    notifyListeners();
    final profileProv = ref!.read(ProviderList.profileProvider);
    final response =
        await profileProv.updateProfile(data: {"last_workspace_id": id});
    if (response.isLeft()) {
      ref!.read(ProviderList.projectIssuesProvider.notifier).resetState();
      selectedWorkspace = WorkspaceModel.fromJson(
          workspaces.where((element) => element['id'] == id).first);
      currentRouteDetails.update(
          workspaceSlug: selectedWorkspace.workspaceSlug);
      ref!.read(ProviderList.dashboardProvider).getDashboard();
      role = Role.none;
      await retrieveUserRole();
      getWorkspaceMembers();
      retrieveWorkspaceIntegration(slug: selectedWorkspace.workspaceSlug);

      tempLogo = selectedWorkspace.workspaceLogo;
      selectWorkspaceState = DataState.success;
      notifyListeners();
      return Left(selectedWorkspace);
    } else {
      final DioException error = response.fold(
          (l) => DioException(
              requestOptions: RequestOptions(),
              message: 'Something went wrong!'),
          (r) => r);
      CustomToast.showToast(context,
          message: error.message.toString(), toastType: ToastType.failure);
      log(error.message.toString());
      selectWorkspaceState = DataState.error;
      notifyListeners();
      return Right(error);
    }
  }

  Future retrieveUserRole() async {
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: APIs.retrieveUserRoleOnWorkspace
            .replaceAll('\$SLUG', selectedWorkspace.workspaceSlug),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      role = roleParser(role: response.data["role"]);
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future retrieveWorkspace({required String slug}) async {
    selectWorkspaceState = DataState.loading;
    notifyListeners();
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: APIs.retrieveWorkspace.replaceAll('\$SLUG', slug),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      selectWorkspaceState = DataState.success;
      log(response.data.toString());
      // response = jsonDecode(response.data);
      selectedWorkspace = WorkspaceModel.fromJson(response.data);
      tempLogo = selectedWorkspace.workspaceLogo;
      await retrieveWorkspaceIntegration(slug: selectedWorkspace.workspaceSlug);

      notifyListeners();
      // log(response.data.toString());
    } catch (e) {
      log(e.toString());
      selectWorkspaceState = DataState.error;
      notifyListeners();
    }
  }

  Future retrieveWorkspaceIntegration({required String slug}) async {
    if (!isAdminOrMember()) return;
    //selectWorkspaceState = StateEnum.loading;
    githubIntegration = null;
    slackIntegration = null;
    //notifyListeners();
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: APIs.retrieveWorkspaceIntegrations.replaceAll('\$SLUG', slug),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      // response = jsonDecode(response.data);
      //selectedWorkspace = WorkspaceModel.fromJson(response.data);
      workspaceIntegrations = response.data;

      if (workspaceIntegrations.isNotEmpty) {
        for (int i = 0; i < workspaceIntegrations.length; i++) {
          if (workspaceIntegrations[i]["integration_detail"]["provider"] ==
              "slack") {
            slackIntegration = workspaceIntegrations[i];
          } else if (workspaceIntegrations[i]["integration_detail"]
                  ["provider"] ==
              "github") {
            githubIntegration = workspaceIntegrations[i];
          }
        }
      }

      notifyListeners();
      // log(response.data.toString());
    } catch (e) {
      log(e.toString());
      //selectWorkspaceState = StateEnum.error;
      //notifyListeners();
    }
  }

  Future updateWorkspace({required Map data, required WidgetRef ref}) async {
    final profileProvider = ref.read(ProviderList.profileProvider);
    updateWorkspaceState = DataState.loading;
    notifyListeners();
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: APIs.retrieveWorkspace.replaceAll(
          '\$SLUG',
          selectedWorkspace.workspaceSlug,
        ),
        hasBody: true,
        data: data,
        httpMethod: HttpMethod.patch,
      );
      updateWorkspaceState = DataState.success;
      postHogService(
          eventName: 'UPDATE_WORKSPACE',
          properties: {
            'WORKSPACE_ID': response.data['id'],
            'WORKSPACE_NAME': response.data['name'],
            'WORKSPACE_SLUG': response.data['slug']
          },
          userEmail: profileProvider.userProfile.email!,
          userID: profileProvider.userProfile.id!);
      selectedWorkspace = WorkspaceModel.fromJson(response.data);
      currentRouteDetails.update(
          workspaceSlug: selectedWorkspace.workspaceSlug);
      tempLogo = selectedWorkspace.workspaceLogo;

      notifyListeners();
      // log(response.data.toString());
    } catch (e) {
      log(e.toString());
      updateWorkspaceState = DataState.error;
      notifyListeners();
    }
  }

  Future<bool> deleteWorkspace() async {
    selectWorkspaceState = DataState.loading;
    notifyListeners();
    try {
      await DioClient().request(
        hasAuth: true,
        url: APIs.retrieveWorkspace.replaceAll(
          '\$SLUG',
          selectedWorkspace.workspaceSlug,
        ),
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      selectWorkspaceState = DataState.success;
      await getWorkspaces();
      notifyListeners();
      return true;
      // log(response.data.toString());
    } catch (e) {
      log(e.toString());
      selectWorkspaceState = DataState.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> leaveWorkspace(BuildContext context, WidgetRef ref) async {
    leaveWorspaceState = DataState.loading;
    notifyListeners();
    try {
      await DioClient().request(
        hasAuth: true,
        url: APIs.leaveWorkspace.replaceFirst(
          '\$SLUG',
          selectedWorkspace.workspaceSlug,
        ),
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      leaveWorspaceState = DataState.success;
      await getWorkspaces();
      notifyListeners();
      return true;
    } on DioException catch (e) {
      leaveWorspaceState = DataState.error;
      notifyListeners();
      CustomToast.showToast(context,
          message: e.error == null
              ? 'something went wrong!'
              : (e.error as Map)['error'].toString(),
          toastType: ToastType.failure);
      log(e.error.toString());
      return false;
    }
  }

  Future getWorkspaceMembers() async {
    if (!isAdminOrMember()) return;
    getMembersState = DataState.loading;
    notifyListeners();
    final response = await workspaceService.getWorkspaceMembers(
        url: APIs.getWorkspaceMembers.replaceAll(
      '\$SLUG',
      selectedWorkspace.workspaceSlug,
    ));
    if (response.isLeft()) {
      workspaceMembers = response.fold((l) => l, (r) => []);
      for (final element in workspaceMembers) {
        if (element["member"]['id'] ==
            ref!.read(ProviderList.profileProvider).userProfile.id) {
          role = roleParser(role: element["role"]);
          log('Wokspace-Role: $role');
          break;
        }
      }
      getMembersState = DataState.success;
      notifyListeners();
    } else {
      log(response.fold((l) => l.toString(), (r) => r.error.toString()));
      getMembersState = DataState.error;
      notifyListeners();
    }
  }

  Future getWorkspaceMemberInvitations() async {
    getMembersInvitationsState = DataState.loading;
    notifyListeners();
    final response = await workspaceService.getWorkspaceMembersInvitations(
      url: APIs.pendingInvites.replaceAll(
        '\$SLUG',
        selectedWorkspace.workspaceSlug,
      ),
    );
    if (response.isLeft()) {
      workspaceInvitationsMembers = response.fold((l) => l, (r) => []);
      getMembersInvitationsState = DataState.success;
      notifyListeners();
    } else {
      log(response.fold((l) => l.toString(), (r) => r.error.toString()));
      getMembersInvitationsState = DataState.error;
      notifyListeners();
    }
  }

  Future removeWorkspaceMemberInvitations({required String userId}) async {
    removeMembersInvitationsState = DataState.loading;
    notifyListeners();
    final response = await workspaceService.removeWorkspaceMembersInvitations(
      url: '${APIs.pendingInvites.replaceAll(
        '\$SLUG',
        selectedWorkspace.workspaceSlug,
      )}$userId/',
    );
    response.fold((l) {
      removeMembersInvitationsState = DataState.success;
      notifyListeners();
    }, (r) {
      log(r.error.toString());
      removeMembersInvitationsState = DataState.error;
      notifyListeners();
    });
  }

  Future updateWorkspaceMember(
      {required String userId, required Map data, required CRUD method}) async {
    try {
      final url = '${APIs.getWorkspaceMembers.replaceAll(
        '\$SLUG',
        selectedWorkspace.workspaceSlug,
      )}$userId/';
      await DioClient().request(
          hasAuth: true,
          url: url,
          hasBody: true,
          httpMethod:
              method == CRUD.update ? HttpMethod.patch : HttpMethod.delete,
          data: data);
      getWorkspaceMembers();

      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.error.toString());
        ScaffoldMessenger.of(Const.globalKey.currentContext!).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong, Please try again.'),
          ),
        );
      }
      notifyListeners();
    }
  }

  String? getWorkspaceMemberImage({required String userId}) {
    for (final member in workspaceMembers) {
      if (member['member']['id'] == userId) {
        return member['member']['avatar'];
      }
    }
    return null;
  }

  // Future inviteMembers() async {
  //   selectWorkspaceState = AuthStateEnum.loading;
  //   notifyListeners();
  //   try {
  //     final response = await DioConfig().dioServe(
  //       hasAuth: true,
  //       url: APIs.inviteMembers.replaceAll(
  //         '\$SLUG',
  //         selectedWorkspace.workspaceSlug,
  //       ),
  //       hasBody: true,
  //       data: {"emails": emails},
  //       httpMethod: HttpMethod.post,
  //     );
  //     selectWorkspaceState = AuthStateEnum.success;
  //     log(response.data.toString());
  //     // response = jsonDecode(response.data);

  //     notifyListeners();
  //     // log(response.data.toString());
  //   } catch (e) {
  //     log(e.toString());
  //     selectWorkspaceState = AuthStateEnum.error;
  //     notifyListeners();
  //   }
  // }
}
