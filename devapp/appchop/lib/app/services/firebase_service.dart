import 'dart:convert';

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
      await _updateFirebaseToken(token!);
      FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _onMessage(message.data);
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _onMessage(message.data, true);
      });
    } finally {
      FirebaseMessaging.instance.subscribeToTopic(Literals.notificacionTopic);
    }
  }

  void _onMessage(Map<String, dynamic> notificacion, [bool open = false]) {
    print(jsonEncode(notificacion));
    if(open) {

    }
  }

  Future<void> _updateFirebaseToken(String token) async {
    try {
      var localStorage = LocalStorage.fromJson(_storage.get(LocalStorage()));
      localStorage.idFirebase = token;
      await _storage.update(localStorage);
      return;
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