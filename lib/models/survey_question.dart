import 'package:flutter/foundation.dart';

/// Sections/categories for Field Guide surveys.
enum SurveySection {
  health,
  social,
  stress,
  economics,
}

/// Immutable domain model for a single survey question.
@immutable
class SurveyQuestion {
  const SurveyQuestion({
    required this.id,
    required this.section,
    required this.title,
    required this.prompt,
    required this.options,
    this.audioAsset,
  }) : assert(options.length >= 2, 'SurveyQuestion.options must have at least 2 entries');

  final String id;
  final SurveySection section;
  final String title;
  final String prompt;
  final List<String> options;
  final String? audioAsset;
}

