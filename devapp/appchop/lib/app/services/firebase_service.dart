import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  void init() async {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
      var token = await FirebaseMessaging.instance.getToken();
      /*print("CREANDO TOKEN");
      print(token);*/
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _onMessage(message.data);
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _onMessage(message.data, true);
      });
    } catch(e) {
      return;
    }
  }

  void _onMessage(Map<String, dynamic> notificacion, [bool open = false]) {
    if(open) {

    }
  }
}

@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {
  try {
    
  } catch(e) {
    return;
  }
}