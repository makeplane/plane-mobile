class RoutesPaths {
  /// [Splash]
  static const String splash = "/";

  /// [Home]
  static const createCycle = '/createCycle';
  static const createIssue = '/createIssue';
  static const createProject = '/createProject';
  static const createModule = '/createModule';
  static const activity = '/activity';
  static const createState = 'createState';
  static const String onboarding = "/onboarding";
  static const String signin = "/signin";
  static const String setupProfile = "/setup-profile";
  static const String setupWorkspace = "/setup-workspace";
  static const String home = "/home";

  static List<String> routes = [
    splash,
    onboarding,
    signin,
    home,
    setupProfile,
    setupWorkspace,
    createCycle,
    createIssue,
    createProject,
    createModule,
    activity,
    createState
  ];
}
