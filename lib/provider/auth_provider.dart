import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/config/apis.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/services/dio_service.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/services/shared_preference_service.dart';

import 'provider_list.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(ChangeNotifierProviderRef<AuthProvider> this.ref);
  Ref ref;
  StateEnum sendCodeState = StateEnum.empty;
  StateEnum validateCodeState = StateEnum.empty;
  StateEnum googleAuthState = StateEnum.empty;
  StateEnum signInState = StateEnum.empty;
  StateEnum signUpState = StateEnum.empty;
  StateEnum resetPassState = StateEnum.empty;

  Future sendMagicCode(String email) async {
    sendCodeState = StateEnum.loading;
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
        hasAuth: false,
        url: APIs.baseApi + APIs.generateMagicLink,
        hasBody: true,
        httpMethod: HttpMethod.post,
        data: {
          'email': email,
        },
      );
      sendCodeState = StateEnum.success;
      log(response.data.toString());
      notifyListeners();
    } catch (e) {
      log(e.toString());
      sendCodeState = StateEnum.failed;
      notifyListeners();
    }
  }

  Future validateMagicCode({required String key, required token}) async {
    validateCodeState = StateEnum.loading;
    notifyListeners();
    try {
      log({"key": key, "token": token}.toString());
      var response = await DioConfig().dioServe(
          hasAuth: false,
          url: APIs.baseApi + APIs.magicValidate,
          hasBody: true,
          httpMethod: HttpMethod.post,
          data: {"key": key, "token": token});
      Const.appBearerToken = response.data["access_token"];
      SharedPrefrenceServices.sharedPreferences!
          .setString("token", response.data["access_token"]);
      // await ref.read(ProviderList.profileProvider).getProfile();
      // .userProfile = UserProfile.fromMap(response.data);
      validateCodeState = StateEnum.success;

      await ref
          .read(ProviderList.profileProvider)
          .getProfile()
          .then((value) async {
        if (ref.read(ProviderList.profileProvider).getProfileState ==
            StateEnum.success) {
          await ref
              .read(ProviderList.workspaceProvider)
              .getWorkspaces()
              .then((value) {
            if (ref.read(ProviderList.workspaceProvider).workspaces.isEmpty ||
                ref
                        .read(ProviderList.profileProvider)
                        .userProfile
                        .lastWorkspaceId ==
                    null) {
              return;
            }
            ref.read(ProviderList.dashboardProvider).getDashboard();
            log(ref
                .read(ProviderList.profileProvider)
                .userProfile
                .lastWorkspaceId
                .toString());

            ref.read(ProviderList.projectProvider).getProjects(
                slug: ref
                    .read(ProviderList.workspaceProvider)
                    .workspaces
                    .where((element) =>
                        element['id'] ==
                        ref
                            .read(ProviderList.profileProvider)
                            .userProfile
                            .lastWorkspaceId)
                    .first['slug']);
            ref.read(ProviderList.projectProvider).favouriteProjects(
                index: 0,
                slug: ref
                    .read(ProviderList.workspaceProvider)
                    .workspaces
                    .where((element) =>
                        element['id'] ==
                        ref
                            .read(ProviderList.profileProvider)
                            .userProfile
                            .lastWorkspaceId)
                    .first['slug'],
                method: HttpMethod.get,
                projectID: "");
          });
        } else {
          Const.appBearerToken = null;
          SharedPrefrenceServices.sharedPreferences!.clear();
          validateCodeState = StateEnum.failed;
          notifyListeners();
          CustomToast().showSimpleToast(
            'Something went wrong while fetching your data, Please try again.',
          );
        }
      });
      log(response.data.toString());
      notifyListeners();
    } catch (e) {
      Object? message;
      if (e is DioException) {
        var errorResponse = e.error;
        message = errorResponse;
        log(e.error.toString());
        CustomToast().showSimpleToast(
          message.toString(),
        );
      } else {
        message = e;
      }
      validateCodeState = StateEnum.failed;

      log(e.toString());
      notifyListeners();
    }
  }

  Future googleAuth({required Map data, required BuildContext context}) async {
    try {
      googleAuthState = StateEnum.loading;
      notifyListeners();
      Response response = await DioConfig().dioServe(
        hasAuth: false,
        url: APIs.googleAuth,
        hasBody: true,
        httpMethod: HttpMethod.post,
        data: data,
      );
      Const.appBearerToken = response.data["access_token"];
      SharedPrefrenceServices.sharedPreferences!
          .setString("token", response.data["access_token"]);
      googleAuthState = StateEnum.success;
      notifyListeners();
      await ref
          .read(ProviderList.profileProvider)
          .getProfile()
          .then((value) async {
        if (ref.read(ProviderList.profileProvider).getProfileState ==
            StateEnum.success) {
          await ref
              .read(ProviderList.workspaceProvider)
              .getWorkspaces()
              .then((value) {
            if (ref.read(ProviderList.workspaceProvider).workspaces.isEmpty ||
                ref
                        .read(ProviderList.profileProvider)
                        .userProfile
                        .lastWorkspaceId ==
                    null) {
              return;
            }
            log(ref
                .read(ProviderList.profileProvider)
                .userProfile
                .lastWorkspaceId
                .toString());

            ref.read(ProviderList.projectProvider).getProjects(
                slug: ref
                    .read(ProviderList.workspaceProvider)
                    .workspaces
                    .where((element) =>
                        element['id'] ==
                        ref
                            .read(ProviderList.profileProvider)
                            .userProfile
                            .lastWorkspaceId)
                    .first['slug']);
            ref.read(ProviderList.projectProvider).favouriteProjects(
                index: 0,
                slug: ref
                    .read(ProviderList.workspaceProvider)
                    .workspaces
                    .where((element) =>
                        element['id'] ==
                        ref
                            .read(ProviderList.profileProvider)
                            .userProfile
                            .lastWorkspaceId)
                    .first['slug'],
                method: HttpMethod.get,
                projectID: "");
          });
        } else {
          Const.appBearerToken = null;
          SharedPrefrenceServices.sharedPreferences!.clear();
          validateCodeState = StateEnum.failed;
          notifyListeners();
          CustomToast().showSimpleToast(
            'Something went wrong while fetching your data, Please try again.',
          );
        }
      });
    } catch (e) {
      log(e.toString());
      CustomToast().showToast(
          context,
          'Something went wrong, please try again.',
          ref.read(ProviderList.themeProvider),
          toastType: ToastType.failure);
      googleAuthState = StateEnum.failed;
      notifyListeners();
    }
  }

  Future signInWithEmailAndPassword(
      {required String email, required String password}) async {
    signInState = StateEnum.loading;
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
        hasAuth: false,
        url: APIs.signIn,
        hasBody: true,
        httpMethod: HttpMethod.post,
        data: {
          'email': email,
          'password': password,
          'medium': 'email',
        },
      );
      Const.appBearerToken = response.data["access_token"];
      SharedPrefrenceServices.sharedPreferences!
          .setString("token", response.data["access_token"]);
      signInState = StateEnum.success;
      notifyListeners();
      await ref
          .read(ProviderList.profileProvider)
          .getProfile()
          .then((value) async {
        if (ref.read(ProviderList.profileProvider).getProfileState ==
            StateEnum.success) {
          await ref
              .read(ProviderList.workspaceProvider)
              .getWorkspaces()
              .then((value) {
            if (ref.read(ProviderList.workspaceProvider).workspaces.isEmpty ||
                ref
                        .read(ProviderList.profileProvider)
                        .userProfile
                        .lastWorkspaceId ==
                    null) {
              return;
            }
            log(ref
                .read(ProviderList.profileProvider)
                .userProfile
                .lastWorkspaceId
                .toString());

            ref.read(ProviderList.projectProvider).getProjects(
                slug: ref
                    .read(ProviderList.workspaceProvider)
                    .workspaces
                    .where((element) =>
                        element['id'] ==
                        ref
                            .read(ProviderList.profileProvider)
                            .userProfile
                            .lastWorkspaceId)
                    .first['slug']);
            ref.read(ProviderList.projectProvider).favouriteProjects(
                index: 0,
                slug: ref
                    .read(ProviderList.workspaceProvider)
                    .workspaces
                    .where((element) =>
                        element['id'] ==
                        ref
                            .read(ProviderList.profileProvider)
                            .userProfile
                            .lastWorkspaceId)
                    .first['slug'],
                method: HttpMethod.get,
                projectID: "");
          });
        } else {
          Const.appBearerToken = null;
          SharedPrefrenceServices.sharedPreferences!.clear();

          notifyListeners();
          CustomToast().showSimpleToast(
            'Something went wrong while fetching your data, Please try again.',
          );
        }
      });
    } on DioException catch (e) {
      log(e.toString());
      signInState = StateEnum.failed;

      CustomToast().showSimpleToast(
        e.error.toString(),
      );
      CustomToast().showSimpleToast(
        'Something went wrong, please try again.',
      );

      notifyListeners();
    }
  }

  Future sendForgotCode({required String email}) async {
    sendCodeState = StateEnum.loading;
    notifyListeners();
    log(email);
    try {
      var response = await DioConfig().dioServe(
        hasAuth: false,
        url: APIs.sendForgotPassCode,
        hasBody: true,
        httpMethod: HttpMethod.post,
        data: {'email': email},
      );
      sendCodeState = StateEnum.success;
      log(response.data.toString());
      notifyListeners();
    } on DioException catch (e) {
      log(e.response.toString());
      sendCodeState = StateEnum.failed;
      notifyListeners();
    }
  }

  Future signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    signUpState = StateEnum.loading;
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
        hasAuth: false,
        url: APIs.signUp,
        hasBody: true,
        httpMethod: HttpMethod.post,
        data: {
          'email': email,
          'password': password,
        },
      );
      log('signUp response: ${response.data}');
      Const.appBearerToken = response.data["access_token"];
      SharedPrefrenceServices.sharedPreferences!
          .setString("token", response.data["access_token"]);
      signUpState = StateEnum.success;
      notifyListeners();
      await ref
          .read(ProviderList.profileProvider)
          .getProfile()
          .then((value) async {
        if (ref.read(ProviderList.profileProvider).getProfileState ==
            StateEnum.success) {
          log('no error in getProfile');
          await ref
              .read(ProviderList.workspaceProvider)
              .getWorkspaces()
              .then((value) {
            if (ref.read(ProviderList.workspaceProvider).workspaces.isEmpty ||
                ref
                        .read(ProviderList.workspaceProvider)
                        .workspaceInvitationState ==
                    StateEnum.error ||
                ref
                        .read(ProviderList.profileProvider)
                        .userProfile
                        .lastWorkspaceId ==
                    null) {
              return;
            }
            ref.read(ProviderList.dashboardProvider).getDashboard();
            log(ref
                .read(ProviderList.profileProvider)
                .userProfile
                .lastWorkspaceId
                .toString());

            ref.read(ProviderList.projectProvider).getProjects(
                slug: ref
                    .read(ProviderList.workspaceProvider)
                    .workspaces
                    .where((element) =>
                        element['id'] ==
                        ref
                            .read(ProviderList.profileProvider)
                            .userProfile
                            .lastWorkspaceId)
                    .first['slug']);
            ref.read(ProviderList.projectProvider).favouriteProjects(
                index: 0,
                slug: ref
                    .read(ProviderList.workspaceProvider)
                    .workspaces
                    .where((element) =>
                        element['id'] ==
                        ref
                            .read(ProviderList.profileProvider)
                            .userProfile
                            .lastWorkspaceId)
                    .first['slug'],
                method: HttpMethod.get,
                projectID: "");
          });
        } else {
          Const.appBearerToken = null;
          SharedPrefrenceServices.sharedPreferences!.clear();

          notifyListeners();
          CustomToast().showSimpleToast(
            'Something went wrong while fetching your data, Please try again.',
          );
        }
      });
    } catch (e) {
      log(e.toString());
      signUpState = StateEnum.failed;
      notifyListeners();
      if (e is DioException) {
        CustomToast().showSimpleToast(
          e.error.toString(),
        );
      } else {
        CustomToast().showSimpleToast(
          'Something went wrong, please try again.',
        );
      }
    }
  }

  Future resetPassword(
      {required String password, required String token}) async {
    resetPassState = StateEnum.loading;
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
          hasAuth: false,
          url: APIs.resetPassword
              .replaceAll('\$UID', token)
              .replaceAll('\$TOKEN', token),
          hasBody: true,
          httpMethod: HttpMethod.post,
          data: {"new_password": password, "confirm_password": password});

      resetPassState = StateEnum.success;
      log(response.data.toString());
      ScaffoldMessenger.of(Const.globalKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully.'),
        ),
      );
      notifyListeners();
    } on DioException catch (err) {
      log(err.toString());
      resetPassState = StateEnum.failed;

      ScaffoldMessenger.of(Const.globalKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(err.response!.data['error']),
          backgroundColor: Colors.red,
        ),
      );
      notifyListeners();
    }
  }
}
