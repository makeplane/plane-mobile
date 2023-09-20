import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plane/provider/dashboard_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/repository/dashboard_service.dart';
import 'package:plane/utils/enums.dart';

class MockDashboardService extends Mock implements DashboardService {}

void main() async {
  late DashBoardProvider mockDashBoardProvider;
  late MockDashboardService mockDashboardService;

  Future setREF(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Material(
            child: Consumer(
              builder: (context, watch, _) {
                // Obtain the actual ref from the context
                mockDashBoardProvider.ref =
                    watch.read(ProviderList.dashboardProvider).ref;
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
    mockDashboardService = MockDashboardService();
    mockDashBoardProvider =
        DashBoardProvider(dashboardService: mockDashboardService, ref: null);
  });

  group('Dashboard Provider', () {
    testWidgets('Check Initial Values', (tester) async {
      await setREF(tester);

      expect(mockDashBoardProvider.getDashboardState, StateEnum.loading);
      expect(mockDashBoardProvider.hideGithubBlock, false);
      expect(mockDashBoardProvider.dashboardData, {});
    });

    testWidgets('Check Dashboard Data', (tester) async {
      await setREF(tester);
      when(() => mockDashboardService.getDashboardData(url: any(named: 'url')))
          .thenAnswer((_) async => {});
      var getDashboard = mockDashBoardProvider.getDashboard();
      expect(mockDashBoardProvider.getDashboardState, StateEnum.loading);
      await getDashboard;
      expect(mockDashBoardProvider.dashboardData, isA<Map>());
      expect(mockDashBoardProvider.getDashboardState, StateEnum.success);
    });

    testWidgets('Check Dashboard on Error', (tester) async {
      await setREF(tester);

      when(
        () => mockDashboardService.getDashboardData(url: any(named: 'url')),
      ).thenThrow(DioException(
          requestOptions:
              RequestOptions(sendTimeout: const Duration(seconds: 1))));

      await mockDashBoardProvider.getDashboard();
      expect(mockDashBoardProvider.dashboardData, isA<Map>());
      expect(mockDashBoardProvider.getDashboardState, StateEnum.error);
    });
  });
}
