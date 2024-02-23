import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_color_gen/material_color_gen.dart';

import 'app/modules/home/home_binding.dart';
import 'app/modules/home/home_page.dart';
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
          ColorList.main[0],
        ).toMaterialColor(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      home: const HomePage(),
      initialBinding: HomeBinding(),
    );
  }
}