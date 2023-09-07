import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:plane/config/const.dart';

class ConnectionService {
  Future checkConnectivity() async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        Const.isOnline = true;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        Const.isOnline = true;
      } else if (connectivityResult == ConnectivityResult.ethernet) {
        Const.isOnline = true;
      } else if (connectivityResult == ConnectivityResult.none) {
        Const.isOnline = false;
      }
    } catch (e) {
      log("DIO SERVICE ERROR");
    }
  }
}
