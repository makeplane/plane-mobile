// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/Authentication/google_sign_in.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/config/const.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/services/shared_preference_service.dart';

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

  Future sendMagicCode({required String email, bool resend = false}) async {
    if (!resend) {
      sendCodeState = StateEnum.loading;
      notifyListeners();
    }

    try {
      final response = await DioConfig().dioServe(
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
      sendCodeState = StateEnum.error;
      notifyListeners();
    }
  }

  Future<void> validateMagicCode(
      {required String key,
      required String token,
      BuildContext? context}) async {
    validateCodeState = StateEnum.loading;
    notifyListeners();
    try {
      log({"key": key, "token": token}.toString());
      final response = await DioConfig().dioServe(
          hasAuth: false,
          url: APIs.baseApi + APIs.magicValidate,
          hasBody: true,
          httpMethod: HttpMethod.post,
          data: {"key": key, "token": token});

      SharedPrefrenceServices.setTokens(
          accessToken: response.data["access_token"],
          refreshToken: response.data["refresh_token"]);
      SharedPrefrenceServices.setUserID(response.data["user"]['id']);

      validateCodeState = StateEnum.success;
      await ref
          .read(ProviderList.profileProvider)
          .getProfile()
          .then((value) async {
        final prov = ref.read(ProviderList.profileProvider);
        final themeProv = ref.read(ProviderList.themeProvider);
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
            final theme = prov.userProfile.theme;

            if (prov.userProfile.theme != null) {
              if (prov.userProfile.theme!['theme'] == 'dark') {
                theme!['theme'] = fromTHEME(theme: THEME.dark);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'light') {
                theme!['theme'] = fromTHEME(theme: THEME.light);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'system') {
                theme!['theme'] = fromTHEME(theme: THEME.systemPreferences);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'dark-contrast') {
                theme!['theme'] = fromTHEME(theme: THEME.darkHighContrast);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'light-contrast') {
                theme!['theme'] = fromTHEME(theme: THEME.lightHighContrast);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'custom') {
                theme!['theme'] = fromTHEME(theme: THEME.custom);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else {
                themeProv.changeTheme(data: {
                  'theme': {
                    'primary': prov.userProfile.theme!['primary'],
                    'background': prov.userProfile.theme!['background'],
                    'text': prov.userProfile.theme!['text'],
                    'sidebarText': prov.userProfile.theme!['sidebarText'],
                    'sidebarBackground':
                        prov.userProfile.theme!['sidebarBackground'],
                    'theme': 'custom',
                  }
                }, context: null);
              }
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
            ref
                .read(ProviderList.myIssuesProvider)
                .getMyIssuesView()
                .then((value) {
              ref
                  .read(ProviderList.myIssuesProvider)
                  .filterIssues(assigned: true);
            });

            ref.read(ProviderList.notificationProvider).getUnreadCount();

            ref
                .read(ProviderList.notificationProvider)
                .getNotifications(type: 'assigned');
            ref
                .read(ProviderList.notificationProvider)
                .getNotifications(type: 'created');
            ref
                .read(ProviderList.notificationProvider)
                .getNotifications(type: 'watching');
            ref
                .read(ProviderList.notificationProvider)
                .getNotifications(type: 'unread', getUnread: true);
            ref
                .read(ProviderList.notificationProvider)
                .getNotifications(type: 'archived', getArchived: true);
            ref
                .read(ProviderList.notificationProvider)
                .getNotifications(type: 'snoozed', getSnoozed: true);
          });
        } else {
          Const.accessToken = null;
          Const.userId = null;
          SharedPrefrenceServices.instance.clear();
          validateCodeState = StateEnum.error;
          notifyListeners();
          if (context != null) {
            CustomToast.showToastWithColors(context,
                'Something went wrong while fetching your data, Please try again.',
                toastType: ToastType.failure);
          }
        }
      });

      log(response.data.toString());
      notifyListeners();
    } catch (e) {
      Object? message;
      if (e is DioException) {
        final errorResponse = e.error;
        message = errorResponse;
        log(message.toString());
        // CustomToast.showSimpleToast(
        //   message.toString(),
        // );

        if (context != null) {
          CustomToast.showToastWithColors(
              context, e.response!.data['error'].toString(),
              toastType: ToastType.failure);
        }
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
      final Response response = await DioConfig().dioServe(
        hasAuth: false,
        url: APIs.googleAuth,
        hasBody: true,
        httpMethod: HttpMethod.post,
        data: data,
      );
      SharedPrefrenceServices.setTokens(
          accessToken: response.data["access_token"],
          refreshToken: response.data["refresh_token"]);
      SharedPrefrenceServices.setUserID(response.data["user"]['id']);
      googleAuthState = StateEnum.success;
      notifyListeners();
      await ref
          .read(ProviderList.profileProvider)
          .getProfile()
          .then((value) async {
        final prov = ref.read(ProviderList.profileProvider);
        final themeProv = ref.read(ProviderList.themeProvider);
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
            final theme = prov.userProfile.theme;

            if (prov.userProfile.theme != null) {
              if (prov.userProfile.theme!['theme'] == 'dark') {
                theme!['theme'] = fromTHEME(theme: THEME.dark);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'light') {
                theme!['theme'] = fromTHEME(theme: THEME.light);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'system') {
                theme!['theme'] = fromTHEME(theme: THEME.systemPreferences);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'dark-contrast') {
                theme!['theme'] = fromTHEME(theme: THEME.darkHighContrast);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'light-contrast') {
                theme!['theme'] = fromTHEME(theme: THEME.lightHighContrast);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'custom') {
                theme!['theme'] = fromTHEME(theme: THEME.custom);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else {
                themeProv.changeTheme(data: {
                  'theme': {
                    'primary': prov.userProfile.theme!['primary'],
                    'background': prov.userProfile.theme!['background'],
                    'text': prov.userProfile.theme!['text'],
                    'sidebarText': prov.userProfile.theme!['sidebarText'],
                    'sidebarBackground':
                        prov.userProfile.theme!['sidebarBackground'],
                    'theme': 'custom',
                  }
                }, context: null);
              }
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
            ref
                .read(ProviderList.myIssuesProvider)
                .getMyIssuesView()
                .then((value) {
              ref
                  .read(ProviderList.myIssuesProvider)
                  .filterIssues(assigned: true);

              ref.read(ProviderList.notificationProvider).getUnreadCount();

              ref
                  .read(ProviderList.notificationProvider)
                  .getNotifications(type: 'assigned');
              ref
                  .read(ProviderList.notificationProvider)
                  .getNotifications(type: 'created');
              ref
                  .read(ProviderList.notificationProvider)
                  .getNotifications(type: 'watching');
              ref
                  .read(ProviderList.notificationProvider)
                  .getNotifications(type: 'unread', getUnread: true);
              ref
                  .read(ProviderList.notificationProvider)
                  .getNotifications(type: 'archived', getArchived: true);
              ref
                  .read(ProviderList.notificationProvider)
                  .getNotifications(type: 'snoozed', getSnoozed: true);
            });
          });
        } else {
          Const.accessToken = null;
          Const.userId = null;
          SharedPrefrenceServices.instance.clear();
          GoogleSignInApi.logout();
          validateCodeState = StateEnum.failed;
          notifyListeners();
          // ignore: unnecessary_null_comparison
          if (context != null) {
            CustomToast.showToastWithColors(context,
                'Something went wrong while fetching your data, Please try again.',
                toastType: ToastType.failure);
          }
        }
      });
    } catch (e) {
      log(e.toString());

      CustomToast.showToast(context,
          message: 'Something went wrong, please try again.',
          toastType: ToastType.failure);
      googleAuthState = StateEnum.failed;
      notifyListeners();
    }
  }

  Future signInWithEmailAndPassword(
      {required String email,
      required String password,
      BuildContext? context}) async {
    signInState = StateEnum.loading;
    notifyListeners();
    try {
      final response = await DioConfig().dioServe(
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
      SharedPrefrenceServices.setTokens(
          accessToken: response.data["access_token"],
          refreshToken: response.data["refresh_token"]);
      SharedPrefrenceServices.setUserID(response.data["user"]['id']);
      signInState = StateEnum.success;
      notifyListeners();
      await ref
          .read(ProviderList.profileProvider)
          .getProfile()
          .then((value) async {
        final prov = ref.read(ProviderList.profileProvider);
        final themeProv = ref.read(ProviderList.themeProvider);
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

            final theme = prov.userProfile.theme;

            if (prov.userProfile.theme != null) {
              if (prov.userProfile.theme!['theme'] == 'dark') {
                theme!['theme'] = fromTHEME(theme: THEME.dark);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'light') {
                theme!['theme'] = fromTHEME(theme: THEME.light);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'system') {
                theme!['theme'] = fromTHEME(theme: THEME.systemPreferences);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'dark-contrast') {
                theme!['theme'] = fromTHEME(theme: THEME.darkHighContrast);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'light-contrast') {
                theme!['theme'] = fromTHEME(theme: THEME.lightHighContrast);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'custom') {
                theme!['theme'] = fromTHEME(theme: THEME.custom);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else {
                themeProv.changeTheme(data: {
                  'theme': {
                    'primary': prov.userProfile.theme!['primary'],
                    'background': prov.userProfile.theme!['background'],
                    'text': prov.userProfile.theme!['text'],
                    'sidebarText': prov.userProfile.theme!['sidebarText'],
                    'sidebarBackground':
                        prov.userProfile.theme!['sidebarBackground'],
                    'theme': 'custom',
                  }
                }, context: null);
              }
            }

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
            ref
                .read(ProviderList.myIssuesProvider)
                .getMyIssuesView()
                .then((value) {
              ref
                  .read(ProviderList.myIssuesProvider)
                  .filterIssues(assigned: true);
            });

            ref.read(ProviderList.notificationProvider).getUnreadCount();

            ref
                .read(ProviderList.notificationProvider)
                .getNotifications(type: 'assigned');
            ref
                .read(ProviderList.notificationProvider)
                .getNotifications(type: 'created');
            ref
                .read(ProviderList.notificationProvider)
                .getNotifications(type: 'watching');
            ref
                .read(ProviderList.notificationProvider)
                .getNotifications(type: 'unread', getUnread: true);
            ref
                .read(ProviderList.notificationProvider)
                .getNotifications(type: 'archived', getArchived: true);
            ref
                .read(ProviderList.notificationProvider)
                .getNotifications(type: 'snoozed', getSnoozed: true);
          });
        } else {
          Const.accessToken = null;
          Const.userId = null;
          SharedPrefrenceServices.instance.clear();

          notifyListeners();
          if (context != null) {
            CustomToast.showToastWithColors(context,
                'Something went wrong while fetching your data, Please try again.',
                toastType: ToastType.failure);
          }
        }
      });
    } on DioException catch (e) {
      log(e.toString());
      signInState = StateEnum.failed;

      notifyListeners();

      if (context != null) {
        CustomToast.showToastWithColors(context, e.error.toString(),
            toastType: ToastType.failure);
      }
      if (context != null) {
        CustomToast.showToastWithColors(
            context, 'Something went wrong, please try again.',
            toastType: ToastType.failure);
      }
    }
  }

  Future sendForgotCode({required String email}) async {
    sendCodeState = StateEnum.loading;
    notifyListeners();
    log(email);
    try {
      final response = await DioConfig().dioServe(
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
      {required String email,
      required String password,
      BuildContext? context}) async {
    signUpState = StateEnum.loading;
    notifyListeners();
    try {
      final response = await DioConfig().dioServe(
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
      SharedPrefrenceServices.setTokens(
          accessToken: response.data["access_token"],
          refreshToken: response.data["refresh_token"]);
      SharedPrefrenceServices.setUserID(response.data["user"]['id']);
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
            final prov = ref.read(ProviderList.profileProvider);
            final themeProv = ref.read(ProviderList.themeProvider);
            final theme = prov.userProfile.theme;

            if (prov.userProfile.theme != null) {
              if (prov.userProfile.theme!['theme'] == 'dark') {
                theme!['theme'] = fromTHEME(theme: THEME.dark);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'light') {
                theme!['theme'] = fromTHEME(theme: THEME.light);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'system') {
                theme!['theme'] = fromTHEME(theme: THEME.systemPreferences);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'dark-contrast') {
                theme!['theme'] = fromTHEME(theme: THEME.darkHighContrast);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'light-contrast') {
                theme!['theme'] = fromTHEME(theme: THEME.lightHighContrast);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else if (prov.userProfile.theme!['theme'] == 'custom') {
                theme!['theme'] = fromTHEME(theme: THEME.custom);
                themeProv.changeTheme(data: {'theme': theme}, context: null);
              } else {
                themeProv.changeTheme(data: {
                  'theme': {
                    'primary': prov.userProfile.theme!['primary'],
                    'background': prov.userProfile.theme!['background'],
                    'text': prov.userProfile.theme!['text'],
                    'sidebarText': prov.userProfile.theme!['sidebarText'],
                    'sidebarBackground':
                        prov.userProfile.theme!['sidebarBackground'],
                    'theme': 'custom',
                  }
                }, context: null);
              }
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
            ref
                .read(ProviderList.myIssuesProvider)
                .getMyIssuesView()
                .then((value) {
              ref
                  .read(ProviderList.myIssuesProvider)
                  .filterIssues(assigned: true);
            });

            ref.read(ProviderList.notificationProvider).getUnreadCount();

            ref
                .read(ProviderList.notificationProvider)
                .getNotifications(type: 'assigned');
            ref
                .read(ProviderList.notificationProvider)
                .getNotifications(type: 'created');
            ref
                .read(ProviderList.notificationProvider)
                .getNotifications(type: 'watching');
            ref
                .read(ProviderList.notificationProvider)
                .getNotifications(type: 'unread', getUnread: true);
            ref
                .read(ProviderList.notificationProvider)
                .getNotifications(type: 'archived', getArchived: true);
            ref
                .read(ProviderList.notificationProvider)
                .getNotifications(type: 'snoozed', getSnoozed: true);
          });
        } else {
          Const.accessToken = null;
          Const.userId = null;
          SharedPrefrenceServices.instance.clear();

          notifyListeners();
          if (context != null) {
            CustomToast.showToastWithColors(context,
                'Something went wrong while fetching your data, Please try again.',
                toastType: ToastType.failure);
          }
        }
      });
    } catch (e) {
      log(e.toString());
      signUpState = StateEnum.failed;
      notifyListeners();
      if (e is DioException) {
        if (context != null) {
          CustomToast.showToast(
            context,
            message: e.error.toString(),
            toastType: ToastType.failure,
          );
        }
      } else {
        if (context != null) {
          CustomToast.showToast(
            context,
            message: "Something went wrong, please try again.",
            toastType: ToastType.failure,
          );
        }
      }
    }
  }

  Future resetPassword(
      {required String password, required String token}) async {
    resetPassState = StateEnum.loading;
    notifyListeners();
    try {
      final response = await DioConfig().dioServe(
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
