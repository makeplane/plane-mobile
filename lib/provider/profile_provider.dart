import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plane/models/user_profile_model.dart';
import 'package:plane/repository/profile_provider_service.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/services/dio_service.dart';

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
  StateEnum getProfileState = StateEnum.empty;
  StateEnum updateProfileState = StateEnum.empty;
  UserProfile userProfile = UserProfile.initialize();

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
    getProfileState = StateEnum.loading;
    final response = await profileService.getProfile();
    if (response.isLeft()) {
      userProfile = response.fold(
          (userProfile) => userProfile, (error) => UserProfile.initialize());
      firstName.text = userProfile.firstName!;
      lastName.text = userProfile.lastName!;
      getProfileState = StateEnum.success;
      selectedTimeZone = userProfile.userTimezone.toString();
      TimeZoneManager.findLabelFromTimeZonesList(selectedTimeZone) ??
          'UTC, GMT';
      notifyListeners();
      return Left(userProfile);
    } else {
      log(response.fold((l) => l.toString(), (r) => r.toString()));
      getProfileState = StateEnum.error;
      notifyListeners();
      return Right(response.fold(
          (userProfile) => DioException(requestOptions: RequestOptions()),
          (error) => error));
    }
  }

  void saveCustomTheme(Map data) {
    final prefs = SharedPrefrenceServices.instance;
    prefs.setString('background', data['background']);
    prefs.setString('primary', data['primary']);
    prefs.setString('text', data['text']);
    prefs.setString('sidebarText', data['sidebarText']);
    prefs.setString('sidebarBackground', data['sidebarBackground']);
  }

  Future<Either<UserProfile, DioException>> updateProfile(
      {required Map data}) async {
    updateProfileState = StateEnum.loading;
    notifyListeners();
    final response = await profileService.updateProfile(data: data);
    if (response.isLeft()) {
      userProfile = response.fold((l) => l, (r) => UserProfile.initialize());
      updateProfileState = StateEnum.success;
      notifyListeners();
    } else {
      log(response.fold((l) => l.toString(), (r) => r.toString()));
      updateProfileState = StateEnum.error;
      notifyListeners();
    }
    return response;
  }

  Future updateIsOnBoarded({required bool val}) async {
    try {
      await DioConfig().dioServe(
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
    updateProfileState = StateEnum.loading;
    notifyListeners();
    try {
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: "${APIs.fileUpload}${userProfile.avatar!.split('/').last}/",
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      log(response.statusCode.toString());
      await updateProfile(data: {"avatar": ""});
      updateProfileState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.response.toString());
      log(e.error.toString());
      updateProfileState = StateEnum.error;
      notifyListeners();
    }
  }
}
