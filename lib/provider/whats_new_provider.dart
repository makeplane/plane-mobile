import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/core/dio/dio_service.dart';
import 'package:plane/utils/enums.dart';

class WhatsNew {
  WhatsNew(this.whatsNewData);
  List<dynamic>? whatsNewData;
}

class WhatsNewNotifier extends StateNotifier<WhatsNew> {
  WhatsNewNotifier(super.state);

  void getWhatsNew() async {
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: APIs.releaseNotes,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      final List<dynamic>? newData = response.data;
      state = WhatsNew(newData);
    } catch (e) {
      log(e.toString());
    }
  }
}
