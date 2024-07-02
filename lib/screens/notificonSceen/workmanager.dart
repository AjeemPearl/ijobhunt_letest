import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirbaseMessage {
  static String firebasetoken = '';
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static bool _initialized = false;

  static Future<void> init() async {
    if (!_initialized) {
      _firebaseMessaging.requestPermission();
      String? token = await _firebaseMessaging.getToken();
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('firbasetoken', token!);

      print("FirebaseMessaging token: $token");
      _initialized = true;
    }
  }
}
