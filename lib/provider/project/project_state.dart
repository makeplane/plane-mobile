import 'package:plane/models/project/project.model.dart';

class ProjectState {
  ProjectState({required this.projects, this.currentProjectDetails});
  ProjectModel? currentProjectDetails;
  Map<String, ProjectModel> projects = {};

  ProjectState copyWith(
      {ProjectModel? currentProjectDetails,
      Map<String, ProjectModel>? projects}) {
    return ProjectState(
        projects: projects ?? this.projects,
        currentProjectDetails:
            currentProjectDetails ?? this.currentProjectDetails);
  }

  factory ProjectState.initial() {
    return ProjectState(projects: {});
  }
}
