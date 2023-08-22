import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/kanban/models/project_detail_model.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/config/apis.dart';
import 'package:plane_startup/services/dio_service.dart';
import 'package:plane_startup/utils/enums.dart';

import '../models/issues.dart';

class ProjectsProvider extends ChangeNotifier {
  ProjectsProvider(ChangeNotifierProviderRef<ProjectsProvider> this.ref);
  final Ref ref;
  var projects = [];
  var starredProjects = [];
  var projectState = StateEnum.empty;
  var unsplashImageState = StateEnum.empty;
  var createProjectState = StateEnum.empty;
  var projectDetailState = StateEnum.empty;
  var projectMembersState = StateEnum.empty;
  var deleteProjectState = StateEnum.empty;
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

  List features = [
    {'title': 'Issues', 'width': 60, 'show': true},
    {'title': 'Cycles', 'width': 60, 'show': true},
    {'title': 'Modules', 'width': 75, 'show': true},
    {'title': 'Views', 'width': 60, 'show': true},
    {'title': 'Pages', 'width': 50, 'show': true},
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
    unsplashImages = [];
    currentProject = {};
    coverUrl =
        "https://app.plane.so/_next/image?url=https%3A%2F%2Fimages.unsplash.com%2Fphoto-1575116464504-9e7652fddcb3%3Fcrop%3Dentropy%26cs%3Dtinysrgb%26fit%3Dmax%26fm%3Djpg%26ixid%3DMnwyODUyNTV8MHwxfHNlYXJjaHwxOHx8cGxhbmV8ZW58MHx8fHwxNjgxNDY4NTY5%26ixlib%3Drb-4.0.3%26q%3D80%26w%3D1080&w=1920&q=75";
    projectDetailModel = null;
    lead.clear();
    assignee.clear();
  }

  void setState() {
    notifyListeners();
  }

  Future initializeProject({Filters? filters}) async {
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
    prov.getStates(slug: workspaceSlug, projID: currentProject['id']);

    prov.getLabels(slug: workspaceSlug, projID: currentProject['id']);

    getProjectDetails(slug: workspaceSlug, projId: currentProject['id']);

    var cyclesProv = ref.read(ProviderList.cyclesProvider);
    var projectID = currentProject['id'];
    cyclesProv.cyclesState = StateEnum.loading;

    cyclesProv.cyclesCrud(
        slug: workspaceSlug,
        projectId: projectID,
        method: CRUD.read,
        query: 'all');
    cyclesProv.cyclesCrud(
        slug: workspaceSlug,
        projectId: projectID,
        method: CRUD.read,
        query: 'current');
    cyclesProv.cyclesCrud(
        slug: workspaceSlug,
        projectId: projectID,
        method: CRUD.read,
        query: 'upcoming');
    cyclesProv.cyclesCrud(
        slug: workspaceSlug,
        projectId: projectID,
        method: CRUD.read,
        query: 'completed');
    cyclesProv.cyclesCrud(
        slug: workspaceSlug,
        projectId: projectID,
        method: CRUD.read,
        query: 'draft');

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
      notifyListeners();
      // log(response.data.toString());
    } on DioException catch (e) {
      log('Project Invite Error =  ${e.message}');
      log(e.error.toString());
      CustomToast().showToast(
          context,
          e.message == null ? 'something went wrong!' : e.message.toString(),
          ref.read(ProviderList.themeProvider),
          toastType: ToastType.failure);
      projectInvitationState = StateEnum.error;
      notifyListeners();
    }
  }

  Future createProjects({required String slug, required data}) async {
    createProjectState = StateEnum.loading;
    notifyListeners();
    log(slug);
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.createProjects.replaceAll('\$SLUG', slug),
        hasBody: true,
        data: data,
        httpMethod: HttpMethod.post,
      );
      log(response.data.toString());
      await getProjects(slug: slug);
      createProjectState = StateEnum.success;
      notifyListeners();
      // log(response.data.toString());
    } on DioException catch (e) {
      // CustomToast().showToast(
      //     Const.globalKey.currentContext!, 'Identifier already exists');
      ScaffoldMessenger.of(Const.globalKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Identifier already exists')));
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
      log("THIS IS THE PROJECT DETAIL : ");
      projectDetailModel = ProjectDetailModel.fromMap(response.data);
      features[1]['show'] = projectDetailModel!.cycleView ?? true;
      features[2]['show'] = projectDetailModel!.moduleView ?? true;
      // features[3]['show'] = projectDetailModel!.issueViewsView ?? true;
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
      {required String slug, required String projId, required Map data}) async {
    updateProjectState = StateEnum.loading;
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
      required Map data}) async {
    try {
      var url = method == CRUD.update || method == CRUD.delete
          ? '${APIs.states.replaceFirst('\$SLUG', slug).replaceFirst('\$PROJECTID', projId)}$stateId/'
          : APIs.states
              .replaceFirst('\$SLUG', slug)
              .replaceFirst('\$PROJECTID', projId);
      stateCrudState = StateEnum.loading;
      notifyListeners();
      await DioConfig().dioServe(
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
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.message.toString());
      }
      CustomToast().showToast(
          context,
          'Something went wrong, Please try again.',
          ref.read(ProviderList.themeProvider),
          toastType: ToastType.failure);
      log(e.toString());
      stateCrudState = StateEnum.error;
      notifyListeners();
    }
  }
}
