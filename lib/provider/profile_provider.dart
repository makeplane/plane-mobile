import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plane_startup/models/user_profile_model.dart';
import 'package:plane_startup/services/shared_preference_service.dart';
import 'package:plane_startup/utils/enums.dart';

import 'package:plane_startup/config/apis.dart';
import 'package:plane_startup/services/dio_service.dart';

class ProfileProvider extends ChangeNotifier {
  // ProfileProvider(ChangeNotifierProviderRef<ProfileProvider> re) {
  //   if (re.exists(ProviderList.profileProvider)) {
  //     return;
  //   }
  //   ref = re;
  //   print("Called");
  // }
  // static Ref? ref;
  String? dropDownValue;
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

  void changeTheme(String theme) {
    this.theme = theme;
    notifyListeners();
  }

  void clear() {
    firstName.clear();
    lastName.clear();
    dropDownValue = null;
    slug = null;
    userProfile = UserProfile.initialize();
  }

  Future getProfile() async {
    getProfileState = StateEnum.loading;

    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: '${APIs.baseApi}${APIs.profile}',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      userProfile = UserProfile.fromMap(response.data);
      // if (userProfile.theme != null && userProfile.theme!.length > 1) {
      //   saveCustomTheme(userProfile.theme!);
      // }
      firstName.text = userProfile.firstName!;
      lastName.text = userProfile.lastName!;
      // dropDownValue = userProfile.role!;
      //  await Future.delayed(Duration(seconds: 1));
      getProfileState = StateEnum.success;
      slug = response.data["slug"];
      //log('----- SUCCESS ------ $slug');
      notifyListeners();

      // return response.data;
    } catch (e) {
      // ScaffoldMessenger.of(Const.globalKey.currentContext!).showSnackBar(
      //   const SnackBar(
      //     content: Text('Something went wrong, please try again'),
      //   ),
      // );
      log(e.toString());
      getProfileState = StateEnum.error;
      notifyListeners();
    }
  }

  void saveCustomTheme(data) {
    var prefs = SharedPrefrenceServices.sharedPreferences!;
    prefs.setString('background', data['background']);
    prefs.setString('primary', data['primary']);
    prefs.setString('text', data['text']);
    prefs.setString('sidebarText', data['sidebarText']);
    prefs.setString('sidebarBackground', data['sidebarBackground']);
  }

  Future updateProfile({required Map data}) async {
    updateProfileState = StateEnum.loading;
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
          hasAuth: true,
          url: APIs.baseApi + APIs.profile,
          hasBody: true,
          httpMethod: HttpMethod.patch,
          data: data);
      // log(response.data.toString());
      userProfile = UserProfile.fromMap(response.data);
      // if (userProfile.theme != null && userProfile.theme!.length > 1) {
      //   saveCustomTheme(userProfile.theme!);
      // }
      updateProfileState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.error.toString());
      updateProfileState = StateEnum.error;
      notifyListeners();
    }
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
    } on DioException catch (e) {
      log(e.error.toString());
    }
  }

  Future deleteAvatar() async {
    updateProfileState = StateEnum.loading;
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
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
