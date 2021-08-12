import 'dart:io';

Future<bool> checkInternetConnection() async {

  String address = "google.com";

  assert(address != null || address != '');

  try {
    final result = await InternetAddress.lookup(address);

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

      return true;
    }
    else {

      return false;
    }
  }
  on SocketException catch (_) {

    return false;
  }
}