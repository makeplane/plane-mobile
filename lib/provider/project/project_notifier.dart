// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:plane/core/exception/plane_exception.dart';
// import 'package:plane/models/project/project.model.dart';
// import 'package:plane/provider/provider_list.dart';
// import 'package:plane/repository/project.repository.dart';

// import 'project_state.dart';

// class ProjectNotifier extends StateNotifier<ProjectState> {
//   ProjectNotifier(super.state);
//   Ref ref;
//   ProjectRepository _projectRepository;

//   Future<void> initializeProject(String projectId) async {
//     final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
//     final projectIssuesNotifier =
//         ref.read(ProviderList.projectIssuesProvider.notifier);
//     await getProjectDetails(slug: workspaceSlug, projId: projectId);
//     getProjectMembers(
//       slug: workspaceSlug,
//       projId: state.currentprojectDetails!.id!,
//     );
//     ref.read(ProviderList.statesProvider.notifier).getStates();
//     ref.read(ProviderList.estimatesProvider).getEstimates(
//           slug: workspaceSlug,
//           projID: state.currentprojectDetails!.id!,
//         );
//     projectIssuesNotifier.fetchLayoutProperties().then((value) {
//       projectIssuesNotifier.fetchIssues();
//     });
//   }

//   Future<Either<PlaneException, ProjectModel>> joinProject(
//       String projectId) async {
//     final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
//     final response =
//         await _projectRepository.joinProject(workspaceSlug, projectId);
//     return response.fold((err) => Left(err), (_) => const Right(null));
//   }

//   Future<Either<PlaneException, List<ProjectModel>>> fetchProjects() async {
//     final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
//     final response = await _projectRepository.fetchProjects(workspaceSlug);
//     return response.fold(
//         (err) => Left(err), (projects) => Right(projects.values.toList()));
//   }

//   Future<Either<PlaneException, ProjectModel>> fetchProjectDetails(
//       String projectId) async {
//     final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
//     final response =
//         await _projectRepository.fetchProjectDetails(workspaceSlug, projectId);
//     return response.fold(
//         (err) => Left(err), (projectDetail) => Right(projectDetail));
//   }

//   Future<Either<PlaneException, ProjectModel>> createProject(
//       ProjectModel payload) async {
//     final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
//     final response =
//         await _projectRepository.createProject(workspaceSlug, payload);
//     return response.fold((err) => Left(err), (project) => Right(project));
//   }

//   Future<Either<PlaneException, ProjectModel>> updateProject(
//       ProjectModel payload) async {
//     final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
//     final response =
//         await _projectRepository.updateProject(workspaceSlug, payload);
//     return response.fold((err) => Left(err), (project) => Right(project));
//   }

//   Future<Either<PlaneException, void>> deleteProject(String projectId) async {
//     final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
//     final response =
//         await _projectRepository.deleteProject(workspaceSlug, projectId);
//     return response.fold((err) => Left(err), (project) => const Right(null));
//   }

//     Future<Either<PlaneException, void>> leaveProject(String projectId) async {
//     final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
//     final response =
//         await _projectRepository.leaveProject(workspaceSlug, projectId);
//     return response.fold((err) => Left(err), (project) => const Right(null));
//   }
// }


// //   Future inviteToProject({
// //     required BuildContext context,
// //     required String slug,
// //     required String projId,
// //     required Map data,
// //   }) async {
// //     projectInvitationState = DataState.loading;
// //     notifyListeners();
// //     try {
// //       log(data.toString());
// //       await DioConfig().dioServe(
// //         hasAuth: true,
// //         url: APIs.inviteToProject.replaceAll('\$SLUG', slug).replaceAll(
// //               '\$PROJECTID',
// //               projId,
// //             ),
// //         hasBody: true,
// //         data: data,
// //         httpMethod: HttpMethod.post,
// //       );
// //       // log(response.data.toString());
// //       projectInvitationState = DataState.success;
// //       notifyListeners();
// //       // log(response.data.toString());
// //     } on DioException catch (e) {
// //       log('Project Invite Error =  ${e.message}');
// //       log(e.error.toString());
// //       CustomToast.showToast(context,
// //           message: e.message == null
// //               ? 'something went wrong!'
// //               : e.message.toString(),
// //           toastType: ToastType.failure);
// //       projectInvitationState = DataState.error;
// //       notifyListeners();
// //     }
// //   }


// //   Future<bool> checkIdentifierAvailability({
// //     required String slug,
// //     required String identifier,
// //   }) async {
// //     try {
// //       final response = await DioConfig().dioServe(
// //         hasAuth: true,
// //         url: APIs.projectIdentifier
// //             .replaceAll(
// //               '\$SLUG',
// //               slug,
// //             )
// //             .replaceAll("\$IDENTIFIER", identifier),
// //         hasBody: false,
// //         httpMethod: HttpMethod.get,
// //       );
// //       return response.data['exists'] == 0;
// //     } on DioException catch (e) {
// //       log(e.error.toString());
// //     }
// //     return false;
// //   }


// //   Future getProjectMembers({
// //     required String slug,
// //     required String projId,
// //   }) async {
// //     // projectDetailState = AuthStateEnum.loading;
// //     // notifyListeners();
// //     try {
// //       final response = await DioConfig().dioServe(
// //         hasAuth: true,
// //         url: APIs.projectMembers
// //             .replaceFirst('\$SLUG', slug)
// //             .replaceFirst('\$PROJECTID', projId),
// //         hasBody: false,
// //         httpMethod: HttpMethod.get,
// //       );
// //       projectMembers = response.data;

// //       for (final element in projectMembers) {
// //         for (final workspace
// //             in ref.watch(ProviderList.workspaceProvider).workspaceMembers) {
// //           if (element['member'] == workspace['member']['id']) {
// //             // Replace the map in projectMembers with the one from workspaceMembers
// //             projectMembers[projectMembers.indexOf(element)] = workspace;
// //           }
// //           if (element["member"] ==
// //               ref.read(ProviderList.profileProvider).userProfile.id) {
// //             role = roleParser(role: element["role"]);
// //           }
// //         }
// //       }
// //       projectMembersState = DataState.success;
// //       notifyListeners();
// //     } on DioException catch (e) {
// //       log(e.error.toString());
// //       projectMembersState = DataState.error;
// //       notifyListeners();
// //     }
// //   }


// //   Future updateProjectMember(
// //       {required String slug,
// //       required String projId,
// //       required String userId,
// //       required CRUD method,
// //       required Map data}) async {
// //     try {
// //       final url =
// //           '${APIs.projectMembers.replaceFirst('\$SLUG', slug).replaceFirst('\$PROJECTID', projId)}$userId/';
// //       updateProjectMemberState = DataState.loading;
// //       notifyListeners();
// //       await DioConfig().dioServe(
// //           hasAuth: true,
// //           url: url,
// //           hasBody: method == CRUD.update ? true : false,
// //           httpMethod:
// //               method == CRUD.update ? HttpMethod.patch : HttpMethod.delete,
// //           data: data);
// //       getProjectMembers(slug: slug, projId: projId);
// //       updateProjectMemberState = DataState.success;
// //       notifyListeners();
// //     } on DioException catch (e) {
// //       log(e.message.toString());
// //       updateProjectMemberState = DataState.error;
// //       notifyListeners();
// //     }
// //   }
