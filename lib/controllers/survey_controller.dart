import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_questions.dart';
import '../models/survey_question.dart';
import 'survey_state.dart';

class SurveyController extends StateNotifier<SurveyState> {
  SurveyController()
      : super(SurveyState.initial(mockQuestions));

  /// Select an [option] for a given [questionId], advancing the survey.
  ///
  /// If the current question is not the last one, this will move to the next
  /// index. If it is the last question, [isComplete] is set to true and the
  /// index is clamped to the last question.
  void selectOption(String questionId, String option) {
    // Update answers map immutably.
    final updatedAnswers = Map<String, String>.from(state.answers)
      ..[questionId] = option;

    var nextIndex = state.currentIndex;
    var isComplete = state.isComplete;

    if (!isComplete && state.totalQuestions > 0) {
      final isLast = state.currentIndex >= state.totalQuestions - 1;
      if (isLast) {
        isComplete = true;
        nextIndex = state.totalQuestions - 1;
      } else {
        nextIndex = state.currentIndex + 1;
      }
    }

    state = state.copyWith(
      answers: updatedAnswers,
      currentIndex: nextIndex,
      isComplete: isComplete,
    );

     // 🔍 DEBUG PRINT (temporary)
    print('--- Survey State Updated ---');
    print('QuestionId: $questionId');
    print('Selected: $option');
    print('Current Index: ${state.currentIndex}');
    print('Is Complete: ${state.isComplete}');
    print('Answers: ${state.answers}');
    print('Progress: ${state.progressLabel} (${(state.progress * 100).toStringAsFixed(0)}%)');
  }

  /// Jump to a specific question index, clamped to a valid range.
  void goToIndex(int index) {
    if (state.totalQuestions == 0) {
      return;
    }
    final clamped = index.clamp(0, state.totalQuestions - 1);
    state = state.copyWith(
      currentIndex: clamped,
      // Moving around implies the survey is in progress.
      isComplete: false,
    );
  }

  /// Reset the survey back to the first question with no answers.
  void reset() {
    state = SurveyState.initial(state.questions);
  }
}

/// Riverpod provider exposing the survey controller and its state.
final surveyControllerProvider =
    StateNotifierProvider<SurveyController, SurveyState>(
  (ref) => SurveyController(),
);

