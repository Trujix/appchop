import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/color_list.dart';

class AlertaDialog extends StatelessWidget {
  final String mensaje;
  final IconData icono;
  final int color;

  const AlertaDialog({
    super.key,
    this.mensaje = "",
    this.icono = Icons.abc,
    this.color = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
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
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(ColorList.ui[0]),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Color(ColorList.ui[2]),
                        blurRadius: 10,
                        offset: const Offset(0, 10),
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
                          color: Color(color),
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
                            minFontSize: 8,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                          ),
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