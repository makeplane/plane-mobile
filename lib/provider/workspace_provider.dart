import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/models/user_profile_model.dart';
import 'package:plane_startup/models/workspace_model.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/config/apis.dart';
import 'package:plane_startup/services/dio_service.dart';
import 'package:plane_startup/utils/enums.dart';

class WorkspaceProvider extends ChangeNotifier {
  WorkspaceProvider(ChangeNotifierProviderRef<WorkspaceProvider> this.ref);
  Ref? ref;
  TextEditingController invitingMembersRole = TextEditingController();
  var workspaceInvitations = [];
  var workspaces = [];
  String companySize = '';
  WorkspaceModel? selectedWorkspace;
  var urlAvailable = false;
  // var currentWorkspace = {};
  var workspaceMembers = [];
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
  Role role = Role.none;
  void clear() {
    workspaceInvitations = [];
    workspaces = [];
    selectedWorkspace = null;
    urlAvailable = false;
    // currentWorkspace = {};
    checkWorkspaceState = StateEnum.empty;
    joinWorkspaceState = StateEnum.empty;
    createWorkspaceState = StateEnum.empty;
    updateWorkspaceState = StateEnum.empty;
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
      var response = await DioConfig().dioServe(
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
    } catch (e) {
      workspaceInvitationState = StateEnum.error;
      notifyListeners();
    }
  }

  Future joinWorkspaces({required data}) async {
    joinWorkspaceState = StateEnum.loading;
    notifyListeners();

    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: (APIs.joinWorkspace),
        hasBody: true,
        data: {"invitations": data},
        httpMethod: HttpMethod.post,
      );
      joinWorkspaceState = StateEnum.success;
      getWorkspaces();
      log(response.data.toString());
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
      required BuildContext context}) async {
    createWorkspaceState = StateEnum.loading;
    notifyListeners();
    // return;
    try {
      var response = await DioConfig().dioServe(
          hasAuth: true,
          url: APIs.createWorkspace,
          hasBody: true,
          httpMethod: HttpMethod.post,
          data: {"name": name, "slug": slug, "organization_size": size});

      var projectProv = ref!.read(ProviderList.projectProvider);
      var profileProv = ref!.read(ProviderList.profileProvider);
      profileProv.userProfile.lastWorkspaceId = response.data['id'];
      await profileProv.updateProfile(data: {
        "last_workspace_id": response.data['id'],
      });
      await getWorkspaces();
      ref!.read(ProviderList.dashboardProvider).getDashboard();
      projectProv.projects = [];
      projectProv.getProjects(slug: slug);
      createWorkspaceState = StateEnum.success;
      log(response.data.toString());
      notifyListeners();
      return response.statusCode!;
      // return response.data;
    } catch (e) {
      if (e is DioException) {
        log(e.response!.data.toString());
        log(e.message.toString());
        CustomToast().showToast(context, e.response.toString());
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
      var response = await DioConfig().dioServe(
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

  Future inviteToWorkspace({required String slug, required email, role}) async {
    workspaceInvitationState = StateEnum.loading;
    notifyListeners();
    try {
      log(APIs.inviteToWorkspace.replaceAll('\$SLUG', slug));
      log(role == null ? "ROLE NULL" : "ROLE NOT NULL");
      var response = await DioConfig().dioServe(
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
      log(response.data.toString());
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
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.listWorkspaces,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      workspaceInvitationState = StateEnum.success;
      workspaces = response.data;

      var isWorkspacePresent = workspaces.where((element) {
        if (element['id'] ==
            ref!
                .read(ProviderList.profileProvider)
                .userProfile
                .lastWorkspaceId) {
          // currentWorkspace = element;

          selectedWorkspace = WorkspaceModel.fromJson(element);
          tempLogo = selectedWorkspace!.workspaceLogo;

          return true;
        }
        return false;
      });

      if (isWorkspacePresent.isEmpty) {
        // currentWorkspace = workspaces[0];
        selectedWorkspace = WorkspaceModel.fromJson(workspaces[0]);
        log('AFTER DELETE WORKSPACE ${selectedWorkspace!.workspaceName} }');
      }

      getWorkspaceMembers();

      log('SELECTED WORKSPACE ${selectedWorkspace!.workspaceName}');
      notifyListeners();
    } catch (e) {
      log(e.toString());
      workspaceInvitationState = StateEnum.error;
      notifyListeners();
    }
  }

  Future selectWorkspace({required String id}) async {
    selectWorkspaceState = StateEnum.loading;
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.baseApi + APIs.profile,
        hasBody: true,
        data: {"last_workspace_id": id},
        httpMethod: HttpMethod.patch,
      );
      selectWorkspaceState = StateEnum.success;
      ref!.read(ProviderList.profileProvider).userProfile =
          UserProfile.fromMap(response.data);

      ref!.read(ProviderList.profileProvider).userProfile.lastWorkspaceId = id;

      ref!.read(ProviderList.issuesProvider).clearData();

      // currentWorkspace = workspaces.where((element) {
      //   if (element['id'] ==
      //       ref!
      //           .read(ProviderList.profileProvider)
      //           .userProfile
      //           .last_workspace_id) {
      //     currentWorkspace = element;
      //     return true;
      //   }
      //   return false;
      // }).first;
      selectedWorkspace = WorkspaceModel.fromJson(
          workspaces.where((element) => element['id'] == id).first);
      ref!.read(ProviderList.dashboardProvider).getDashboard();
      role = Role.none;
      getWorkspaceMembers();

      tempLogo = selectedWorkspace!.workspaceLogo;

      // ref!.read(ProviderList.projectProvider).getProjects(
      //         slug: currentWorkspace['slug']);
      // ref!.read(ProviderList.projectProvider).favouriteProjects(
      //     index: 0,
      //     slug: currentWorkspace['slug'],
      //     method: HttpMethod.get,
      //     projectID: "");
      log(response.data.toString());
      notifyListeners();
      // return response.data;
    } on DioException catch (e) {
      log(e.toString());
      selectWorkspaceState = StateEnum.error;
      notifyListeners();
    }
  }

  Future retrieveWorkspace({required String slug}) async {
    selectWorkspaceState = StateEnum.loading;
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.retrieveWorkspace.replaceAll('\$SLUG', slug),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      selectWorkspaceState = StateEnum.success;
      log(response.data.toString());
      // response = jsonDecode(response.data);
      selectedWorkspace = WorkspaceModel.fromJson(response.data);
      tempLogo = selectedWorkspace!.workspaceLogo;

      log('SELECTED WORKSPACE ${selectedWorkspace!.workspaceName}');

      notifyListeners();
      // log(response.data.toString());
    } catch (e) {
      log(e.toString());
      selectWorkspaceState = StateEnum.error;
      notifyListeners();
    }
  }

  Future updateWorkspace({required data}) async {
    updateWorkspaceState = StateEnum.loading;
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.retrieveWorkspace.replaceAll(
          '\$SLUG',
          selectedWorkspace!.workspaceSlug,
        ),
        hasBody: true,
        data: data,
        httpMethod: HttpMethod.patch,
      );
      updateWorkspaceState = StateEnum.success;
      log(response.data.toString());
      // response = jsonDecode(response.data);
      selectedWorkspace = WorkspaceModel.fromJson(response.data);
      tempLogo = selectedWorkspace!.workspaceLogo;

      log('SELECTED WORKSPACE');
      log(selectedWorkspace!.toString());

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
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.retrieveWorkspace.replaceAll(
          '\$SLUG',
          selectedWorkspace!.workspaceSlug,
        ),
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      selectWorkspaceState = StateEnum.success;
      log(response.data.toString());
      await getWorkspaces();

      // response = jsonDecode(response.data);

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

  Future getWorkspaceMembers() async {
    getMembersState = StateEnum.loading;
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.getWorkspaceMembers.replaceAll(
          '\$SLUG',
          selectedWorkspace!.workspaceSlug,
        ),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      getMembersState = StateEnum.success;
      // log(response.data.toString());
      workspaceMembers = response.data;
      for (var element in workspaceMembers) {
        if (element["member"]['id'] ==
            ref!.read(ProviderList.profileProvider).userProfile.id) {
          role = roleParser(role: element["role"]);
          log('Role $role');
          break;
        }
      }
      // response = jsonDecode(response.data);

      notifyListeners();
      // log(response.data.toString());
    } catch (e) {
      log(e.toString());
      getMembersState = StateEnum.error;
      notifyListeners();
    }
  }

  Future updateWorkspaceMember(
      {required String userId, required Map data, required CRUD method}) async {
    try {
      var url = '${APIs.getWorkspaceMembers.replaceAll(
        '\$SLUG',
        selectedWorkspace!.workspaceSlug,
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
  //     var response = await DioConfig().dioServe(
  //       hasAuth: true,
  //       url: APIs.inviteMembers.replaceAll(
  //         '\$SLUG',
  //         selectedWorkspace!.workspaceSlug,
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
