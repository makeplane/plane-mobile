import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plane/bottom_sheets/global_search_sheet.dart';
import 'package:plane/bottom_sheets/select_workspace.dart';
import 'package:plane/models/user_profile_model.dart';
import 'package:plane/models/Workspace/workspace_model.dart';
import 'package:plane/provider/dashboard_provider.dart';
import 'package:plane/provider/global_search_provider.dart';
import 'package:plane/provider/profile_provider.dart';
import 'package:plane/provider/projects_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/provider/workspace_provider.dart';
import 'package:plane/screens/MainScreens/Home/Dashboard/dash_board_screen.dart';
import 'package:plane/screens/on_boarding/auth/setup_workspace.dart';

import 'package:plane/utils/enums.dart';

class MockProfileProvider extends Mock implements ProfileProvider {}

class MockDashboardProvider extends Mock implements DashBoardProvider {}

class MockProjectsProvider extends Mock implements ProjectsProvider {}

class MockWorkspaceProvider extends Mock implements WorkspaceProvider {}

class MockGlobalSearchProvider extends Mock implements GlobalSearchProvider {}

void main() {
  late MockWorkspaceProvider mockWorkspaceProvider;
  late MockProfileProvider mockProfileProvider;
  late MockDashboardProvider mockDashBoardProvider;
  late MockProjectsProvider mockProjectsProvider;
  late GlobalSearchProvider mockGlobalSearchProvider;

  setUp(() {
    mockDashBoardProvider = MockDashboardProvider();
    mockProjectsProvider = MockProjectsProvider();
    mockWorkspaceProvider = MockWorkspaceProvider();
    mockProfileProvider = MockProfileProvider();
    mockGlobalSearchProvider = MockGlobalSearchProvider();

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

    // ignore: invalid_use_of_protected_member
    when(() => mockGlobalSearchProvider.state)
        .thenReturn(SearchModal.initialize());

    when(() => mockWorkspaceProvider.selectWorkspaceState)
        .thenReturn(StateEnum.success);
    when(() => mockWorkspaceProvider.workspaces).thenReturn([]);
    when(() => mockWorkspaceProvider.selectedWorkspace)
        .thenReturn(WorkspaceModel.initialize(workspaceName: 'TESTER'));
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

  testWidgets('Navigation Test', (tester) async {
    when(() => mockWorkspaceProvider.checkWorkspaceState)
        .thenReturn(StateEnum.success);
    when(() => mockWorkspaceProvider.createWorkspaceState)
        .thenReturn(StateEnum.success);
    when(() => mockWorkspaceProvider.selectWorkspaceState)
        .thenReturn(StateEnum.success);
    when(() => mockWorkspaceProvider.companySize).thenReturn('');

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
}
