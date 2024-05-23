import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:material_color_gen/material_color_gen.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/off_appbar.dart';
import '../../widgets/buttons/solid_button.dart';
import '../../widgets/containers/card_container.dart';
import '../../widgets/containers/titulo_container.dart';
import '../../widgets/customscrollviews/clientes_customscrollview.dart';
import 'app_backup_clientes_controller.dart';

class AppBackupClientesPage extends StatelessWidget with WidgetsBindingObserver {
  const AppBackupClientesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppBackupClientesController>(
      builder: (_) => PopScope(
        canPop: false,
        child: Scaffold(
          appBar: const OffAppbar(
            height: 30,
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(ColorList.ui[1]),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TituloContainer(
                size: 18,
                texto: "Agregar nuevos clientes",
              ),
              CardContainer(
                fondo: ColorList.sys[1],
                padding: const EdgeInsets.all(15,),
                children: <Widget>[
                  AutoSizeText(
                    'Se detectaron clientes que no tiene registrados en su catálogo. Seleccione los elementos a almacenar o puede salir sin guardar...',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(ColorList.sys[0]),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ClientesCustomscrollview(
                  scrollController: _.scrollController,
                  listaClientes: _.clientesNuevos,
                  onChanged: _.clienteStatus,
                ),
              ),
              SolidButton(
                texto: "Salir sin guardar",
                icono: MaterialIcons.close,
                fondoColor: ColorList.sys[0],
                textoColor: ColorList.ui[0],
                ltrbm: const [0, 0, 0, 2,],
                onPressed: _.cancelar,
                onLongPress: () {},
              ),
            ],
          ),
          floatingActionButton: Visibility(
            visible: _.clientesNuevosActivos,
            child: FloatingActionButton(
              onPressed: _.guardarNuevosClientes,
              shape: const CircleBorder(),
              backgroundColor: Color(ColorList.sys[2]),
              child: Icon(
                MaterialIcons.save,
                color: Color(ColorList.sys[0]).toMaterialColor(),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        ),
      ),
    );
  }
}