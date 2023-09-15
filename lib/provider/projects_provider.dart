// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/kanban/models/project_detail_model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/global_functions.dart';

import '../models/issues.dart';

class ProjectsProvider extends ChangeNotifier {
  ProjectsProvider(ChangeNotifierProviderRef<ProjectsProvider> this.ref);
  final Ref ref;
  var projects = [];
  var starredProjects = [];
  var joinprojectState = StateEnum.empty;
  var projectState = StateEnum.empty;
  var unsplashImageState = StateEnum.empty;
  var createProjectState = StateEnum.empty;
  var projectDetailState = StateEnum.empty;
  var projectMembersState = StateEnum.empty;
  var deleteProjectState = StateEnum.empty;
  var leaveProjectState = StateEnum.empty;
  var updateProjectMemberState = StateEnum.empty;
  var updateProjectState = StateEnum.empty;
  var stateCrudState = StateEnum.empty;
  var projectLabelsState = StateEnum.empty;
  var projectInvitationState = StateEnum.empty;
  var unsplashImages = [];
  var currentProject = {};
  List projectMembers = [];
  Role role = Role.none;
  var coverUrl =
      "https://app.plane.so/_next/image?url=https%3A%2F%2Fimages.unsplash.com%2Fphoto-1575116464504-9e7652fddcb3%3Fcrop%3Dentropy%26cs%3Dtinysrgb%26fit%3Dmax%26fm%3Djpg%26ixid%3DMnwyODUyNTV8MHwxfHNlYXJjaHwxOHx8cGxhbmV8ZW58MHx8fHwxNjgxNDY4NTY5%26ixlib%3Drb-4.0.3%26q%3D80%26w%3D1080&w=1920&q=75";
  ProjectDetailModel? projectDetailModel;

  TextEditingController lead = TextEditingController();
  TextEditingController assignee = TextEditingController();
  int memberCount = 0;

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
    projectState = StateEnum.empty;
    unsplashImageState = StateEnum.empty;
    createProjectState = StateEnum.empty;
    projectDetailState = StateEnum.empty;
    deleteProjectState = StateEnum.empty;
    updateProjectMemberState = StateEnum.empty;
    updateProjectState = StateEnum.empty;
    stateCrudState = StateEnum.empty;
    leaveProjectState = StateEnum.empty;
    unsplashImages = [];
    currentProject = {};

    coverUrl =
        "https://app.plane.so/_next/image?url=https%3A%2F%2Fimages.unsplash.com%2Fphoto-1575116464504-9e7652fddcb3%3Fcrop%3Dentropy%26cs%3Dtinysrgb%26fit%3Dmax%26fm%3Djpg%26ixid%3DMnwyODUyNTV8MHwxfHNlYXJjaHwxOHx8cGxhbmV8ZW58MHx8fHwxNjgxNDY4NTY5%26ixlib%3Drb-4.0.3%26q%3D80%26w%3D1080&w=1920&q=75";
    projectDetailModel = null;
    memberCount = 0;
    lead.clear();
    assignee.clear();
  }

  void setState() {
    notifyListeners();
  }

  Future initializeProject(
      {Filters? filters,
      bool fromViews = false,
      required WidgetRef ref}) async {
    var prov = ref.read(ProviderList.issuesProvider);
    var moduleProv = ref.read(ProviderList.modulesProvider);
    var viewsProvider = ref.read(ProviderList.viewsProvider.notifier);
    var intergrationProvider = ref.read(ProviderList.integrationProvider);
    var workspaceProvider = ref.read(ProviderList.workspaceProvider);
    var pageProv = ref.read(ProviderList.pageProvider);
    if (currentProject['estimate'] != null &&
        currentProject['estimate'] != '') {
      // prov.issues.displayProperties.estimate = true;
    }
    String workspaceSlug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace!
        .workspaceSlug;

    prov.getStates(slug: workspaceSlug, projID: currentProject['id']);
    prov.getProjectMembers(
      slug: workspaceSlug,
      projID: currentProject['id'],
    );
    ref.read(ProviderList.estimatesProvider).getEstimates(
          slug: workspaceSlug,
          projID: currentProject['id'],
        );
    prov.getIssueProperties(issueCategory: IssueCategory.issues);
    prov.getProjectView().then((value) {
      if (filters != null) {
        prov.issues.filters = filters;
      }
      prov.filterIssues(
        fromViews: fromViews,
        slug: workspaceSlug,
        projID: currentProject['id'],
      );
    });
    moduleProv.getModules(
      disableLoading: true,
      slug: workspaceSlug,
      projId: currentProject['id'],
    );
    viewsProvider.getViews();

    prov.getLabels(slug: workspaceSlug, projID: currentProject['id']);

    getProjectDetails(slug: workspaceSlug, projId: currentProject['id']);

    var cyclesProv = ref.read(ProviderList.cyclesProvider);
    var projectID = currentProject['id'];
    cyclesProv.cyclesState = StateEnum.loading;

    cyclesProv.cyclesCrud(
        slug: workspaceSlug,
        projectId: projectID,
        method: CRUD.read,
        query: 'all',
        ref: ref,
        cycleId: '');
    cyclesProv.cyclesCrud(
        slug: workspaceSlug,
        projectId: projectID,
        method: CRUD.read,
        query: 'current',
        cycleId: '',
        ref: ref);
    cyclesProv.cyclesCrud(
        slug: workspaceSlug,
        projectId: projectID,
        method: CRUD.read,
        query: 'upcoming',
        cycleId: '',
        ref: ref);
    cyclesProv.cyclesCrud(
        slug: workspaceSlug,
        projectId: projectID,
        method: CRUD.read,
        query: 'completed',
        cycleId: '',
        ref: ref);
    cyclesProv.cyclesCrud(
        slug: workspaceSlug,
        projectId: projectID,
        method: CRUD.read,
        query: 'draft',
        cycleId: '',
        ref: ref);

    pageProv.updatepageList(
      slug: workspaceSlug,
      projectId: projectID,
    );

    if (workspaceProvider.githubIntegration != null) {
      intergrationProvider.getSlackIntegration(
          slug: workspaceSlug,
          projectId: projectID,
          integrationId: workspaceProvider.githubIntegration['id']);
    }
    if (workspaceProvider.githubIntegration != null) {
      intergrationProvider.getGitHubIntegration(
          slug: workspaceSlug,
          projectId: projectID,
          integrationId: workspaceProvider.githubIntegration['id']);
    }
  }

  void changeCoverUrl({required String url}) {
    coverUrl = url;
    notifyListeners();
  }

  Future joinProject({String? projectId, String? slug}) async {
    try {
      joinprojectState = StateEnum.loading;
      notifyListeners();
      await DioConfig().dioServe(
          hasAuth: true,
          url: APIs.joinProject.replaceAll("\$SLUG", slug!),
          hasBody: true,
          httpMethod: HttpMethod.post,
          data: {
            "project_ids": [projectId]
          });
      joinprojectState = StateEnum.success;
      // updating local projects List
      // ref!.read(ProviderList.projectProvider).projects[ref!
      //     .read(ProviderList.projectProvider)
      //     .currentProject["index"]]["is_member"] = true;
      //ref!.read(ProviderList.projectProvider).initializeProject();
      notifyListeners();
    } on DioException catch (e) {
      log(e.message.toString());
      joinprojectState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getProjects({required String slug}) async {
    projectState = StateEnum.loading;
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
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
      projectState = StateEnum.success;
      notifyListeners();
      // log(response.data.toString());
    } on DioException catch (e) {
      log(e.error.toString());
      projectState = StateEnum.error;
      notifyListeners();
    }
  }

  Future favouriteProjects(
      {required String slug,
      required HttpMethod method,
      required String projectID,
      required int index}) async {
    projectState = StateEnum.loading;
    notifyListeners();
    try {
      log(APIs.favouriteProjects.replaceAll('\$SLUG', slug) + projectID);
      var response = await DioConfig().dioServe(
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
        projects.removeAt(index);
        starredProjects.add(response.data);
      } else if (method == HttpMethod.get) {
        starredProjects = response.data;
      } else {
        // projects.add(starredProjects.removeAt(index)['project_detail']);
      }
      await getProjects(slug: slug);
      projectState = StateEnum.success;
      notifyListeners();
      // log(response.data.toString());
    } on DioException catch (e) {
      log("ERROR=${e.response}");
      projectState = StateEnum.error;
      notifyListeners();
    }
  }

  Future inviteToProject({
    required BuildContext context,
    required String slug,
    required String projId,
    required data,
  }) async {
    projectInvitationState = StateEnum.loading;
    notifyListeners();
    try {
      log(data.toString());
      await DioConfig().dioServe(
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
      projectInvitationState = StateEnum.success;
      CustomToast.showToast(context,
          message: 'Invitation sent successfully',
          toastType: ToastType.success);
      projectInvitationState = StateEnum.error;
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
      projectInvitationState = StateEnum.error;
      notifyListeners();
    }
  }

  Future createProjects(
      {required String slug,
      required data,
      WidgetRef? ref,
      BuildContext? context}) async {
    createProjectState = StateEnum.loading;
    var workspaceProvider = ref!.watch(ProviderList.workspaceProvider);
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.createProjects.replaceAll('\$SLUG', slug),
        hasBody: true,
        data: data,
        httpMethod: HttpMethod.post,
      );
      postHogService(
          eventName: 'CREATE_PROJECT',
          properties: {
            'WORKSPACE_ID': workspaceProvider.selectedWorkspace!.workspaceId,
            'WORKSPACE_NAME':
                workspaceProvider.selectedWorkspace!.workspaceName,
            'WORKSPACE_SLUG':
                workspaceProvider.selectedWorkspace!.workspaceSlug,
            'PROJECT_ID': response.data['id'],
            'PROJECT_NAME': response.data['name']
          },
          ref: ref);
      await getProjects(slug: slug);
      createProjectState = StateEnum.success;
      notifyListeners();
      // log(response.data.toString());
    } on DioException catch (e) {
      if (context != null) {
        CustomToast.showToast(context,
            message: 'Identifier already exists', toastType: ToastType.failure);
      }

      log(e.error.toString());
      createProjectState = StateEnum.error;
      notifyListeners();
    }
  }

  Future<bool> checkIdentifierAvailability({
    required String slug,
    required String identifier,
  }) async {
    try {
      var response = await DioConfig().dioServe(
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
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: "${APIs.listProjects.replaceAll('\$SLUG', slug)}$projId/",
        hasBody: false,
        httpMethod: HttpMethod.get,
      );

      projectDetailModel = ProjectDetailModel.fromMap(response.data);
      features[1]['show'] = projectDetailModel!.cycleView ?? true;
      features[2]['show'] = projectDetailModel!.moduleView ?? true;
      features[3]['show'] = projectDetailModel!.issueViewsView ?? true;
      // features[4]['show'] = projectDetailModel!.pageView ?? true;

      getProjectMembers(slug: slug, projId: projId);
      projectDetailState = StateEnum.success;
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.error.toString());
      }
      log(e.toString());
      projectDetailState = StateEnum.error;
      notifyListeners();
    }
  }

  Future updateProject(
      {required String slug,
      required String projId,
      required Map data,
      WidgetRef? ref}) async {
    updateProjectState = StateEnum.loading;
    var workspaceProvider = ref!.watch(ProviderList.workspaceProvider);
    notifyListeners();
    log("${APIs.listProjects.replaceAll('\$SLUG', slug)}$projId/");
    try {
      var response = await DioConfig().dioServe(
          hasAuth: true,
          url: "${APIs.listProjects.replaceAll('\$SLUG', slug)}$projId/",
          hasBody: true,
          httpMethod: HttpMethod.patch,
          data: data);
      var defaultAssignee = projectDetailModel!.defaultAssignee;
      var projectLead = projectDetailModel!.projectLead;
      projectDetailModel = ProjectDetailModel.fromMap(response.data);
      projectDetailModel!.defaultAssignee = defaultAssignee;
      projectDetailModel!.projectLead = projectLead;
      int index = currentProject["index"];
      currentProject = projectDetailModel!.toJson();
      log('CURRENT PROJECT');
      log(currentProject.toString());
      currentProject["index"] = index;
      projects[index]["name"] = currentProject["name"];
      projects[index]["description"] = currentProject["description"];
      projects[index]["identifier"] = currentProject["identifier"];
      projects[index]["emoji"] = currentProject["emoji"];

      projects[index]["icon_prop"] = currentProject["icon_prop"] != null
          ? {
              'name': currentProject["icon_prop"]["name"],
              'color': currentProject["icon_prop"]["color"],
            }
          : null;
      updateProjectState = StateEnum.success;
      postHogService(
          eventName: 'UPDATE_PROJECT',
          properties: {
            'WORKSPACE_ID': workspaceProvider.selectedWorkspace!.workspaceId,
            'WORKSPACE_NAME':
                workspaceProvider.selectedWorkspace!.workspaceName,
            'WORKSPACE_SLUG':
                workspaceProvider.selectedWorkspace!.workspaceSlug,
            'PROJECT_ID': response.data['id'],
            'PROJECT_NAME': response.data['name']
          },
          ref: ref);
      notifyListeners();
    } on DioException catch (e) {
      log(e.toString());
      updateProjectState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getProjectMembers(
      {required String slug, required String projId}) async {
    // projectDetailState = AuthStateEnum.loading;
    // notifyListeners();
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.projectMembers
            .replaceFirst('\$SLUG', slug)
            .replaceFirst('\$PROJECTID', projId),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );

      projectMembers = response.data;
      projectMembersState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.error.toString());
      projectMembersState = StateEnum.error;
      notifyListeners();
    }
  }

  Future deleteProject({required String slug, required String projId}) async {
    try {
      deleteProjectState = StateEnum.loading;
      notifyListeners();
      await DioConfig().dioServe(
        hasAuth: true,
        url: "${APIs.listProjects.replaceAll('\$SLUG', slug)}$projId/",
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      deleteProjectState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.error.toString());
      deleteProjectState = StateEnum.error;
      notifyListeners();
    }
  }

  Future<bool> leaveProject(
      {required String slug,
      required String projId,
      required int index}) async {
    try {
      leaveProjectState = StateEnum.loading;
      notifyListeners();
      await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.leaveProject
            .replaceFirst('\$SLUG', slug)
            .replaceFirst('\$PROJECTID', projId),
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      leaveProjectState = StateEnum.success;
      getProjects(slug: slug);
      notifyListeners();
      return true;
    } on DioException catch (e) {
      log(e.error.toString());
      leaveProjectState = StateEnum.error;
      notifyListeners();
      return false;
    }
  }

  Future updateProjectMember(
      {required String slug,
      required String projId,
      required String userId,
      required CRUD method,
      required data}) async {
    try {
      var url =
          '${APIs.projectMembers.replaceFirst('\$SLUG', slug).replaceFirst('\$PROJECTID', projId)}$userId/';
      updateProjectMemberState = StateEnum.loading;
      notifyListeners();
      await DioConfig().dioServe(
          hasAuth: true,
          url: url,
          hasBody: method == CRUD.update ? true : false,
          httpMethod:
              method == CRUD.update ? HttpMethod.patch : HttpMethod.delete,
          data: data);
      getProjectMembers(slug: slug, projId: projId);
      updateProjectMemberState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.message.toString());
      updateProjectMemberState = StateEnum.error;
      notifyListeners();
    }
  }

  Future stateCrud(
      {required String slug,
      required String projId,
      required String stateId,
      required CRUD method,
      required BuildContext context,
      required WidgetRef ref,
      required Map data}) async {
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    try {
      var url = method == CRUD.update || method == CRUD.delete
          ? '${APIs.states.replaceFirst('\$SLUG', slug).replaceFirst('\$PROJECTID', projId)}$stateId/'
          : APIs.states
              .replaceFirst('\$SLUG', slug)
              .replaceFirst('\$PROJECTID', projId);
      stateCrudState = StateEnum.loading;
      notifyListeners();
      var response = await DioConfig().dioServe(
          hasAuth: true,
          url: url,
          hasBody: true,
          httpMethod: method == CRUD.create
              ? HttpMethod.post
              : method == CRUD.update
                  ? HttpMethod.put
                  : method == CRUD.delete
                      ? HttpMethod.delete
                      : HttpMethod.patch,
          data: data);
      stateCrudState = StateEnum.success;
      method != CRUD.read
          ? postHogService(
              eventName: method == CRUD.create
                  ? 'STATE_CREATE'
                  : method == CRUD.update
                      ? 'STATE_UPDATE'
                      : method == CRUD.delete
                          ? 'STATE_DELETE'
                          : '',
              properties: method == CRUD.delete
                  ? {}
                  : {
                      'WORKSPACE_ID':
                          workspaceProvider.selectedWorkspace!.workspaceId,
                      'WORKSPACE_SLUG':
                          workspaceProvider.selectedWorkspace!.workspaceSlug,
                      'WORKSPACE_NAME':
                          workspaceProvider.selectedWorkspace!.workspaceName,
                      'PROJECT_ID': projectProvider.projectDetailModel!.id,
                      'PROJECT_NAME': projectProvider.projectDetailModel!.name,
                      'STATE_ID':
                          method == CRUD.create ? response.data['id'] : stateId
                    },
              ref: ref)
          : null;
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.message.toString());
      }
      CustomToast.showToast(context,
          message: 'Something went wrong, Please try again.',
          toastType: ToastType.failure);
      log(e.toString());
      stateCrudState = StateEnum.error;
      notifyListeners();
    }
  }
}
