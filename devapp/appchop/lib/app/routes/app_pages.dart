import 'package:get/get.dart';

import '../modules/alpha/alpha_binding.dart';
import '../modules/alpha/alpha_page.dart';
import '../modules/alta_cobranza/alta_cobranza_binding.dart';
import '../modules/alta_cobranza/alta_cobranza_page.dart';
import '../modules/cobranza_main/cobranza_main_binding.dart';
import '../modules/cobranza_main/cobranza_main_page.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_page.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_page.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.alpha,
      page: () => const AlphaPage(),
      binding: AlphaBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.cobranzaMain,
      page: () => const CobranzaMainPage(),
      binding: CobranzaMainBinding(),
    ),
    GetPage(
      name: AppRoutes.altaCobranza,
      page: () => const AltaCobranzaPage(),
      binding: AltaCobranzaBinding(),
    ),
  ];
}