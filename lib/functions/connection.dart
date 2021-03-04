import 'dart:io';

/*
  The Function checks if the device is connected to the internet and return a boolean accordingly 
  input: {}
  return : bool
*/

Future<bool> check() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}
