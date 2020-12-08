import 'package:connectivity/connectivity.dart';

class Network {
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}

class NetworkHelper {
  static Stream<ConnectivityResult> networkListner() {
    return Connectivity().onConnectivityChanged;
  }
}
