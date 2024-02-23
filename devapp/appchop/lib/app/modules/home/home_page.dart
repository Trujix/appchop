import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget with WidgetsBindingObserver {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) => ZoomDrawer(
          controller: _.drawerController,
          mainScreen: Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Icon(
            Icons.menu,
          ),
          onTap: _.abrirMenu,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '1',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _.abrirMenu,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    ),
          menuScreen: Scaffold(
            backgroundColor: Color(0xFF444A59),
            body: Text('Sidebar'),
          ),
          borderRadius: 24.0,
          showShadow: true,
          angle: -8.0,
          openCurve: Curves.fastOutSlowIn,
          closeCurve: Curves.bounceIn,
          menuBackgroundColor: Color(0xFF444A59),
          slideWidth: MediaQuery.of(context).size.width*.80,
        ),
    );
  }
}