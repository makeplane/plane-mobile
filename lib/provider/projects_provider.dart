// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/kanban/models/project_detail_model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/repository/projects_service.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/core/dio/dio_service.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/global_functions.dart';

class ProjectsProvider extends ChangeNotifier {
  ProjectsProvider(ChangeNotifierProviderRef<ProjectsProvider> this.ref);
  final Ref ref;
  List projects = [];
  List starredProjects = [];
  DataState joinprojectState = DataState.empty;
  DataState getProjectState = DataState.empty;
  DataState projectState = DataState.empty;
  DataState unsplashImageState = DataState.empty;
  DataState createProjectState = DataState.empty;
  DataState projectDetailState = DataState.empty;
  DataState projectMembersState = DataState.empty;
  DataState deleteProjectState = DataState.empty;
  DataState leaveProjectState = DataState.empty;
  DataState updateProjectMemberState = DataState.empty;
  DataState updateProjectState = DataState.empty;
  DataState stateCrudState = DataState.empty;
  DataState projectLabelsState = DataState.empty;
  DataState projectInvitationState = DataState.empty;
  List unsplashImages = [];
  Map currentProject = {};
  List projectMembers = [];
  Role role = Role.none;
  String coverUrl =
      "https://app.plane.so/_next/image?url=https%3A%2F%2Fimages.unsplash.com%2Fphoto-1575116464504-9e7652fddcb3%3Fcrop%3Dentropy%26cs%3Dtinysrgb%26fit%3Dmax%26fm%3Djpg%26ixid%3DMnwyODUyNTV8MHwxfHNlYXJjaHwxOHx8cGxhbmV8ZW58MHx8fHwxNjgxNDY4NTY5%26ixlib%3Drb-4.0.3%26q%3D80%26w%3D1080&w=1920&q=75";
  ProjectDetailModel? currentprojectDetails;

  TextEditingController lead = TextEditingController();
  TextEditingController assignee = TextEditingController();
  int memberCount = 0;
  List<int> loadingProjectIndex = [];
  List features = [
    {'title': 'Issues', 'width': 60, 'show': true},
    {'title': 'Cycles', 'width': 60, 'show': true},
    {'title': 'Modules', 'width': 75, 'show': true},
    {'title': 'Views', 'width': 60, 'show': true},
    // {'title': 'Pages', 'width': 50, 'show': false},
  ];

  void clear() {
    projects = [];
    starredProjects = [];
    projectState = DataState.empty;
    unsplashImageState = DataState.empty;
    createProjectState = DataState.empty;
    projectDetailState = DataState.empty;
    deleteProjectState = DataState.empty;
    updateProjectMemberState = DataState.empty;
    updateProjectState = DataState.empty;
    stateCrudState = DataState.empty;
    leaveProjectState = DataState.empty;
    unsplashImages = [];
    currentProject = {};
    loadingProjectIndex = [];

    coverUrl = "";
    currentprojectDetails = null;
    memberCount = 0;
    lead.clear();
    assignee.clear();
  }

  String get currentProjectId => currentProject['id'];

  void setState() {
    notifyListeners();
  }

  void changeCoverUrl({required String url}) {
    coverUrl = url;
    notifyListeners();
  }

  Future<void> initializeProject(String projectId) async {
    final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
    final projectIssuesNotifier =
        ref.read(ProviderList.projectIssuesProvider.notifier);
    await getProjectDetails(slug: workspaceSlug, projId: projectId);
    getProjectMembers(
      slug: workspaceSlug,
      projId: currentprojectDetails!.id!,
    );
    ref.read(ProviderList.statesProvider.notifier).getStates();
    ref.read(ProviderList.estimatesProvider).getEstimates(
          slug: workspaceSlug,
          projID: currentprojectDetails!.id!,
        );
    projectIssuesNotifier.fetchLayoutProperties().then((value) {
      projectIssuesNotifier.fetchIssues();
    });
  }

  Future joinProject(
      {String? projectId, String? slug, required WidgetRef refs}) async {
    try {
      joinprojectState = DataState.loading;
      notifyListeners();
      await DioClient().request(
          hasAuth: true,
          url: APIs.joinProject.replaceAll("\$SLUG", slug!),
          hasBody: true,
          httpMethod: HttpMethod.post,
          data: {
            "project_ids": [projectId]
          });
      joinprojectState = DataState.success;
      // updating local projects List
      projects[currentProject["index"]]["is_member"] = true;
      notifyListeners();
    } on DioException catch (e) {
      log(e.message.toString());
      joinprojectState = DataState.error;
      notifyListeners();
    }
  }

  Future getProjects({required String slug, bool loading = true}) async {
    if (loading) {
      getProjectState = DataState.loading;
      notifyListeners();
    }
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: APIs.listProjects.replaceAll('\$SLUG', slug),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      projects = response.data;
      for (int i = 0; i < projects.length; i++) {
        if (projects[i]['is_member'] == true) {
          memberCount++;
        }
      }
      getProjectState = DataState.success;
      notifyListeners();
      // log(response.data.toString());
    } on DioException catch (e) {
      log(e.error.toString());
      getProjectState = DataState.error;
      notifyListeners();
    }
  }

  Future favouriteProjects(
      {required String slug,
      required HttpMethod method,
      required String projectID,
      required int index}) async {
    projectState = DataState.loading;
    if (!loadingProjectIndex.contains(index)) {
      loadingProjectIndex.add(index);
    }
    notifyListeners();
    try {
      log(APIs.favouriteProjects.replaceAll('\$SLUG', slug) + projectID);
      final response = await DioClient().request(
        hasAuth: true,
        url: method == HttpMethod.delete
            ? '${APIs.favouriteProjects.replaceAll('\$SLUG', slug)}$projectID/'
            : APIs.favouriteProjects.replaceAll('\$SLUG', slug),
        hasBody: method == HttpMethod.post ? true : false,
        data: method == HttpMethod.post
            ? {
                "project": projectID,
              }
            : null,
        httpMethod: method,
      );
      if (method == HttpMethod.post) {
        // projects.removeAt(index);

        // When all projects are added to favorites at the same time, last element will have index
        // out of range error becuase the project is removed and the last index wont be available untill
        // getProjects method called
        starredProjects.add(response.data);
      } else if (method == HttpMethod.get) {
        starredProjects = response.data;
      } else {
        // projects.add(starredProjects.removeAt(index)['project_detail']);
      }
      await getProjects(slug: slug, loading: false);
      projectState = DataState.success;
      loadingProjectIndex.remove(index);
      notifyListeners();
      // log(response.data.toString());
    } on DioException catch (e) {
      log("ERROR=${e.response}");
      projectState = DataState.error;
      loadingProjectIndex.remove(index);
      notifyListeners();
    }
  }

  Future inviteToProject({
    required BuildContext context,
    required String slug,
    required String projId,
    required Map data,
  }) async {
    projectInvitationState = DataState.loading;
    notifyListeners();
    try {
      log(data.toString());
      await DioClient().request(
        hasAuth: true,
        url: APIs.inviteToProject.replaceAll('\$SLUG', slug).replaceAll(
              '\$PROJECTID',
              projId,
            ),
        hasBody: true,
        data: data,
        httpMethod: HttpMethod.post,
      );
      // log(response.data.toString());
      projectInvitationState = DataState.success;
      notifyListeners();
      // log(response.data.toString());
    } on DioException catch (e) {
      log('Project Invite Error =  ${e.message}');
      log(e.error.toString());
      CustomToast.showToast(context,
          message: e.message == null
              ? 'something went wrong!'
              : e.message.toString(),
          toastType: ToastType.failure);
      projectInvitationState = DataState.error;
      notifyListeners();
    }
  }

  Future createProjects(
      {required String slug,
      required Map data,
      WidgetRef? ref,
      BuildContext? context}) async {
    createProjectState = DataState.loading;
    final workspaceProvider = ref!.read(ProviderList.workspaceProvider);
    final profileProvider = ref.read(ProviderList.profileProvider);
    notifyListeners();
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: APIs.createProjects.replaceAll('\$SLUG', slug),
        hasBody: true,
        data: data,
        httpMethod: HttpMethod.post,
      );
      postHogService(
          eventName: 'CREATE_PROJECT',
          properties: {
            'WORKSPACE_ID': workspaceProvider.selectedWorkspace.workspaceId,
            'WORKSPACE_NAME': workspaceProvider.selectedWorkspace.workspaceName,
            'WORKSPACE_SLUG': workspaceProvider.selectedWorkspace.workspaceSlug,
            'PROJECT_ID': response.data['id'],
            'PROJECT_NAME': response.data['name']
          },
          userEmail: profileProvider.userProfile.email!,
          userID: profileProvider.userProfile.id!);
      await getProjects(slug: slug);
      createProjectState = DataState.success;
      notifyListeners();
      // log(response.data.toString());
    } on DioException catch (e) {
      if (context != null) {
        CustomToast.showToast(context,
            message: 'Identifier already exists', toastType: ToastType.failure);
      }

      log(e.error.toString());
      createProjectState = DataState.error;
      notifyListeners();
    }
  }

  Future<bool> checkIdentifierAvailability({
    required String slug,
    required String identifier,
  }) async {
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: APIs.projectIdentifier
            .replaceAll(
              '\$SLUG',
              slug,
            )
            .replaceAll("\$IDENTIFIER", identifier),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      return response.data['exists'] == 0;
    } on DioException catch (e) {
      log(e.error.toString());
    }
    return false;
  }

  Future getProjectDetails(
      {required String slug, required String projId}) async {
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: "${APIs.listProjects.replaceAll('\$SLUG', slug)}$projId/",
        hasBody: false,
        httpMethod: HttpMethod.get,
      );

      currentprojectDetails = ProjectDetailModel.fromMap(response.data);
      features[1]['show'] = currentprojectDetails!.cycleView ?? true;
      features[2]['show'] = currentprojectDetails!.moduleView ?? true;
      features[3]['show'] = currentprojectDetails!.issueViewsView ?? true;
      // features[4]['show'] = projectDetailModel!.pageView ?? true;

      getProjectMembers(slug: slug, projId: projId);
      projectDetailState = DataState.success;
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.error.toString());
      }
      log(e.toString());
      projectDetailState = DataState.error;
      notifyListeners();
    }
  }

  Future updateProject(
      {required String slug,
      required String projId,
      required Map data,
      required WidgetRef ref}) async {
    updateProjectState = DataState.loading;
    final workspaceProvider = ref.read(ProviderList.workspaceProvider);
    final profileProvider = ref.read(ProviderList.profileProvider);
    notifyListeners();
    log("${APIs.listProjects.replaceAll('\$SLUG', slug)}$projId/");
    try {
      final response = await DioClient().request(
          hasAuth: true,
          url: "${APIs.listProjects.replaceAll('\$SLUG', slug)}$projId/",
          hasBody: true,
          httpMethod: HttpMethod.patch,
          data: data);
      final defaultAssignee = currentprojectDetails!.defaultAssignee;
      final projectLead = currentprojectDetails!.projectLead;
      currentprojectDetails = ProjectDetailModel.fromMap(response.data);
      currentprojectDetails!.defaultAssignee = defaultAssignee;
      currentprojectDetails!.projectLead = projectLead;
      final int index = currentProject["index"];
      currentProject = currentprojectDetails!.toJson();
      currentProject["index"] = index;
      projects[index]["name"] = currentProject["name"];
      projects[index]["description"] = currentProject["description"];
      projects[index]["identifier"] = currentProject["identifier"];
      projects[index]["emoji"] = currentProject["emoji"];
      projects[index]['estimate'] = currentProject['estimate'];

      projects[index]["icon_prop"] = currentProject["icon_prop"] != null
          ? {
              'name': currentProject["icon_prop"]["name"],
              'color': currentProject["icon_prop"]["color"],
            }
          : null;
      updateProjectState = DataState.success;
      postHogService(
          eventName: 'UPDATE_PROJECT',
          properties: {
            'WORKSPACE_ID': workspaceProvider.selectedWorkspace.workspaceId,
            'WORKSPACE_NAME': workspaceProvider.selectedWorkspace.workspaceName,
            'WORKSPACE_SLUG': workspaceProvider.selectedWorkspace.workspaceSlug,
            'PROJECT_ID': response.data['id'],
            'PROJECT_NAME': response.data['name']
          },
          userEmail: profileProvider.userProfile.email!,
          userID: profileProvider.userProfile.id!);
      notifyListeners();
    } on DioException catch (e) {
      log(e.toString());
      updateProjectState = DataState.error;
      notifyListeners();
    }
  }

  Future updateProjectLead(
      {required String leadId,
      required int index,
      required WidgetRef ref}) async {
    try {
      final slug = ref
          .read(ProviderList.workspaceProvider)
          .selectedWorkspace
          .workspaceSlug;
      final projId = currentProject['id'];
      final data = {
        'project_lead': leadId == projectMembers[index]['member']['id']
            ? null
            : projectMembers[index]['member']['id'],
      };
      await updateProject(slug: slug, projId: projId, data: data, ref: ref);
      await getProjectDetails(slug: slug, projId: projId);
      lead.text = currentprojectDetails!.projectLead == null
          ? ''
          : currentprojectDetails!.projectLead!['display_name'];

      notifyListeners();
    } on DioException catch (e) {
      log(e.toString());
      notifyListeners();
    }
  }

  Future updateProjectAssignee({
    required String assigneeId,
    required int index,
    required WidgetRef ref,
  }) async {
    try {
      final slug = ref
          .read(ProviderList.workspaceProvider)
          .selectedWorkspace
          .workspaceSlug;
      final projId = currentProject['id'];
      final data = {
        'default_assignee': assigneeId == projectMembers[index]['member']['id']
            ? null
            : projectMembers[index]['member']['id'],
      };
      await updateProject(slug: slug, projId: projId, data: data, ref: ref);
      await getProjectDetails(slug: slug, projId: projId);
      assignee.text = currentprojectDetails!.defaultAssignee == null
          ? ''
          : currentprojectDetails!.defaultAssignee!['display_name'];

      notifyListeners();
    } on DioException catch (e) {
      notifyListeners();
      log(e.toString());
    }
  }

  Future getProjectMembers({
    required String slug,
    required String projId,
  }) async {
    // projectDetailState = AuthStateEnum.loading;
    // notifyListeners();
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: APIs.projectMembers
            .replaceFirst('\$SLUG', slug)
            .replaceFirst('\$PROJECTID', projId),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      projectMembers = response.data;

      for (final element in projectMembers) {
        for (final workspace
            in ref.watch(ProviderList.workspaceProvider).workspaceMembers) {
          if (element['member'] == workspace['member']['id']) {
            // Replace the map in projectMembers with the one from workspaceMembers
            projectMembers[projectMembers.indexOf(element)] = workspace;
          }
          if (element["member"] ==
              ref.read(ProviderList.profileProvider).userProfile.id) {
            role = roleParser(role: element["role"]);
          }
        }
      }
      projectMembersState = DataState.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.error.toString());
      projectMembersState = DataState.error;
      notifyListeners();
    }
  }

  String? getProjectMemberImage({required String userId}) {
    for (final member in projectMembers) {
      if (member['member']['id'] == userId) {
        return member['member']['avatar'];
      }
    }
    return null;
  }

  Future deleteProject({required String slug, required String projId}) async {
    try {
      deleteProjectState = DataState.loading;
      notifyListeners();
      await DioClient().request(
        hasAuth: true,
        url: "${APIs.listProjects.replaceAll('\$SLUG', slug)}$projId/",
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      deleteProjectState = DataState.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.error.toString());
      deleteProjectState = DataState.error;
      notifyListeners();
    }
  }

  Future<bool> leaveProject(
      {required String slug,
      required String projId,
      required int index,
      required BuildContext context}) async {
    try {
      leaveProjectState = DataState.loading;
      notifyListeners();
      await DioClient().request(
        hasAuth: true,
        url: APIs.leaveProject
            .replaceFirst('\$SLUG', slug)
            .replaceFirst('\$PROJECTID', projId),
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      leaveProjectState = DataState.success;
      getProjects(slug: slug);
      notifyListeners();
      return true;
    } on DioException catch (e) {
      log(e.error.toString());
      CustomToast.showToast(context,
          message: (e.error as Map)['error'].toString(),
          toastType: ToastType.failure,
          duration: 5);
      leaveProjectState = DataState.error;
      notifyListeners();
      return false;
    }
  }

  Future updateProjectMember(
      {required String slug,
      required String projId,
      required String userId,
      required CRUD method,
      required Map data}) async {
    try {
      final url =
          '${APIs.projectMembers.replaceFirst('\$SLUG', slug).replaceFirst('\$PROJECTID', projId)}$userId/';
      updateProjectMemberState = DataState.loading;
      notifyListeners();
      await DioClient().request(
          hasAuth: true,
          url: url,
          hasBody: method == CRUD.update ? true : false,
          httpMethod:
              method == CRUD.update ? HttpMethod.patch : HttpMethod.delete,
          data: data);
      getProjectMembers(slug: slug, projId: projId);
      updateProjectMemberState = DataState.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.message.toString());
      updateProjectMemberState = DataState.error;
      notifyListeners();
    }
  }

  Future getUnsplashImages() async {
    unsplashImageState = DataState.loading;
    notifyListeners();
    final response = await ProjectsService().getUnspalshImages();
    response.fold((images) {
      // unsplashImages = images;
      unsplashImageState = DataState.success;
      notifyListeners();
    }, (err) {
      unsplashImageState = DataState.error;
      notifyListeners();
    });
  }
}
