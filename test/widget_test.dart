import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:field_guide_demo/app.dart';
import 'package:field_guide_demo/controllers/survey_controller.dart';

void main() {
  testWidgets('App renders home screen smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const FieldGuideApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("Today's Visit"), findsOneWidget);
    expect(find.text('Start Surveys'), findsOneWidget);
  });
}
