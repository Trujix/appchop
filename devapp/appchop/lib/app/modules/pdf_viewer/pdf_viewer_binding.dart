import 'package:get/get.dart';

import 'pdf_viewer_controller.dart';

class PdfViewerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PdfViewerController());
  }
}