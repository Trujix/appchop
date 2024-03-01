import 'package:get/get.dart';

import '../../data/models/local_storage/local_storage.dart';
import '../../utils/get_injection.dart';
import '../home/home_binding.dart';
import '../home/home_page.dart';
import '../login/login_binding.dart';
import '../login/login_page.dart';

class AlphaController extends GetInjection {

  @override
  void onInit() async {
    await _init();
    super.onInit();
  }

  Future<void> _init() async {
    try {
      await storage.init();
      await firebase.init();
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      await tool.wait();
      var page = localStorage.login! ? const HomePage() : const LoginPage();
      var binding = localStorage.login! ? HomeBinding() : LoginBinding();
      Get.offAll(
        page,
        binding: binding,
        transition: Transition.circularReveal,
        duration: const Duration(seconds: 1),
      );
    } catch(e) {
      return;
    }
  }
}