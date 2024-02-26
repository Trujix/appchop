import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dependency_injection.dart';

class AppConfiguration {
  static void init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Permission.notification.isDenied.then((denegado) {
      if (denegado) {
        Permission.notification.request();
      }
    });
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
    DependencyInjection.init();
  }
}