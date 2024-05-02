import 'package:get/get.dart';

import '../models/firebase/firebase_result.dart';
import '../models/firebase/notificacion.dart';
import '../providers/firebase_provider.dart';

class FirebaseRepository {
  Future<FirebaseResult?> enviarNotificacionAsync(Notificacion notificacion) async {
    return await Get.find<FirebaseProvider>().enviarNotificacionAsync(notificacion);
  }
}