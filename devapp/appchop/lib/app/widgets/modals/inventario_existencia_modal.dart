import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../data/models/local_storage/inventarios.dart';
import '../../utils/color_list.dart';
import '../buttons/circular_buttons.dart';
import '../buttons/solid_button.dart';
import '../textforms/standard_textform.dart';

class InventarioExistenciaModal extends StatelessWidget {
  final TextEditingController? existencia;
  final Inventarios inventarios;
  final void Function(Inventarios, String) guardarCambios;
  final void Function(String, Inventarios) warningAccion;
  const InventarioExistenciaModal({
    super.key,
    this.existencia,
    required this.inventarios,
    required this.guardarCambios,
    required this.warningAccion,
  });
  @override
  Widget build(BuildContext context) {
    existencia!.text = inventarios.existencia!.toStringAsFixed(0);
    return Container(
      padding: const EdgeInsets.all(10,),
      child: Column(
        children: [
          Row(
            children: [
              CircularButton(
                colorIcono: ColorList.sys[0],
                color: ColorList.sys[2],
                icono: MaterialIcons.remove_circle,
                margin: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                onPressed: () {
                  if(existencia!.text == "") {
                    existencia!.text = "1";
                  }
                  if(int.parse(existencia!.text) <= 0) {
                    existencia!.text = "1";
                  }
                  if(int.parse(existencia!.text) > 1) {
                    var valor = int.parse(existencia!.text) - 1;
                    existencia!.text = valor.toString();
                  }
                  warningAccion(existencia!.text, inventarios);
                },
              ),
              Expanded(
                child: StandardTextform(
                  controller: existencia,
                  text: "Existencias *",
                  icon: MaterialIcons.format_list_numbered,
                  keyboardType: TextInputType.number,
                  ltrbp: const [0, 10, 0, 10],
                  textAlign: TextAlign.center,
                  onChanged: (valor) {
                    warningAccion(existencia!.text, inventarios);
                  },
                ),
              ),
              CircularButton(
                colorIcono: ColorList.sys[0],
                color: ColorList.sys[1],
                icono: MaterialIcons.add_circle,
                margin: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                onPressed: () {
                  if(existencia!.text == "") {
                    existencia!.text = "0";
                  }
                  if(int.parse(existencia!.text) <= 0) {
                    existencia!.text = "0";
                  }
                  var valor = int.parse(existencia!.text) + 1;
                  existencia!.text = valor.toString();
                  warningAccion(existencia!.text, inventarios);
                },
              ),
            ]
          ),
          SolidButton(
            texto: "Guardar cambios",
            icono: MaterialIcons.save,
            fondoColor: ColorList.sys[0],
            textoColor: ColorList.ui[0],
            ltrbm: const [0, 0, 0, 0,],
            onPressed: () {
              var valor = existencia!.text;
              if(valor == "") {
                valor = "0";
              }
              if(int.parse(valor) <= 0) {
                valor = "0";
              }
              guardarCambios(inventarios, valor);
            },
            onLongPress: () {},
          ),
        ],
      ),
    );
  }
}