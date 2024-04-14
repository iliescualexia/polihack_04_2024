import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../navigation/route_type.dart';
import '../provides/report_provider.dart';
import '../utils/app_colors.dart';

class DetailedFeedbackPage extends StatelessWidget {
  const DetailedFeedbackPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ReportProvider reportProvider = context.watch<ReportProvider>();
    List<String> titles= ["Personal Feedback","Stuttering", "Pauses", "Monotony","Word Repetition","Posture"];
    List<String> contents=[reportProvider.report?.aiFeedback ?? "", reportProvider.evaluateStutteringValue(), reportProvider.evaluatePausesValue(), reportProvider.evaluateMonotone(), reportProvider.evaluateWordRepetition(),reportProvider.evaluatePosture()];
    return Scaffold(
      backgroundColor: AppColors.ivory,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Detailed Feedback'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...List.generate(titles.length, (index) {
                return FeedbackBox(
                  title: titles[index],
                  content: contents[index],
                );
              }).toList(),
              SizedBox(height: 20), // Add some spacing between feedback boxes and the button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade50
                ),
                child: Text('Finish Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class FeedbackBox extends StatelessWidget {
  final String title;
  final String content;

  const FeedbackBox({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Text(
              content,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}