import 'package:get/get.dart';

import '../modules/alpha/alpha_binding.dart';
import '../modules/alpha/alpha_page.dart';
import '../modules/alta_cargo_abono/alta_cargo_abono_binding.dart';
import '../modules/alta_cargo_abono/alta_cargo_abono_page.dart';
import '../modules/alta_clientes/alta_clientes_binding.dart';
import '../modules/alta_clientes/alta_clientes_page.dart';
import '../modules/alta_zona/alta_zona_binding.dart';
import '../modules/alta_zona/alta_zona_page.dart';
import '../modules/alta_cobranza/alta_cobranza_binding.dart';
import '../modules/alta_cobranza/alta_cobranza_page.dart';
import '../modules/alta_notas/alta_notas_binding.dart';
import '../modules/alta_notas/alta_notas_page.dart';
import '../modules/cobranza_main/cobranza_main_binding.dart';
import '../modules/cobranza_main/cobranza_main_page.dart';
import '../modules/configuracion/configuracion_binding.dart';
import '../modules/configuracion/configuracion_page.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_page.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_page.dart';
import '../modules/pdf_viewer/pdf_viewer_binding.dart';
import '../modules/pdf_viewer/pdf_viewer_page.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.alpha,
      page: () => const AlphaPage(),
      binding: AlphaBinding(),
    ),
    GetPage(
      name: AppRoutes.altaCargoAbono,
      page: () => const AltaCargoAbonoPage(),
      binding: AltaCargoAbonoBinding(),
    ),
    GetPage(
      name: AppRoutes.altaClientes,
      page: () => const AltaClientesPage(),
      binding: AltaClientesBinding(),
    ),
    GetPage(
      name: AppRoutes.altaCobranza,
      page: () => const AltaCobranzaPage(),
      binding: AltaCobranzaBinding(),
    ),
    GetPage(
      name: AppRoutes.altaNotas,
      page: () => const AltaNotasPage(),
      binding: AltaNotasBinding(),
    ),
    GetPage(
      name: AppRoutes.altaZona,
      page: () => const AltaZonaPage(),
      binding: AltaZonaBinding(),
    ),
    GetPage(
      name: AppRoutes.cobranzaMain,
      page: () => const CobranzaMainPage(),
      binding: CobranzaMainBinding(),
    ),
    GetPage(
      name: AppRoutes.configuracion,
      page: () => const ConfiguracionPage(),
      binding: ConfiguracionBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.pdfViewer,
      page: () => const PdfViewerPage(),
      binding: PdfViewerBinding(),
    ),
  ];
}