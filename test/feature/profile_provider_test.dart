import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plane/models/user_profile_model.dart';
import 'package:plane/provider/profile_provider.dart';
import 'package:plane/repository/profile_provider_service.dart';
import 'package:plane/utils/enums.dart';

class MockProfileService extends Mock implements ProfileService {}

void main() {
  late ProfileService mockProfileService;
  late ProfileProvider profileProvider;
  setUp(() {
    mockProfileService = MockProfileService();
    profileProvider = ProfileProvider(profileService: mockProfileService);
  });

  test('GET Profile', () async {
    when(() => mockProfileService.getProfile()).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 1500));
      return Left(UserProfile.initialize(firstName: 'TESTING'));
    });
    final getProfile = profileProvider.getProfile();
    expect(profileProvider.getProfileState, DataState.loading);
    await getProfile;
    expect(profileProvider.getProfileState, DataState.success);
    expect(profileProvider.userProfile.firstName, 'TESTING');
  });

  test('ERROR GET Profile', () async {
    when(() => mockProfileService.getProfile()).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 1500));
      return Right(DioException(requestOptions: RequestOptions()));
    });
    final getProfile = profileProvider.getProfile();
    expect(profileProvider.getProfileState, DataState.loading);
    await getProfile;
    expect(profileProvider.getProfileState, DataState.error);
    expect(profileProvider.userProfile.firstName, '');
  });
}
