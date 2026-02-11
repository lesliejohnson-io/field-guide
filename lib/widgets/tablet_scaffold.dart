import 'package:flutter/material.dart';

import 'left_rail.dart';

/// A tablet-oriented layout with a fixed-width left rail and
/// a flexible main content area.
class TabletScaffold extends StatelessWidget {
  const TabletScaffold({
    super.key,
    required this.body,
  });

  /// Main content for the page.
  final Widget body;

  static const double _leftRailWidth = 272; // within 260–280px range

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: _leftRailWidth,
              child: const LeftRail(),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: theme.dividerColor,
            ),
            Expanded(
              child: Container(
                color: theme.colorScheme.surface,
                child: body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

