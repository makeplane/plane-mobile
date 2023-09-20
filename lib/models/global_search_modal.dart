class GlobalSearchModal {
  final List<Workspace> workspaces;
  final List<Project> projects;
  final List<Issue> issues;
  final List<Cycle> cycles;
  final List<Module> modules;
  final List<View> views;
  final List<Page> pages;

  GlobalSearchModal({
    required this.workspaces,
    required this.projects,
    required this.issues,
    required this.cycles,
    required this.modules,
    required this.views,
    required this.pages
  });
  factory GlobalSearchModal.initialize() {
    return GlobalSearchModal(
      workspaces: [],
      projects: [],
      issues: [],
      cycles: [],
      modules: [],
      views: [],
      pages: [],
    );
  }

  factory GlobalSearchModal.fromJson(Map<String, dynamic> json) {
    return GlobalSearchModal(
      workspaces: (json['results']['workspace'] as List)
          .map((data) => Workspace.fromJson(data))
          .toList(),
      projects: (json['results']['project'] as List)
          .map((data) => Project.fromJson(data))
          .toList(),
      issues: (json['results']['issue'] as List)
          .map((data) => Issue.fromJson(data))
          .toList(),
      cycles: (json['results']['cycle'] as List)
          .map((data) => Cycle.fromJson(data))
          .toList(),
      modules: (json['results']['module'] as List)
          .map((data) => Module.fromJson(data))
          .toList(),
      views: (json['results']['issue_view'] as List)
          .map((data) => View.fromJson(data))
          .toList(),
      pages: (json['results']['page'] as List)
          .map((data) => Page.fromJson(data))
          .toList(),
    );
  }
}

class Workspace {
  final String name;
  final String id;
  final String slug;

  Workspace({
    required this.name,
    required this.id,
    required this.slug,
  });

  factory Workspace.fromJson(Map<String, dynamic> json) {
    return Workspace(
      name: json['name'],
      id: json['id'],
      slug: json['slug'],
    );
  }
}

class Project {
  final String name;
  final String id;
  final String identifier;
  final String workspaceSlug;

  Project({
    required this.name,
    required this.id,
    required this.identifier,
    required this.workspaceSlug,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'],
      id: json['id'],
      identifier: json['identifier'],
      workspaceSlug: json['workspace__slug'],
    );
  }
}

class Issue {
  final String name;
  final String id;
  final int sequenceId;
  final String projectIdentifier;
  final String projectId;
  final String workspaceSlug;

  Issue({
    required this.name,
    required this.id,
    required this.sequenceId,
    required this.projectIdentifier,
    required this.projectId,
    required this.workspaceSlug,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      name: json['name'],
      id: json['id'],
      sequenceId: json['sequence_id'],
      projectIdentifier: json['project__identifier'],
      projectId: json['project_id'],
      workspaceSlug: json['workspace__slug'],
    );
  }
}

class Cycle {
  final String name;
  final String id;
  final String projectId;
  final String projectIdentifier;
  final String workspaceSlug;

  Cycle({
    required this.name,
    required this.id,
    required this.projectId,
    required this.projectIdentifier,
    required this.workspaceSlug,
  });

  factory Cycle.fromJson(Map<String, dynamic> json) {
    return Cycle(
      name: json['name'],
      id: json['id'],
      projectId: json['project_id'],
      projectIdentifier: json['project__identifier'],
      workspaceSlug: json['workspace__slug'],
    );
  }
}

class Module {
  final String name;
  final String id;
  final String projectId;
  final String projectIdentifier;
  final String workspaceSlug;

  Module({
    required this.name,
    required this.id,
    required this.projectId,
    required this.projectIdentifier,
    required this.workspaceSlug,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      name: json['name'],
      id: json['id'],
      projectId: json['project_id'],
      projectIdentifier: json['project__identifier'],
      workspaceSlug: json['workspace__slug'],
    );
  }
}

class View {
  final String name;
  final String id;
  final String projectId;
  final String projectIdentifier;
  final String workspaceSlug;

  View({
    required this.name,
    required this.id,
    required this.projectId,
    required this.projectIdentifier,
    required this.workspaceSlug,
  });

  factory View.fromJson(Map<String, dynamic> json) {
    return View(
      name: json['name'],
      id: json['id'],
      projectId: json['project_id'],
      projectIdentifier: json['project__identifier'],
      workspaceSlug: json['workspace__slug'],
    );
  }
}

class Page {
  final String name;
  final String id;
  final String projectId;
  final String projectIdentifier;
  final String workspaceSlug;

  Page({
    required this.name,
    required this.id,
    required this.projectId,
    required this.projectIdentifier,
    required this.workspaceSlug,
  });

  factory Page.fromJson(Map<String, dynamic> json) {
    return Page(
      name: json['name'],
      id: json['id'],
      projectId: json['project_id'],
      projectIdentifier: json['project__identifier'],
      workspaceSlug: json['workspace__slug'],
    );
  }
}
