import 'package:get/get.dart';

import '../../services/api_service.dart';
import '../../utils/literals.dart';
import '../models/local_storage/zonas.dart';

class BackupProvider {
  final ApiService _api = Get.find<ApiService>();

  Future<bool?> verificarEstatusAsync(List<Zonas> zonas) async {
    try {
      var result = await _api.post(
        "api/appbackup/backupZonas",
        zonas,
      );
      print(result);
      return result == Literals.apiTrue;
    } catch(e) {
      return null;
    }
  }
}