import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../widgets/appbar/off_appbar.dart';
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
        body: Column(
          children: <Widget>[
            StandardTextform(
              controller: _.usuario,
              focusNode: _.usuaroFocus,
            ),
            PasswordTextform(
              controller: _.password,
              focusNode: _.usuaroFocus,
              obscureText: _.ocultarPassword,
              obscureTextFunc: _.verPassword,
            ),
            SolidButton(
              texto: "Iniciar Sesión",
              icono: MaterialIcons.login,
              onPressed: _.iniciarSesion,
              onLongPress: () {},
            ),
          ],
        ),
      ),
    );
  }
}