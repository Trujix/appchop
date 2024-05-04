import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../../utils/get_injection.dart';

class InventariosController extends GetInjection {
  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {

  }

  Future<void> elegir() async {
    var result = await FilePicker.platform.pickFiles();
  }

  void cerrar() {
    Get.back();
  }
}