import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plane/models/user_profile_model.dart';
import 'package:plane/provider/profile_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/provider/workspace_provider.dart';
import 'package:plane/repository/profile_provider_service.dart';
import 'package:plane/repository/workspace_service.dart';
import 'package:plane/utils/enums.dart';

class MockWorkspaceService extends Mock implements WorkspaceService {}

class MockProfileService extends Mock implements ProfileService {}

void main() {
  late MockWorkspaceService mockWorkspaceService;
  late WorkspaceProvider workspaceProvider;
  late MockProfileService mockProfileService;
  late ProfileProvider profileProvider;
  Future setREF(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Material(
            child: Consumer(
              builder: (context, watch, _) {
                // Obtain the actual ref from the context
                workspaceProvider.ref =
                    watch.read(ProviderList.workspaceProvider).ref;
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  setUp(() async {
    await dotenv.load(fileName: '.env');
    mockWorkspaceService = MockWorkspaceService();
    mockProfileService = MockProfileService();
    profileProvider = ProfileProvider(profileService: mockProfileService);
    workspaceProvider =
        WorkspaceProvider(ref: null, workspaceService: mockWorkspaceService);
  });

  testWidgets('Check for Empty Workspaces List', (tester) async {
    await setREF(tester);
    when(() => mockWorkspaceService.getWorkspaces())
        .thenAnswer((invocation) async {
      await tester.runAsync(
          () async => await Future.delayed(const Duration(milliseconds: 1500)));
      return const Left([]);
    });
    when(() => mockWorkspaceService.getWorkspaceMembers(url: any(named: 'url')))
        .thenAnswer((invocation) async {
      await tester.runAsync(
          () async => await Future.delayed(const Duration(milliseconds: 1500)));
      return const Left([]);
    });
    var getWorkspaces = workspaceProvider.getWorkspaces();
    expect(workspaceProvider.workspaceInvitationState, StateEnum.loading);
    await getWorkspaces;

    expect(workspaceProvider.workspaceInvitationState, StateEnum.error);
  });

  // testWidgets('GET Workspaces List', (tester) async {
  //   await setREF(tester);
  //   when(() => mockWorkspaceService.getWorkspaces())
  //       .thenAnswer((invocation) async {
  //     await tester.runAsync(
  //         () async => await Future.delayed(const Duration(milliseconds: 1500)));
  //     return const Left([
  //       {
  //         "id": "cd4ab5a2-1a5f-4516-a6c6-8da1a9fa5be4",
  //         "owner": {
  //           "id": "b954eda4-5024-4298-baae-df0ae5980fb8",
  //           "first_name": "Kailash",
  //           "last_name": "Chollangi",
  //           "email": "kailash@caravel.ai",
  //           "avatar":
  //               "https://planefs.s3.amazonaws.com/979bb021-3432-4898-894c-3e2d3a149758/kailash.png",
  //           "is_bot": false
  //         },
  //         "total_members": 53,
  //         "total_issues": 1433,
  //         "created_at": "2022-11-16T20:11:41.281283+05:30",
  //         "updated_at": "2023-04-17T20:31:04.263459+05:30",
  //         "name": "Plane",
  //         "logo":
  //             "https://planefs.s3.amazonaws.com/cd4ab5a2-1a5f-4516-a6c6-8da1a9fa5be4/b751e8344a224af488a3ab42c9d3d7d9-logo_3.png",
  //         "slug": "plane",
  //         "organization_size": "10",
  //         "created_by": "b954eda4-5024-4298-baae-df0ae5980fb8",
  //         "updated_by": "f67973ef-1285-41c9-8162-b466b50ea588"
  //       },
  //     ]);
  //   });
  //   when(() => mockWorkspaceService.getWorkspaceMembers(url: any(named: 'url')))
  //       .thenAnswer((invocation) async {
  //     await tester.runAsync(
  //         () async => await Future.delayed(const Duration(milliseconds: 1500)));
  //     return const Left([]);
  //   });
  //   var getWorkspaces = workspaceProvider.getWorkspaces();
  //   expect(workspaceProvider.workspaceInvitationState, StateEnum.loading);
  //   await getWorkspaces;
  //   verify(() =>
  //           mockWorkspaceService.getWorkspaceMembers(url: any(named: 'url')))
  //       .called(1);

  //   expect(workspaceProvider.workspaceInvitationState, StateEnum.success);
  // });

  testWidgets('GET Workspaces Member List', (tester) async {
    await setREF(tester);
    when(() => mockWorkspaceService.getWorkspaceMembers(url: any(named: 'url')))
        .thenAnswer((invocation) async {
      await tester.runAsync(
          () async => await Future.delayed(const Duration(milliseconds: 1500)));
      return const Left([
        {
          "member": {
            "id": "7d145d9a-d5e7-4316-9782-958704e7d3e7",
          },
          'role': 20
        }
      ]);
    });
    when(() => mockProfileService.getProfile()).thenAnswer((invocation) async {
      await tester.runAsync(
          () async => await Future.delayed(const Duration(milliseconds: 1500)));
      return Left(
          UserProfile.initialize(id: "7d145d9a-d5e7-4316-9782-958704e7d3e7"));
    });

    ProviderList.profileProvider =
        ChangeNotifierProvider((ref) => profileProvider);
    await profileProvider.getProfile();
    var getWorkspaces = workspaceProvider.getWorkspaceMembers();
    expect(workspaceProvider.getMembersState, StateEnum.loading);
    await getWorkspaces;
    expect(workspaceProvider.role.name == 'none', false);
    expect(workspaceProvider.getMembersState, StateEnum.success);
  });

  testWidgets('Select Workspaces', (widgetTester)async{




  });
}
