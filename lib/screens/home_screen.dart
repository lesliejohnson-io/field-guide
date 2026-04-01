import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/survey_controller.dart';
import '../widgets/tablet_scaffold.dart';

import '../routes.dart';

const double _space8 = 8;
const double _space16 = 16;
const double _space24 = 24;
const double _space32 = 32;
const double _cardRadius = 16;
const BoxShadow _cardShadow = BoxShadow(
  color: Color(0x0A000000), // 4% opacity black
  blurRadius: 16,
  offset: Offset(0, 6),
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TabletScaffold(
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  _space24,
                  _space32,
                  _space24,
                  _space16,
                ),
                child: _DashboardContent(theme: theme),
              ),
            ),
            // Sticky CTA bar that remains visible even if the dashboard content
            // needs to scroll.
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  _space24,
                  _space8,
                  _space24,
                  _space16,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  boxShadow: const [_cardShadow],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      textStyle: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.survey);
                    },
                    child: const Text('Start Surveys'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DashboardHeader(theme: theme),
        const SizedBox(height: _space24),
        _ProgressSection(theme: theme),
        const SizedBox(height: _space24),
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 900;
            if (isNarrow) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TodoTodayCard(),
                  SizedBox(height: _space16),
                  _FamilyCard(),
                ],
              );
            }
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _TodoTodayCard()),
                SizedBox(width: _space16),
                Expanded(child: _FamilyCard()),
              ],
            );
          },
        ),
        const SizedBox(height: _space24),
        const _BottomStatusRow(),
      ],
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Visit",
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: _space8),
        Text(
          "Here's what's on your visit today.",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ProgressSection extends ConsumerWidget {
  const _ProgressSection({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardDecoration = _cardDecoration(theme);
    final surveyState = ref.watch(surveyControllerProvider);
    final answered = surveyState.answers.length;
    final total = surveyState.totalQuestions;

    return Container(
      padding: const EdgeInsets.all(_space24),
      decoration: cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: _space16),
          Text(
            '$answered of $total questions answered',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: _space16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: total > 0 ? answered / total : 0.0,
              minHeight: 6,
              backgroundColor:
                  theme.colorScheme.primary.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodoTodayCard extends StatelessWidget {
  const _TodoTodayCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardDecoration = _cardDecoration(theme);

    Widget buildRow(
      IconData icon,
      String title,
      String duration, {
      bool isLast = false,
    }) {
      return Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      duration,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isLast) ...[
            const SizedBox(height: _space16),
            Divider(
              height: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: _space16),
          ],
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(_space24),
      decoration: cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'To-Do Today',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: _space16),
          buildRow(
            Icons.favorite_border,
            'Health Survey',
            'Est. 5 min',
          ),
          buildRow(
            Icons.groups_2_outlined,
            'Social Survey',
            'Est. 5 min',
          ),
          buildRow(
            Icons.medical_services_outlined,
            'Dental Exam',
            'Est. 15 min',
          ),
          buildRow(
            Icons.monitor_heart_outlined,
            'Health Check',
            'Est. 10 min',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _FamilyCard extends StatelessWidget {
  const _FamilyCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardDecoration = _cardDecoration(theme);

    Widget buildRow(String label, String value, String status) {
      Color statusColor;
      switch (status) {
        case 'Done':
          statusColor = Colors.green;
          break;
        case 'In Progress':
          statusColor = theme.colorScheme.primary;
          break;
        default:
          statusColor = theme.colorScheme.outlineVariant;
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              status,
              style: theme.textTheme.bodySmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(_space24),
      decoration: cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Family',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: _space16),
          buildRow(
            'Grandparents',
            'Grandma Betty, Grandpa Harold',
            'Done',
          ),
          buildRow(
            'Parents',
            'Mary Johnson, Robert Johnson',
            'In Progress',
          ),
          buildRow(
            'Children',
            'Tyler (Age 16) Own Tablet, Emma (Age 10) Proxy',
            'Waiting',
          ),
        ],
      ),
    );
  }
}

class _BottomStatusRow extends StatelessWidget {
  const _BottomStatusRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardDecoration = _cardDecoration(theme);

    Widget buildCard(String title, String subtitle, IconData icon) {
      return Container(
        padding: const EdgeInsets.all(_space24),
        decoration: cardDecoration,
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: _space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: _space8),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: buildCard(
            'Dental Exam',
            'Scheduled for today',
            Icons.medical_services_outlined,
          ),
        ),
        const SizedBox(width: _space16),
        Expanded(
          child: buildCard(
            'Health Check',
            'Vitals to be recorded',
            Icons.monitor_heart_outlined,
          ),
        ),
      ],
    );
  }
}

BoxDecoration _cardDecoration(ThemeData theme) {
  return BoxDecoration(
    color: theme.colorScheme.surface,
    borderRadius: BorderRadius.circular(_cardRadius),
    border: Border.all(
      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
    ),
    boxShadow: const [_cardShadow],
  );
}

