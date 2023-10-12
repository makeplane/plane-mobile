// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/config/const.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/startup/dependency_resolver.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/services/shared_preference_service.dart';

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
      required BuildContext context,
      required WidgetRef ref}) async {
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
      // SharedPrefrenceServices.setUserID(response.data["user"]['id']);

      await DependencyResolver.resolve(ref: ref);
      validateCodeState = StateEnum.success;
      log(response.data.toString());
      notifyListeners();
    } on DioException catch (error) {
      log(error.toString());
      String message = error.response?.data['error'] ?? 'Something went wrong!';
      CustomToast.showToastWithColors(
        context,
        message,
        toastType: ToastType.failure,
        maxHeight: 100,
      );
      validateCodeState = StateEnum.failed;
      notifyListeners();
    }
  }

  Future googleAuth(
      {required Map data,
      required BuildContext context,
      required WidgetRef ref}) async {
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
      // SharedPrefrenceServices.setUserID(response.data["user"]['id']);
      await DependencyResolver.resolve(ref: ref);
      googleAuthState = StateEnum.success;
      notifyListeners();
    } catch (e) {
      log(e.toString());

      CustomToast.showToast(
        context,
        message: 'Something went wrong, please try again.',
        toastType: ToastType.failure,
      );
      googleAuthState = StateEnum.failed;
      notifyListeners();
    }
  }

  Future signInWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context,
      required WidgetRef ref}) async {
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
      // SharedPrefrenceServices.setUserID(response.data["user"]['id']);
      await DependencyResolver.resolve(ref: ref);
      signInState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.toString());
      signInState = StateEnum.failed;
      notifyListeners();
      CustomToast.showToastWithColors(
          context, e.response!.data['error'].toString(),
          toastType: ToastType.failure);
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
      BuildContext? context,
      required WidgetRef ref}) async {
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
      // SharedPrefrenceServices.setUserID(response.data["user"]['id']);
      await DependencyResolver.resolve(ref: ref);
      signUpState = StateEnum.success;
      notifyListeners();
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
