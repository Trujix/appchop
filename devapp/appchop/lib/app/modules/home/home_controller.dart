import '../../utils/get_injection.dart';

class HomeController extends GetInjection {
  @override
  void onInit() async {
    firebaseService.init();
    super.onInit();
  }

  String texto = "Hola";

}