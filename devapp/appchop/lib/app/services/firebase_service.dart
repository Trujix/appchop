import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../data/models/local_storage/local_storage.dart';
import '../utils/literals.dart';
import '../widgets/modals/notificacion_usuario_password_modal.dart';
import 'storage_service.dart';
import 'tool_service.dart';

class FirebaseService {
  final StorageService _storage = Get.find<StorageService>();
  final ToolService _tool = Get.find<ToolService>();

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
        _onMessageOpen(message.data);
      });
    } finally {
      FirebaseMessaging.instance.subscribeToTopic(Literals.notificacionTopic);
    }
  }

  void _onMessage(Map<String, dynamic> notificacion) {
    try {
      var accion = notificacion['accion'];
      switch(accion) {
        case null:
        break;
        case Literals.notificacionUsuarioPassword:
          _usuarioPassword(notificacion);
        default:
        break;
      }
    } finally { }
  }

  void _onMessageOpen(Map<String, dynamic> notificacion,) {
    
  }

  Future<void> _updateFirebaseToken(String token) async {
    try {
      var localStorage = LocalStorage.fromJson(_storage.get(LocalStorage()));
      localStorage.idFirebase = token;
      await _storage.update(localStorage);
      return;
    } finally { }
  }

  void _usuarioPassword(dynamic data) {
    var password = data['password'];
    _tool.modal(
      widgets: [
        NotificacionUsuarioPasswordModal(
          password: password,
        ),
      ],
      height: 170,
    );
  }
}

@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {
  try {
    
  } catch(e) {
    return;
  }
}