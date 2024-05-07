import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/back_appbar.dart';
import '../../widgets/appbars/off_appbar.dart';
import '../../widgets/buttons/terminos_sliderbutton.dart';
import 'pdf_viewer_controller.dart';

class PdfViewerPage extends StatelessWidget with WidgetsBindingObserver {
  const PdfViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PdfViewerController>(
      builder: (_) => PopScope(
        canPop: _.salir,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(ColorList.ui[1]),
          appBar: PreferredSize(
            preferredSize: _.salir ? Size(Get.width, kToolbarHeight) : const Size.fromHeight(0),
            child: Builder(
              builder: (context) {
                if(_.salir) {
                  return BackAppbar(
                    cerrar: _.cerrar,
                    fondo: ColorList.ui[1],
                  );
                } else {
                  return const OffAppbar();
                }
              },
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: PDFView(
                  filePath: _.archivo,
                  onError: _.errorCargarPdf,
                ),
              ),
              TerminosSliderbutton(
                visible: _.widgetTerminosCondiciones,
                action: _.aceptarTerminos,
              ),
            ],
          ),
        ),
      ),
    );
  }
}