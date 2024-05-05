import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/color_list.dart';

class PreguntaDialog extends StatelessWidget {
  final String mensaje;
  final String pregunta;
  final String siBoton;
  final String noBoton;
  final void Function(bool) respuesta;
  final IconData icono;
  const PreguntaDialog({
    super.key,
    this.mensaje = "",
    this.pregunta = "",
    required this.respuesta,
    this.icono = Icons.info_outline_rounded,
    this.siBoton = "Aceptar",
    this.noBoton = "Cancelar",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: 10.milliseconds,
        curve: Curves.fastLinearToSlowEaseIn,
         child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          icono,
                          size: 30,
                          color: Color(ColorList.sys[2]),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: AutoSizeText(
                            mensaje,
                            style: TextStyle(
                              color: Color(ColorList.sys[0]),
                              fontWeight: FontWeight.bold,
                            ),
                            minFontSize: 12,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: AutoSizeText(
                            pregunta,
                            style: TextStyle(
                              color: Color(ColorList.sys[0]),
                              fontWeight: FontWeight.bold,
                            ),
                            minFontSize: 10,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: <Widget>[
                            const Expanded(child: SizedBox()),
                            InkWell(
                              onTap: () => respuesta(true),
                              child: Text(
                                siBoton,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorList.sys[0]),
                                ),
                              ),
                            ),
                            const SizedBox(width: 40,),
                            InkWell(
                              onTap: () => respuesta(false),
                              child: Text(
                                noBoton,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorList.sys[5]),
                                ),
                              ),
                            ),
                            const SizedBox(width: 25,),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
         ),
      ),
    );
  }
}