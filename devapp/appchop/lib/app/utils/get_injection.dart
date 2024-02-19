import 'package:get/get.dart';

import '../services/firebase_service.dart';

abstract class GetInjection extends GetxController {
  final firebaseService = Get.find<FirebaseService>();
}