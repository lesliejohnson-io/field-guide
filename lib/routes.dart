import 'package:flutter/widgets.dart';

import 'screens/home_screen.dart';

class AppRoutes {
  static const String home = '/';
}

final Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.home: (context) => const HomeScreen(),
};

