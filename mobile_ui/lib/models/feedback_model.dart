import 'dart:ffi';

class FeedbackModel{
  late double stutteringValue;
  late double pausesValue;
  late bool isMonotone;
  late List<String> repeatedWords;
  late String aiFeedback;
  late double badPosturePercentage;
}