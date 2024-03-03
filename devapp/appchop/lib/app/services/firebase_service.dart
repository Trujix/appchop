import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../data/models/local_storage/local_storage.dart';
import '../utils/literals.dart';
import 'storage_service.dart';

class FirebaseService {
  final StorageService _storage = Get.find<StorageService>();

  Future<void> init() async {
    try {
      await Firebase.initializeApp();
      var token = await FirebaseMessaging.instance.getToken();
      _updateFirebaseToken(token!);
      await FirebaseMessaging.instance.subscribeToTopic(Literals.notificacionTopic);
      FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _onMessage(message.data);
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _onMessage(message.data, true);
      });
      return;
    } catch(e) {
      return;
    }
  }

  void _onMessage(Map<String, dynamic> notificacion, [bool open = false]) {
    if(open) {

    }
  }

  void _updateFirebaseToken(String token) {
    try {
      var localStorage = LocalStorage.fromJson(_storage.get(LocalStorage()));
      localStorage.idFirebase = token;
      _storage.update(localStorage);
    } finally { }
  }
}

@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {
  try {
    
  } catch(e) {
    return;
  }
}