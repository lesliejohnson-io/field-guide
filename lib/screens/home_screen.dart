import 'package:flutter/material.dart';

import '../widgets/tablet_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TabletScaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Today's Visit",
            style: theme.textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}

