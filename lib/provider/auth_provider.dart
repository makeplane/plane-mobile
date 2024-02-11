// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/config/const.dart';
import 'package:plane/core/dio/dio_service.dart';
import 'package:plane/startup/dependency_resolver.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/services/shared_preference_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(ChangeNotifierProviderRef<AuthProvider> this.ref);
  Ref ref;
  DataState sendCodeState = DataState.empty;
  DataState validateCodeState = DataState.empty;
  DataState googleAuthState = DataState.empty;
  DataState signInState = DataState.empty;
  DataState signUpState = DataState.empty;
  DataState resetPassState = DataState.empty;

  Future sendMagicCode({required String email, bool resend = false}) async {
    if (!resend) {
      sendCodeState = DataState.loading;
      notifyListeners();
    }

    try {
      final response = await DioClient().request(
        hasAuth: false,
        url: APIs.baseApi + APIs.generateMagicLink,
        hasBody: true,
        httpMethod: HttpMethod.post,
        data: {
          'email': email,
        },
      );
      sendCodeState = DataState.success;
      log(response.data.toString());
      notifyListeners();
    } catch (e) {
      log(e.toString());
      sendCodeState = DataState.error;
      notifyListeners();
    }
  }

  Future<void> validateMagicCode(
      {required String key,
      required String token,
      required BuildContext context,
      required WidgetRef ref}) async {
    validateCodeState = DataState.loading;
    notifyListeners();
    try {
      log({"key": key, "token": token}.toString());
      final response = await DioClient().request(
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
      validateCodeState = DataState.success;
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
      validateCodeState = DataState.failed;
      notifyListeners();
    }
  }

  Future googleAuth(
      {required Map data,
      required BuildContext context,
      required WidgetRef ref}) async {
    try {
      googleAuthState = DataState.loading;
      notifyListeners();
      final Response response = await DioClient().request(
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
      googleAuthState = DataState.success;
      notifyListeners();
    } catch (e) {
      log(e.toString());

      CustomToast.showToast(
        context,
        message: 'Something went wrong, please try again.',
        toastType: ToastType.failure,
      );
      googleAuthState = DataState.failed;
      notifyListeners();
    }
  }

  Future signInWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context,
      required WidgetRef ref}) async {
    signInState = DataState.loading;
    notifyListeners();
    try {
      final response = await DioClient().request(
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
      signInState = DataState.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.toString());
      signInState = DataState.failed;
      notifyListeners();
      CustomToast.showToastWithColors(
          context, e.response!.data['error'].toString(),
          toastType: ToastType.failure);
    }
  }

  Future sendForgotCode({required String email}) async {
    sendCodeState = DataState.loading;
    notifyListeners();
    log(email);
    try {
      final response = await DioClient().request(
        hasAuth: false,
        url: APIs.sendForgotPassCode,
        hasBody: true,
        httpMethod: HttpMethod.post,
        data: {'email': email},
      );
      sendCodeState = DataState.success;
      log(response.data.toString());
      notifyListeners();
    } on DioException catch (e) {
      log(e.response.toString());
      sendCodeState = DataState.failed;
      notifyListeners();
    }
  }

  Future signUpWithEmailAndPassword(
      {required String email,
      required String password,
      BuildContext? context,
      required WidgetRef ref}) async {
    signUpState = DataState.loading;
    notifyListeners();
    try {
      final response = await DioClient().request(
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
      signUpState = DataState.success;
      notifyListeners();
    } catch (e) {
      log(e.toString());
      signUpState = DataState.failed;
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
    resetPassState = DataState.loading;
    notifyListeners();
    try {
      final response = await DioClient().request(
          hasAuth: false,
          url: APIs.resetPassword
              .replaceAll('\$UID', token)
              .replaceAll('\$TOKEN', token),
          hasBody: true,
          httpMethod: HttpMethod.post,
          data: {"new_password": password, "confirm_password": password});

      resetPassState = DataState.success;
      log(response.data.toString());
      ScaffoldMessenger.of(Const.globalKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully.'),
        ),
      );
      notifyListeners();
    } on DioException catch (err) {
      log(err.toString());
      resetPassState = DataState.failed;

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
