import 'package:get/get.dart';

import '../models/configuracion/imagen_logo.dart';
import '../models/local_storage/configuracion.dart';
import '../providers/configuracion_provider.dart';

class ConfiguracionRepository {
  Future<bool?> guardarImagenLogoAsync(ImagenLogo imagenLogo) async {
    return await Get.find<ConfiguracionProvider>().guardarImagenLogoAsync(imagenLogo);
  }
  
  Future<bool?> desvincularDispositivoAsync(String idUsuario, String usuario) async {
    return await Get.find<ConfiguracionProvider>().desvincularDispositivoAsync(idUsuario, usuario);
  }

  Future<Configuracion?> obtenerConfiguracionUsuarioAsync(String idUsuario) async {
    return await Get.find<ConfiguracionProvider>().obtenerConfiguracionUsuarioAsync(idUsuario);
  }
}