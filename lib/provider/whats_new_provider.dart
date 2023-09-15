import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/enums.dart';

class WhatsNew {
  WhatsNew(this.whatsNewData);
  List<dynamic>? whatsNewData;
}

class WhatsNewNotifier extends StateNotifier<WhatsNew> {
  WhatsNewNotifier(super.state);

  getWhatsNew() async {
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.releaseNotes,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      List<dynamic>? newData = response.data;
      state = WhatsNew(newData);
    } catch (e) {
      log(e.toString());
    }
  }
}
