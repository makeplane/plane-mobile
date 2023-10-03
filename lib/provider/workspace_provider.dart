// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/const.dart';
import 'package:plane/models/workspace_model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/services/dio_service.dart';
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
  String tempLogo = '';
  WorkspaceModel? workspace;
  StateEnum workspaceInvitationState = StateEnum.empty;
  StateEnum checkWorkspaceState = StateEnum.empty;
  StateEnum selectWorkspaceState = StateEnum.empty;
  StateEnum uploadImageState = StateEnum.empty;
  StateEnum getMembersState = StateEnum.empty;
  StateEnum joinWorkspaceState = StateEnum.empty;
  StateEnum createWorkspaceState = StateEnum.empty;
  StateEnum updateWorkspaceState = StateEnum.empty;
  StateEnum leaveWorspaceState = StateEnum.empty;
  Role role = Role.none;
  void clear() {
    workspaceInvitations = [];
    workspaces = [];
    workspaceIntegrations = [];
    selectedWorkspace = WorkspaceModel.initialize();
    urlAvailable = false;
    // currentWorkspace = {};
    checkWorkspaceState = StateEnum.empty;
    joinWorkspaceState = StateEnum.empty;
    createWorkspaceState = StateEnum.empty;
    updateWorkspaceState = StateEnum.empty;
    leaveWorspaceState = StateEnum.empty;
    workspaceMembers = [];
  }

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
    workspaceInvitationState = StateEnum.loading;
    notifyListeners();
    try {
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.baseApi + APIs.listWorkspaceInvitaion,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      workspaceInvitationState = StateEnum.success;
      workspaceInvitations = response.data;
      //log(response.data.toString());
      notifyListeners();
      // return response.data;
    } on DioException catch (e) {
      log(e.error.toString());
      workspaceInvitationState = StateEnum.error;
      notifyListeners();
    }
  }

  Future joinWorkspaces({required List data}) async {
    joinWorkspaceState = StateEnum.loading;
    notifyListeners();

    try {
      await DioConfig().dioServe(
        hasAuth: true,
        url: (APIs.joinWorkspace),
        hasBody: true,
        data: {"invitations": data},
        httpMethod: HttpMethod.post,
      );
      joinWorkspaceState = StateEnum.success;
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
      joinWorkspaceState = StateEnum.error;
      notifyListeners();
    }
  }

  Future createWorkspace(
      {required String name,
      required String slug,
      required String size,
      required WidgetRef refs,
      required BuildContext context}) async {
    createWorkspaceState = StateEnum.loading;
    notifyListeners();
    // return;
    try {
      final response = await DioConfig().dioServe(
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
          ref: refs);
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
      createWorkspaceState = StateEnum.success;
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
      createWorkspaceState = StateEnum.error;
      notifyListeners();
    }
  }

  Future checkWorspaceSlug({required String slug}) async {
    checkWorkspaceState = StateEnum.loading;
    notifyListeners();
    try {
      final response = await DioConfig().dioServe(
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
      checkWorkspaceState = StateEnum.success;
      notifyListeners();
      return urlAvailable;
    } catch (e) {
      if (e is DioException) {
        //  log(e.response.data.toString());
        log(e.message.toString());
      }
      log(e.toString());
      checkWorkspaceState = StateEnum.error;
      notifyListeners();
    }
  }

  Future inviteToWorkspace(
      // ignore: type_annotate_public_apis
      {required String slug,
      // ignore: type_annotate_public_apis
      required email,
      String? role}) async {
    workspaceInvitationState = StateEnum.loading;
    notifyListeners();
    try {
      log(APIs.inviteToWorkspace.replaceAll('\$SLUG', slug));
      log(role == null ? "ROLE NULL" : "ROLE NOT NULL");
      await DioConfig().dioServe(
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
      workspaceInvitationState = StateEnum.success;
      notifyListeners();
      return !urlAvailable;
    } on DioException catch (e) {
      log(e.response!.data.toString());
      log(e.message.toString());
      workspaceInvitationState = StateEnum.error;
      notifyListeners();
    } catch (e) {
      log(e.toString());
      workspaceInvitationState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getWorkspaces() async {
    workspaceInvitationState = StateEnum.loading;
    final response = await workspaceService.getWorkspaces();
    if (response.isLeft()) {
      workspaces = response.fold((l) => l, (r) => []);

      final isWorkspacePresent = workspaces.where((element) {
        if (element['id'] ==
            ref!
                .read(ProviderList.profileProvider)
                .userProfile
                .lastWorkspaceId) {
          selectedWorkspace = WorkspaceModel.fromJson(element);
          tempLogo = selectedWorkspace.workspaceLogo;
          return true;
        }
        return false;
      });

      final projectProv = ref!.read(ProviderList.projectProvider);
      final myissuesProv = ref!.read(ProviderList.myIssuesProvider);

      if (isWorkspacePresent.isEmpty) {
        if (workspaces.isEmpty) {
          workspaceInvitationState = StateEnum.error;
          notifyListeners();
          return;
        }
        selectedWorkspace = WorkspaceModel.fromJson(workspaces[0]);
        final slug = selectedWorkspace.workspaceSlug;
        log('AFTER DELETE WORKSPACE ${selectedWorkspace.workspaceName} }');
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
        createWorkspaceState = StateEnum.success;
        notifyListeners();
      }

      getWorkspaceMembers();
      retrieveWorkspaceIntegration(slug: selectedWorkspace.workspaceSlug);
      workspaceInvitationState = StateEnum.success;
      notifyListeners();
      return selectedWorkspace;
    } else {
      log(response.fold((l) => l.toString(), (r) => r.error.toString()));
      workspaceInvitationState = StateEnum.error;
      notifyListeners();
    }
  }

  Future<Either<WorkspaceModel, DioException>> selectWorkspace(
      {required BuildContext context, required String id}) async {
    selectWorkspaceState = StateEnum.loading;
    notifyListeners();
    final profileProv = ref!.read(ProviderList.profileProvider);
    final response =
        await profileProv.updateProfile(data: {"last_workspace_id": id});
    if (response.isLeft()) {
      ref!.read(ProviderList.issuesProvider).clearData();
      selectedWorkspace = WorkspaceModel.fromJson(
          workspaces.where((element) => element['id'] == id).first);
      ref!.read(ProviderList.dashboardProvider).getDashboard();
      role = Role.none;
      getWorkspaceMembers();
      tempLogo = selectedWorkspace.workspaceLogo;
      retrieveWorkspaceIntegration(slug: selectedWorkspace.workspaceSlug);
      selectWorkspaceState = StateEnum.success;
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
      selectWorkspaceState = StateEnum.error;
      notifyListeners();
      return Right(error);
    }
  }

  Future retrieveWorkspace({required String slug}) async {
    selectWorkspaceState = StateEnum.loading;
    notifyListeners();
    try {
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.retrieveWorkspace.replaceAll('\$SLUG', slug),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      selectWorkspaceState = StateEnum.success;
      log(response.data.toString());
      // response = jsonDecode(response.data);
      selectedWorkspace = WorkspaceModel.fromJson(response.data);
      tempLogo = selectedWorkspace.workspaceLogo;
      await retrieveWorkspaceIntegration(slug: selectedWorkspace.workspaceSlug);

      notifyListeners();
      // log(response.data.toString());
    } catch (e) {
      log(e.toString());
      selectWorkspaceState = StateEnum.error;
      notifyListeners();
    }
  }

  Future retrieveWorkspaceIntegration({required String slug}) async {
    //selectWorkspaceState = StateEnum.loading;
    githubIntegration = null;
    slackIntegration = null;
    //notifyListeners();
    try {
      final response = await DioConfig().dioServe(
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
    updateWorkspaceState = StateEnum.loading;
    notifyListeners();
    try {
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.retrieveWorkspace.replaceAll(
          '\$SLUG',
          selectedWorkspace.workspaceSlug,
        ),
        hasBody: true,
        data: data,
        httpMethod: HttpMethod.patch,
      );
      updateWorkspaceState = StateEnum.success;
      postHogService(
          eventName: 'UPDATE_WORKSPACE',
          properties: {
            'WORKSPACE_ID': response.data['id'],
            'WORKSPACE_NAME': response.data['name'],
            'WORKSPACE_SLUG': response.data['slug']
          },
          ref: ref);
      selectedWorkspace = WorkspaceModel.fromJson(response.data);
      tempLogo = selectedWorkspace.workspaceLogo;

      notifyListeners();
      // log(response.data.toString());
    } catch (e) {
      log(e.toString());
      updateWorkspaceState = StateEnum.error;
      notifyListeners();
    }
  }

  Future<bool> deleteWorkspace() async {
    selectWorkspaceState = StateEnum.loading;
    notifyListeners();
    try {
      await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.retrieveWorkspace.replaceAll(
          '\$SLUG',
          selectedWorkspace.workspaceSlug,
        ),
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      selectWorkspaceState = StateEnum.success;
      await getWorkspaces();
      notifyListeners();
      return true;
      // log(response.data.toString());
    } catch (e) {
      log(e.toString());
      selectWorkspaceState = StateEnum.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> leaveWorkspace(BuildContext context, WidgetRef ref) async {
    leaveWorspaceState = StateEnum.loading;
    notifyListeners();
    try {
      await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.leaveWorkspace.replaceFirst(
          '\$SLUG',
          selectedWorkspace.workspaceSlug,
        ),
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      leaveWorspaceState = StateEnum.success;
      await getWorkspaces();
      notifyListeners();
      return true;
    } on DioException catch (e) {
      leaveWorspaceState = StateEnum.error;
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
    getMembersState = StateEnum.loading;
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
      getMembersState = StateEnum.success;
      notifyListeners();
    } else {
      log(response.fold((l) => l.toString(), (r) => r.error.toString()));
      getMembersState = StateEnum.error;
      notifyListeners();
    }
  }

  Future updateWorkspaceMember(
      {required String userId, required Map data, required CRUD method}) async {
    try {
      final url = '${APIs.getWorkspaceMembers.replaceAll(
        '\$SLUG',
        selectedWorkspace.workspaceSlug,
      )}$userId/';
      await DioConfig().dioServe(
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
