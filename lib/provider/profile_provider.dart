import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plane/models/user_profile_model.dart';
import 'package:plane/models/user_setting_model.dart';
import 'package:plane/repository/profile_provider_service.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/core/dio/dio_service.dart';

import '../services/shared_preference_service.dart';
import '../utils/timezone_manager.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider({required this.profileService});
  ProfileService profileService;
  String? dropDownValue;
  String selectedTimeZone = 'UTC';
  String? slug;

  List<String> dropDownItems = [
    'Founder or learship team',
    'Product manager',
    'Designer',
    'Software developer',
    'Freelancer',
    'Other'
  ];
  String theme = 'Light';
  int roleIndex = -1;

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  DataState getProfileState = DataState.empty;
  DataState updateProfileState = DataState.empty;
  UserProfile userProfile = UserProfile.initialize();
  UserSettingModel userSetting = UserSettingModel.initialize();

  void changeIndex(int index) {
    roleIndex = index;
    dropDownValue = dropDownItems[index];
    notifyListeners();
  }

  void setState() {
    notifyListeners();
  }

  void changeTheme(String theme) {
    this.theme = theme;
    notifyListeners();
  }

  void clear() {
    firstName.clear();
    lastName.clear();
    dropDownValue = null;
    userProfile = UserProfile.initialize();
  }

  void setName() {
    userProfile = UserProfile.initialize(firstName: 'TESTER');
    notifyListeners();
  }

  Future<Either<UserProfile, DioException>> getProfile() async {
    getProfileState = DataState.loading;
    final response = await profileService.getProfile();

    return response.fold((userProfile) {
      this.userProfile = userProfile;
      SharedPrefrenceServices.setTheme(userProfile.theme!);
      SharedPrefrenceServices.setUserID(userProfile.id!);
      firstName.text = userProfile.firstName!;
      lastName.text = userProfile.lastName!;
      getProfileState = DataState.success;
      selectedTimeZone = userProfile.userTimezone.toString();
      TimeZoneManager.findLabelFromTimeZonesList(selectedTimeZone) ??
          'UTC, GMT';
      notifyListeners();
      return Left(userProfile);
    }, (error) {
      log(error.toString());
      getProfileState = DataState.error;
      notifyListeners();
      return Right(error);
    });
  }

  Future<Either<UserSettingModel, DioException>> getProfileSetting() async {
    final response = await profileService.getProfileSetting();
    return response.fold((userSetting) {
      this.userSetting = userSetting;
      return Left(userSetting);
    }, (error) {
      log(error.toString());
      return Right(error);
    });
  }

  Future<Either<UserProfile, DioException>> updateProfile(
      {required Map data}) async {
    updateProfileState = DataState.loading;
    notifyListeners();
    final response = await profileService.updateProfile(data: data);
    if (response.isLeft()) {
      userProfile = response.fold((l) => l, (r) => UserProfile.initialize());
      SharedPrefrenceServices.setTheme(userProfile.theme!);
      updateProfileState = DataState.success;
      notifyListeners();
    } else {
      log(response.fold((l) => l.toString(), (r) => r.toString()));
      updateProfileState = DataState.error;
      notifyListeners();
    }
    return response;
  }

  Future updateIsOnBoarded({required bool val}) async {
    try {
      await DioClient().request(
          hasAuth: true,
          url: APIs.isOnboarded,
          hasBody: true,
          httpMethod: HttpMethod.patch,
          data: {"is_onboarded": val});
      userProfile.isOnboarded = val;
      return val;
    } on DioException catch (e) {
      log(e.error.toString());
    }
  }

  Future deleteAvatar() async {
    updateProfileState = DataState.loading;
    notifyListeners();
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: "${APIs.fileUpload}${userProfile.avatar!.split('/').last}/",
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      log(response.statusCode.toString());
      await updateProfile(data: {"avatar": ""});
      updateProfileState = DataState.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.response.toString());
      log(e.error.toString());
      updateProfileState = DataState.error;
      notifyListeners();
    }
  }
}
