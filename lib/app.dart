import 'package:flutter/material.dart';

import 'routes.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

class FieldGuideApp extends StatelessWidget {
  const FieldGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Field Guide',
      theme: appTheme,
      routes: appRoutes,
      initialRoute: AppRoutes.home,
      debugShowCheckedModeBanner: false,
    );
  }
}
