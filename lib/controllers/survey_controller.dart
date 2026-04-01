import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/mock_questions.dart';
import '../models/survey_question.dart';
import 'survey_state.dart';

/// Must be overridden in main.dart before the app starts.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

class SurveyController extends StateNotifier<SurveyState> {
  SurveyController(this._prefs)
      : super(SurveyState.initial(mockQuestions)) {
    _loadPersistedState();
  }

  final SharedPreferences _prefs;
  final AudioPlayer _audioPlayer = AudioPlayer();

  static const _answersKey = 'survey_answers';
  static const _indexKey = 'survey_index';
  static const _completeKey = 'survey_complete';

  // ── Persistence ───────────────────────────────────────────────────────────

  void _loadPersistedState() {
    final answersJson = _prefs.getString(_answersKey);
    if (answersJson == null) return;
    try {
      final answers = Map<String, String>.from(
        jsonDecode(answersJson) as Map,
      );
      final currentIndex = _prefs.getInt(_indexKey) ?? 0;
      final isComplete = _prefs.getBool(_completeKey) ?? false;
      state = state.copyWith(
        answers: answers,
        currentIndex: currentIndex,
        isComplete: isComplete,
      );
    } catch (_) {
      // Corrupt persisted data — start fresh.
    }
  }

  Future<void> _persistState() async {
    await Future.wait([
      _prefs.setString(_answersKey, jsonEncode(state.answers)),
      _prefs.setInt(_indexKey, state.currentIndex),
      _prefs.setBool(_completeKey, state.isComplete),
    ]);
  }

  // ── Audio ─────────────────────────────────────────────────────────────────

  Future<void> _playCurrentAudio() async {
    final q = state.currentQuestion;
    if (!state.voiceEnabled || q.audioAsset == null) return;
    try {
      await _audioPlayer.stop();
      // AssetSource path is relative to the Flutter assets/ directory.
      final assetPath = q.audioAsset!.replaceFirst('assets/', '');
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (_) {
      // Audio file missing or playback error — fail silently.
    }
  }

  // ── Public API ────────────────────────────────────────────────────────────

  void selectOption(String questionId, String option) {
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

    _persistState();
    _playCurrentAudio();
  }

  void goToIndex(int index) {
    if (state.totalQuestions == 0) return;
    final clamped = index.clamp(0, state.totalQuestions - 1);
    state = state.copyWith(
      currentIndex: clamped,
      isComplete: false,
    );
    _playCurrentAudio();
  }

  void goToPrevious() {
    if (state.currentIndex > 0) {
      goToIndex(state.currentIndex - 1);
    }
  }

  void goToSection(SurveySection section) {
    final index = state.questions.indexWhere((q) => q.section == section);
    if (index == -1) return;
    goToIndex(index);
  }

  void reset() {
    _audioPlayer.stop();
    state = SurveyState.initial(state.questions);
    _persistState();
  }

  void toggleVoiceEnabled() {
    state = state.copyWith(voiceEnabled: !state.voiceEnabled);
    if (!state.voiceEnabled) {
      _audioPlayer.stop();
    } else {
      _playCurrentAudio();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

/// Riverpod provider exposing the survey controller and its state.
final surveyControllerProvider =
    StateNotifierProvider<SurveyController, SurveyState>(
  (ref) => SurveyController(ref.watch(sharedPreferencesProvider)),
);
