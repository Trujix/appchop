import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_color_gen/material_color_gen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/modules/alpha/alpha_binding.dart';
import 'app/modules/alpha/alpha_page.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/app_configuration.dart';
import 'app/utils/color_list.dart';

void main() {
  AppConfiguration.init();
  runApp(const AppChop());
}

class AppChop extends StatelessWidget {
  const AppChop({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Shop App",
      theme: ThemeData(
        primarySwatch: Color(
          ColorList.sys[0],
        ).toMaterialColor(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      getPages: AppPages.pages,
      home: const AlphaPage(),
      initialBinding: AlphaBinding(),
    );
  }
}