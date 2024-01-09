import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:plane/config/const.dart';

class ConnectionService {
  static Future<bool> checkConnectivity() async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.ethernet) {
        Const.isOnline = true;
      } else if (connectivityResult == ConnectivityResult.none) {
        Const.isOnline = false;
      }
      return Const.isOnline;
    } catch (e) {
      Const.isOnline = false;
      return false;
    }
  }
}
