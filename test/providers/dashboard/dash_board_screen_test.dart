import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plane/bottom_sheets/global_search_sheet.dart';
import 'package:plane/bottom_sheets/select_workspace.dart';
import 'package:plane/models/user_profile_model.dart';
import 'package:plane/models/workspace_model.dart';
import 'package:plane/provider/dashboard_provider.dart';
import 'package:plane/provider/profile_provider.dart';
import 'package:plane/provider/projects_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/provider/workspace_provider.dart';
import 'package:plane/repository/dashboard_service.dart';
import 'package:plane/screens/MainScreens/Home/dash_board_screen.dart';
import 'package:plane/screens/on_boarding/auth/setup_workspace.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class MockProfileProvider extends Mock implements ProfileProvider {}

class MockDashboardProvider extends Mock implements DashBoardProvider {}

class MockProjectsProvider extends Mock implements ProjectsProvider {}

class MockWorkspaceProvider extends Mock implements WorkspaceProvider {}

void main() {
  late MockWorkspaceProvider mockWorkspaceProvider;
  late MockProfileProvider mockProfileProvider;
  late MockDashboardProvider mockDashBoardProvider;
  late MockProjectsProvider mockProjectsProvider;
  late DashBoardProvider dashboardProvider;

  var gridCardKeys = [
    'assigned_issues_count',
    'pending_issues_count',
    'completed_issues_count',
    'issues_due_week_count'
  ];
  setUp(() {
    mockDashBoardProvider = MockDashboardProvider();
    mockProjectsProvider = MockProjectsProvider();
    mockWorkspaceProvider = MockWorkspaceProvider();
    mockProfileProvider = MockProfileProvider();

    dashboardProvider = DashBoardProvider(
        ref: null, dashboardService: DashboardService(DioConfig()));

    ProviderList.workspaceProvider =
        ChangeNotifierProvider<MockWorkspaceProvider>(
            (ref) => mockWorkspaceProvider);
    ProviderList.profileProvider = ChangeNotifierProvider<MockProfileProvider>(
        (ref) => mockProfileProvider);
    ProviderList.dashboardProvider =
        ChangeNotifierProvider<MockDashboardProvider>(
            (ref) => mockDashBoardProvider);
    ProviderList.projectProvider = ChangeNotifierProvider<MockProjectsProvider>(
        (ref) => mockProjectsProvider);
    when(() => mockWorkspaceProvider.selectedWorkspace)
        .thenReturn(WorkspaceModel.initialize(workspaceName: 'TESTER'));
    when(() => mockWorkspaceProvider.selectWorkspaceState)
        .thenReturn(StateEnum.success);
    when(() => mockProfileProvider.userProfile)
        .thenReturn(UserProfile.initialize(firstName: 'TESTER'));
    when(
      () => mockProjectsProvider.projects,
    ).thenReturn([]);
    when(
      () => mockProjectsProvider.projectState,
    ).thenAnswer((_) => StateEnum.success);
    when(() => mockDashBoardProvider.hideGithubBlock).thenReturn(false);
    when(
      () => mockDashBoardProvider.dashboardData,
    ).thenReturn({
      "issue_activities": [],
      "completed_issues": [],
      "assigned_issues_count": 10,
      "pending_issues_count": 20,
      "completed_issues_count": 32,
      "issues_due_week_count": 45,
      "state_distribution": [],
      "overdue_issues": [],
      "upcoming_issues": []
    });
  });

  String greetAtTime(int hourIn24HourFormate) {
    if (hourIn24HourFormate < 12) {
      return 'Good Morning';
    } else if (hourIn24HourFormate < 17) {
      // 17 = 5 pm
      return 'Good Afternoon';
    } else {
      return 'Good evening';
    }
  }

  testWidgets('Greetings Check', (tester) async {
    when(
      () => mockProjectsProvider.projectState,
    ).thenAnswer((_) => StateEnum.success);
    await tester.pumpWidget(const MaterialApp(
        home: ProviderScope(child: DashBoardScreen(fromSignUp: false))));

    expect(
        find.text(
            '${greetAtTime(DateTime.now().hour)}, ${mockProfileProvider.userProfile.firstName ?? ''}'),
        findsOneWidget);
    expect(find.text('Create a project'), findsOneWidget);
  });

  testWidgets('Create Project card conditional rendering ', (tester) async {
    when(
      () => mockProjectsProvider.projectState,
    ).thenAnswer((_) => StateEnum.success);

    await tester.pumpWidget(const MaterialApp(
        home: ProviderScope(child: DashBoardScreen(fromSignUp: false))));
    expect(find.text('Create a project'), findsOneWidget);

    clearInteractions(mockProjectsProvider);
    when(
      () => mockProjectsProvider.projects,
    ).thenReturn([{}]);
    when(
      () => mockProjectsProvider.projectState,
    ).thenAnswer((_) => StateEnum.success);

    await tester.pumpWidget(const MaterialApp(
        home: ProviderScope(child: DashBoardScreen(fromSignUp: false))));
    expect(find.text('Create a project'), findsNothing);
  });

  testWidgets('Dashboard Metrics Check', (tester) async {
    when(
      () => mockProjectsProvider.projects,
    ).thenReturn([{}]);
    when(
      () => mockProjectsProvider.projectState,
    ).thenAnswer((_) => StateEnum.success);

    await tester.pumpWidget(const MaterialApp(
        home: ProviderScope(child: DashBoardScreen(fromSignUp: false))));

    /// Grid Cards Value Check ///
    expect(find.text('Star us on GitHub'), findsOneWidget);

    await tester.pump();
    expect(
        find.byType(
          GridView,
        ),
        findsOneWidget);

    for (var element in gridCardKeys) {
      var text = find.byKey(Key('grid-card-${gridCardKeys.indexOf(element)}'));

      expect(tester.widget<CustomText>(text).text,
          mockDashBoardProvider.dashboardData[element].toString());
    }
  });

  testWidgets('Hide Github Block', (tester) async {
    when(
      () => mockProjectsProvider.projectState,
    ).thenAnswer((_) => StateEnum.success);
    ProviderList.dashboardProvider =
        ChangeNotifierProvider<DashBoardProvider>((ref) => dashboardProvider);
    await tester.pumpWidget(const MaterialApp(
        home: ProviderScope(child: DashBoardScreen(fromSignUp: false))));

    expect(find.text('Star us on GitHub'), findsOneWidget);
    await tester.tap(find.byKey(const Key('hide-github-block')));
    await tester.pump();
    expect(find.text('Star us on GitHub'), findsNothing);
    await tester.pump();
    expect(find.text('Star us on GitHub'), findsNothing);
  });

  testWidgets('Check Selected Workspace Rendering', (widgetTester) async {
    when(() => mockWorkspaceProvider.selectedWorkspace).thenReturn(
        WorkspaceModel.initialize(workspaceName: 'TESTER', workspaceLogo: ''));
    await widgetTester.pumpWidget(const MaterialApp(
        home: ProviderScope(child: DashBoardScreen(fromSignUp: false))));

    expect(find.text('TESTER'), findsOneWidget);
    expect(find.text('T'), findsOneWidget);
  });

  testWidgets('Check Selected Workspace Logo Rendering', (widgetTester) async {
    when(() =>
        mockWorkspaceProvider
            .selectedWorkspace).thenReturn(WorkspaceModel.initialize(
        workspaceName: 'TESTER',
        workspaceLogo:
            'https://planefs.s3.amazonaws.com/cd4ab5a2-1a5f-4516-a6c6-8da1a9fa5be4/b751e8344a224af488a3ab42c9d3d7d9-logo_3.png'));
    await widgetTester.pumpWidget(const MaterialApp(
        home: ProviderScope(child: DashBoardScreen(fromSignUp: false))));
    expect(find.byType(CachedNetworkImage), findsOneWidget);
    expect(find.text('TESTER'), findsOneWidget);
    expect(find.text('T'), findsNothing);
  });

  testWidgets('Dashboard : Navigation Test', (tester) async {
    when(() => mockWorkspaceProvider.checkWorkspaceState)
        .thenReturn(StateEnum.success);
    when(() => mockWorkspaceProvider.createWorkspaceState)
        .thenReturn(StateEnum.success);
    when(() => mockWorkspaceProvider.companySize).thenReturn('');
    when(
      () => mockWorkspaceProvider.workspaces,
    ).thenReturn([]);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashBoardScreen(
            fromSignUp: false,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.byType(SetupWorkspace), findsOneWidget);
    expect(find.byType(DashBoardScreen), findsNothing);
    Navigator.pop(tester.element(find.byType(SetupWorkspace)));
    await tester.pumpAndSettle();
    expect(find.byType(SetupWorkspace), findsNothing);
    expect(find.byType(DashBoardScreen), findsOneWidget);
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    expect(find.byType(GlobalSearchSheet), findsOneWidget);
    expect(find.byType(DashBoardScreen), findsNothing);
    Navigator.pop(tester.element(find.byType(GlobalSearchSheet)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('select-workspace')));
    await tester.pumpAndSettle();
    expect(find.byType(SelectWorkspace), findsOneWidget);
    Navigator.pop(tester.element(find.byType(SelectWorkspace)));
    await tester.pumpAndSettle();
    expect(find.byType(SelectWorkspace), findsNothing);
    expect(find.byType(DashBoardScreen), findsOneWidget);
  });

  testWidgets('Integration', (tester) async {
    var workspaces = [
      {
        "id": "cd4ab5a2-1a5f-4516-a6c6-8da1a9fa5be4",
        "name": "Plane",
        "logo": null,
        "slug": "plane",
      },
      {
        "id": "41d2759f-cd66-46cb-9b84-607467695379",
        "name": "Plane Demo",
        "logo": null,
        "slug": "plane-demo",
      },
      {
        "id": "30995c83-8249-4da6-9746-8b9f632985b0",
        "name": "TEST",
        "logo": null,
        "slug": "test1211",
      }
    ];
    when(
      () => mockWorkspaceProvider.workspaces,
    ).thenReturn(workspaces);
    when(() => mockWorkspaceProvider.selectWorkspace(context: any(named: "context"),id: any(named: "id")))
        .thenAnswer((invocation) async => Left(WorkspaceModel.initialize()));
    when(() => mockProfileProvider.userProfile).thenReturn(
        UserProfile.initialize(
            lastWorkspaceId: 'cd4ab5a2-1a5f-4516-a6c6-8da1a9fa5be4'));
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashBoardScreen(
            fromSignUp: false,
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('select-workspace')));
    await tester.pumpAndSettle();
    expect(find.byType(SelectWorkspace), findsOneWidget);
    for (var element in workspaces) {
      expect(find.text(element['name'].toString()), findsOneWidget);
    }
    expect(find.byIcon(Icons.done), findsOneWidget);
    await tester.tap(find.text(workspaces.first['name'].toString()));
  });
}
