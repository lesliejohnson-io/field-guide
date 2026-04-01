import 'package:flutter/foundation.dart';

import '../models/survey_question.dart';

@immutable
class SurveyState {
  const SurveyState({
    required this.questions,
    required this.currentIndex,
    required this.answers,
    required this.isComplete,
    required this.voiceEnabled,
  });

  /// All questions available in the current survey session.
  final List<SurveyQuestion> questions;

  /// Index of the "current" question within [questions].
  final int currentIndex;

  /// Recorded answers keyed by question ID.
  final Map<String, String> answers;

  /// Whether the survey has been completed.
  final bool isComplete;

  /// Whether voice guidance is enabled for survey UI.
  final bool voiceEnabled;

  /// Total number of questions in this survey.
  int get totalQuestions => questions.length;

  /// The question that should be shown as "current".
  ///
  /// If [isComplete] is true, this returns the last question so that
  /// the UI can still render something meaningful on a results/summary
  /// screen.
  SurveyQuestion get currentQuestion {
    if (questions.isEmpty) {
      throw StateError('SurveyState has no questions.');
    }
    if (isComplete) {
      return questions[questions.length - 1];
    }
    final index = currentIndex.clamp(0, questions.length - 1);
    return questions[index];
  }

  /// Progress from 0.0 to 1.0.
  ///
  /// When in progress, we use (currentIndex + 1) / totalQuestions.
  double get progress {
    if (totalQuestions == 0) {
      return 0.0;
    }
    if (isComplete) {
      return 1.0;
    }
    return (currentIndex + 1) / totalQuestions;
  }

  /// Human-readable label such as "Question 1 of 6".
  String get progressLabel {
    if (totalQuestions == 0) {
      return 'No questions';
    }
    final displayIndex = isComplete
        ? totalQuestions
        : (currentIndex + 1).clamp(1, totalQuestions);
    return 'Question $displayIndex of $totalQuestions';
  }

  SurveyState copyWith({
    List<SurveyQuestion>? questions,
    int? currentIndex,
    Map<String, String>? answers,
    bool? isComplete,
    bool? voiceEnabled,
  }) {
    return SurveyState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      isComplete: isComplete ?? this.isComplete,
      voiceEnabled: voiceEnabled ?? this.voiceEnabled,
    );
  }

  /// Sections where every question has been answered.
  Set<SurveySection> get completedSections {
    final result = <SurveySection>{};
    for (final section in SurveySection.values) {
      final sectionQuestions = questions.where((q) => q.section == section);
      if (sectionQuestions.isNotEmpty &&
          sectionQuestions.every((q) => answers.containsKey(q.id))) {
        result.add(section);
      }
    }
    return result;
  }

  /// Helper for creating an initial state from a set of questions.
  factory SurveyState.initial(List<SurveyQuestion> questions) {
    return SurveyState(
      questions: List<SurveyQuestion>.unmodifiable(questions),
      currentIndex: 0,
      answers: const <String, String>{},
      isComplete: false,
      voiceEnabled: false,
    );
  }
}

