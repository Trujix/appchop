import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dependency_injection.dart';

class AppConfiguration {
  static void init() async {
    WidgetsFlutterBinding.ensureInitialized();
    DependencyInjection.init();
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
  }
}