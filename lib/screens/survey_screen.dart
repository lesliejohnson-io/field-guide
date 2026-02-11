import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/survey_controller.dart';
import '../widgets/tablet_scaffold.dart';

class SurveyScreen extends ConsumerWidget {
  const SurveyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final surveyState = ref.watch(surveyControllerProvider);
    final currentQuestion = surveyState.currentQuestion;

    return TabletScaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SurveyProgressSection(
              theme: theme,
              label: surveyState.progressLabel,
              progress: surveyState.progress,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: surveyState.isComplete
                      ? _SurveyCompleteCard(
                          answeredCount: surveyState.answers.length,
                          totalCount: surveyState.totalQuestions,
                          onContinue: () {
                            Navigator.of(context).pushReplacementNamed('/complete');
                          },
                        )
                      : _QuestionCard(
                          title: currentQuestion.title,
                          prompt: currentQuestion.prompt,
                          options: currentQuestion.options,
                          onOptionTap: (option) {
                            print(
                              'Survey: selected option "$option" for question ${currentQuestion.id}',
                            );
                            ref
                                .read(surveyControllerProvider.notifier)
                                .selectOption(currentQuestion.id, option);
                          },
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const _CarePromiseRow(),
          ],
        ),
      ),
    );
  }
}

class _SurveyCompleteCard extends StatelessWidget {
  const _SurveyCompleteCard({
    required this.answeredCount,
    required this.totalCount,
    required this.onContinue,
  });

  final int answeredCount;
  final int totalCount;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'All set',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thanks for sharing. A nurse will review your responses.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Answered $answeredCount of $totalCount',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onContinue,
            child: const Text('Return to Dashboard'),
          ),
        ],
      ),
    );
  }
}

class _SurveyProgressSection extends StatelessWidget {
  const _SurveyProgressSection({
    required this.theme,
    required this.label,
    required this.progress,
  });

  final ThemeData theme;
  final String label;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Progress",
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.title,
    required this.prompt,
    required this.options,
    required this.onOptionTap,
  });

  final String title;
  final String prompt;
  final List<String> options;
  final void Function(String option) onOptionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildAnswer(String label) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            side: BorderSide(
              color: theme.colorScheme.outlineVariant,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => onOptionTap(label),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            prompt,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          for (int i = 0; i < options.length; i++) ...[
            buildAnswer(options[i]),
            if (i != options.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _CarePromiseRow extends StatelessWidget {
  const _CarePromiseRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildCard(String title, String subtitle) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withOpacity(0.6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
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
            'Private',
            'Your answers are confidential.',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: buildCard(
            'Fast',
            'This will only take a few minutes.',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: buildCard(
            'Helpful',
            'Your responses help improve care.',
          ),
        ),
      ],
    );
  }
}
