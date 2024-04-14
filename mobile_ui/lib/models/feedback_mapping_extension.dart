import 'package:mobile_ui/models/feedback_model.dart';

extension FeedbackModelExtension on FeedbackModel{
  static FeedbackModel fromJson(Map<String, dynamic> json) {
    FeedbackModel feedback = FeedbackModel();
    feedback.stutteringValue = json['stuttering_value'] ?? 0.0;
    feedback.pausesValue = json['pauses_value'] ?? 0.0;
    feedback.isMonotone = json['is_monotone'] == 'true';
    feedback.repeatedWords = List<String>.from(json['repeated_words'] ?? []);
    feedback.aiFeedback = json['ai_feedback'];
    feedback.badPosturePercentage = json['bad_posture'];
    return feedback;
  }
}