import '../models/survey_question.dart';

/// Offline mock questions for the Field Guide demo.
///
/// These are static, non-localized prompts that can be used while
/// wiring up survey flows and UI interactions.
final List<SurveyQuestion> mockQuestions = <SurveyQuestion>[
  SurveyQuestion(
    id: 'health_1',
    section: SurveySection.health,
    title: 'Health Question 1',
    prompt: 'Do you have trouble sleeping?',
    options: <String>[
      'Never',
      'Sometimes',
      'Often',
    ],
    audioAsset: 'assets/audio/health_q1.mp3',
  ),
  SurveyQuestion(
    id: 'stress_1',
    section: SurveySection.stress,
    title: 'Stress Question 1',
    prompt: 'In the past week, how often have you felt stressed?',
    options: <String>[
      'Never',
      'Sometimes',
      'Often',
    ],
    audioAsset: 'assets/audio/stress_q1.mp3',
  ),
  SurveyQuestion(
    id: 'social_1',
    section: SurveySection.social,
    title: 'Social Question 1',
    prompt: 'Do you feel you can rely on someone when you need help?',
    options: <String>[
      'Yes, always',
      'Sometimes',
      'Rarely or never',
    ],
  ),
  SurveyQuestion(
    id: 'social_2',
    section: SurveySection.social,
    title: 'Social Question 2',
    prompt: 'How often do you feel left out?',
    options: <String>[
      'Rarely or never',
      'Sometimes',
      'Often',
    ],
  ),
  SurveyQuestion(
    id: 'economics_1',
    section: SurveySection.economics,
    title: 'Economics Question 1',
    prompt: 'Can you pay your bills each month?',
    options: <String>[
      'Yes, easily',
      'Mostly, but it is hard',
      'No, I often cannot',
    ],
  ),
  SurveyQuestion(
    id: 'economics_2',
    section: SurveySection.economics,
    title: 'Economics Question 2',
    prompt: 'Do you have enough food most weeks?',
    options: <String>[
      'Yes, always',
      'Sometimes',
      'No, not enough',
    ],
  ),
];

