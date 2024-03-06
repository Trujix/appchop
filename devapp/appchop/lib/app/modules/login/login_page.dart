import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../utils/color_list.dart';
import '../../utils/literals.dart';
import '../../widgets/appbars/off_appbar.dart';
import '../../widgets/buttons/solid_button.dart';
import '../../widgets/textforms/password_textform.dart';
import '../../widgets/textforms/standard_textform.dart';
import 'login_controller.dart';

class LoginPage extends StatelessWidget with WidgetsBindingObserver {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: const OffAppbar(),
        backgroundColor: Color(ColorList.sys[3]),
        body: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StandardTextform(
                    controller: _.usuario,
                    focusNode: _.usuaroFocus,
                    text: "Usuario",
                  ),
                  PasswordTextform(
                    controller: _.password,
                    focusNode: _.passwordFocus,
                    obscureText: _.ocultarPassword,
                    obscureTextFunc: _.verPassword,
                    text: "Contraseña",
                  ),
                  SolidButton(
                    texto: "Iniciar Sesión",
                    icono: MaterialIcons.login,
                    onPressed: _.iniciarSesion,
                    textoColor: ColorList.sys[1],
                    fondoColor: ColorList.sys[0],
                    ltrbm: const [0, 15, 0, 0],
                    onLongPress: () {},
                  ),
                  SolidButton(
                    texto: "Recuperar contraseña",
                    icono: MaterialIcons.rotate_left,
                    onPressed: _.iniciarSesion,
                    textoColor: ColorList.sys[0],
                    fondoColor: ColorList.sys[1],
                    onLongPress: () {},
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                bottom: 15,
              ),
              child: AutoSizeText(
                "Versión: ${Literals.version}",
                style: TextStyle(
                  color: Color(ColorList.sys[0]),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}