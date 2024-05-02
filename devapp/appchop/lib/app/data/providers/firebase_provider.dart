import 'dart:convert';
import 'package:get/get.dart';

import '../../services/api_service.dart';
import '../models/firebase/firebase_result.dart';
import '../models/firebase/notificacion.dart';

class FirebaseProvider {
  final ApiService _api = Get.find<ApiService>();

  Future<FirebaseResult?> enviarNotificacionAsync(Notificacion notificacion) async {
    try {
      var result = await _api.post(
        "api/firebase/enviarNotificacion",
        notificacion
      );
      return FirebaseResult.fromApi(jsonDecode(result!));
    } catch(e) {
      return null;
    }
  }
}