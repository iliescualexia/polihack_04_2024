class ReportModel{
  late double stutteringRating;
  late double pausesRating;
  late double monotoneRating;
  late List<String> repeatedWords;
  late String aiFeedback;
  late double badPosturePercentage;
  ReportModel({
    required this.stutteringRating,
    required this.pausesRating,
    required this.monotoneRating,
    required this.repeatedWords,
    required this.aiFeedback,
    required this.badPosturePercentage
  });
}