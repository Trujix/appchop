import '../../utils/get_injection.dart';

class LoginController extends GetInjection {
  bool ocultarPassword = true;

  void verPassword() {
    ocultarPassword = !ocultarPassword;
    update();
  }
}