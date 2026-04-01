import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/survey_controller.dart';
import '../models/survey_question.dart';
import '../routes.dart';

class LeftRail extends ConsumerStatefulWidget {
  const LeftRail({super.key});

  @override
  ConsumerState<LeftRail> createState() => _LeftRailState();
}

class _LeftRailState extends ConsumerState<LeftRail> {
  /// Tracks which non-survey item was last tapped (by flat nav index).
  int? _localSelectedIndex;

  late final List<_NavSection> _sections = [
    const _NavSection(
      title: null,
      items: [
        _NavItem(
          'Family Pedigree',
          icon: Icons.account_tree_outlined,
        ),
        _NavItem(
          'Participant Charts',
          icon: Icons.insights_outlined,
        ),
        _NavItem(
          'Participant Schedule',
          icon: Icons.event_note_outlined,
        ),
      ],
    ),
    const _NavSection(
      title: 'Surveys',
      items: [
        _NavItem(
          'Health Overview',
          icon: Icons.favorite_outline,
          surveySection: SurveySection.health,
        ),
        _NavItem(
          'Social Interaction',
          icon: Icons.group_outlined,
          surveySection: SurveySection.social,
        ),
        _NavItem(
          'Stress Management',
          icon: Icons.self_improvement_outlined,
          surveySection: SurveySection.stress,
        ),
        _NavItem(
          'Economics',
          icon: Icons.account_balance_wallet_outlined,
          surveySection: SurveySection.economics,
        ),
      ],
    ),
    const _NavSection(
      title: 'Children',
      items: [
        _NavItem(
          'Child: Joshua',
          icon: Icons.child_care_outlined,
        ),
        _NavItem(
          'Child: Macie',
          icon: Icons.baby_changing_station_outlined,
        ),
      ],
    ),
    const _NavSection(
      title: 'Administrative',
      items: [
        _NavItem(
          'Administrative',
          icon: Icons.settings_outlined,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surveyState = ref.watch(surveyControllerProvider);
    final completedSections = surveyState.completedSections;

    final currentSection =
        surveyState.isComplete ? null : surveyState.currentQuestion.section;

    final items = <Widget>[];
    int runningIndex = 0;
    for (final section in _sections) {
      if (section.title != null) {
        items.add(_SectionHeader(title: section.title!));
        items.add(const SizedBox(height: 4));
      }
      for (final item in section.items) {
        final itemIndex = runningIndex;
        final isSurveyItem = item.surveySection != null;

        final bool isSelected = isSurveyItem
            ? item.surveySection == currentSection
            : _localSelectedIndex == itemIndex;

        final bool showDot = isSurveyItem &&
            completedSections.contains(item.surveySection);

        items.add(
          _NavTile(
            label: item.label,
            icon: item.icon,
            hasStatusDot: showDot,
            selected: isSelected,
            onTap: () {
              final surveySection = item.surveySection;
              if (surveySection != null) {
                setState(() => _localSelectedIndex = null);
                ref
                    .read(surveyControllerProvider.notifier)
                    .goToSection(surveySection);
                final currentRoute = ModalRoute.of(context)?.settings.name;
                if (currentRoute != AppRoutes.survey) {
                  Navigator.of(context).pushNamed(AppRoutes.survey);
                }
              } else {
                setState(() => _localSelectedIndex = itemIndex);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.label} — coming soon'),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        );
        runningIndex++;
      }
      items.add(const SizedBox(height: 16));
    }

    const background = Color(0xFF0F1B2D);
    const onBackground = Color(0xFFF9FAFB);

    return Container(
      color: background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _UserBlock(
            onLogout: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.home,
                (route) => false,
              );
              ref.read(surveyControllerProvider.notifier).reset();
            },
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Theme(
              data: theme.copyWith(
                iconTheme: const IconThemeData(color: onBackground),
                textTheme: theme.textTheme.apply(
                  bodyColor: onBackground,
                  displayColor: onBackground,
                ),
              ),
              child: DefaultTextStyle(
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: onBackground,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: items,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _LogoFooter(
            maxWidth: 180,
            colorScheme: theme.colorScheme.copyWith(
              onSurface: onBackground,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserBlock extends StatelessWidget {
  const _UserBlock({required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const onBackground = Color(0xFFF9FAFB);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.18),
              child: Text(
                'E',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emma J.',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Field Nurse',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: onBackground.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 24),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: onBackground.withValues(alpha: 0.75),
          ),
          onPressed: onLogout,
          child: const Text(
            'Logout',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          letterSpacing: 0.8,
          color: const Color(0xFF4B7A73),
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.label,
    required this.icon,
    this.hasStatusDot = false,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool hasStatusDot;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const onBackground = Color(0xFFF9FAFB);
    const greenAccent = Color(0xFF22C55E);

    final Color pillColor =
        selected ? Colors.white.withValues(alpha: 0.06) : Colors.transparent;
    final Color textColor =
        selected ? onBackground : onBackground.withValues(alpha: 0.82);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: pillColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 3,
              height: double.infinity,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: selected ? greenAccent : Colors.transparent,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(999),
                ),
              ),
            ),
            Icon(
              icon,
              size: 18,
              color: textColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (hasStatusDot) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: greenAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _LogoFooter extends StatelessWidget {
  const _LogoFooter({
    required this.colorScheme,
    this.maxWidth = 160,
  });

  final ColorScheme colorScheme;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: 40,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: _Logo(colorScheme: colorScheme),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/field_guide_logo.png',
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Text(
          'FIELD GUIDE',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        );
      },
    );
  }
}

class _NavSection {
  const _NavSection({
    required this.title,
    required this.items,
  });

  final String? title;
  final List<_NavItem> items;
}

class _NavItem {
  const _NavItem(
    this.label, {
    required this.icon,
    this.surveySection,
  });

  final String label;
  final IconData icon;
  final SurveySection? surveySection;
}
