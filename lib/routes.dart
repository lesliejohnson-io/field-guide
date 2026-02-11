import 'package:flutter/widgets.dart';

import 'screens/home_screen.dart';

import 'screens/survey_screen.dart';


class AppRoutes {
  static const String home = '/';
  static const survey = '/survey';
}

final Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.home: (context) => const HomeScreen(),
  AppRoutes.survey: (context) => const SurveyScreen(),
};

