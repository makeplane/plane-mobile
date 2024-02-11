import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/config/const.dart';
import 'package:plane/utils/enums.dart';

class FileUploadProvider extends ChangeNotifier {
  FileUploadProvider(ChangeNotifierProviderRef<FileUploadProvider> this.ref);
  Ref? ref;
  static String? _downloadUrl;
  DataState fileUploadState = DataState.empty;

  Future<String?> uploadFile(File pickedFile, String fileType) async {
    fileUploadState = DataState.loading;
    notifyListeners();
    final type = pickedFile.path.split('.').last;

    final dio = Dio();
    final formData = FormData.fromMap({
      "asset": await MultipartFile.fromFile(pickedFile.path,
          filename: 'fileName.$type', contentType: MediaType(fileType, type)),
      "attributes": jsonEncode("{}")
    });
    final token = Const.accessToken;
    final response = await dio
        .post(APIs.fileUpload,
            data: formData,
            onSendProgress: (sent, total) {},
            options: Options(headers: {
              "Content-type": "multipart/form-data",
              "Authorization": "Bearer $token"
            }))
        .catchError((e) {
      fileUploadState = DataState.error;
      notifyListeners();
      log(e);
      throw e;
    });
    _downloadUrl = response.data['asset'];

    fileUploadState = DataState.success;

    notifyListeners();
    return _downloadUrl;
  }

  String? get downloadUrl => _downloadUrl;
}
