import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile_ui/provides/report_provider.dart';
import 'package:mobile_ui/utils/app_colors.dart';
import 'package:mobile_ui/utils/app_text_style.dart';
import 'package:mobile_ui/utils/custom_sizes.dart';
import 'package:provider/provider.dart';

import '../navigation/route_type.dart';

class OverallFeedbackPage extends StatelessWidget {
  final double _rating1 = 3;
  final double _rating2 = 2;
  final double _rating3 = 5;
  final double _overallRating = 4;

  @override
  Widget build(BuildContext context) {
    final ReportProvider reportProvider = context.watch<ReportProvider>();
    return Scaffold(
      backgroundColor: AppColors.ivory,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Feedback Report'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.blue.shade50,
            ),
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Overall Performance Rating Bar
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Overall Performance',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      RatingBar.builder(
                        initialRating: (reportProvider.getPostureRating() + reportProvider.getAverageRating())/2.0,
                        itemCount: 5,
                        ignoreGestures: true,
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return Icon(
                                Icons.sentiment_very_dissatisfied,
                                color: Colors.red,
                              );
                            case 1:
                              return Icon(
                                Icons.sentiment_dissatisfied,
                                color: Colors.redAccent,
                              );
                            case 2:
                              return Icon(
                                Icons.sentiment_neutral,
                                color: Colors.amber,
                              );
                            case 3:
                              return Icon(
                                Icons.sentiment_satisfied,
                                color: Colors.lightGreen,
                              );
                            case 4:
                              return Icon(
                                Icons.sentiment_very_satisfied,
                                color: Colors.green,
                              );
                            default:
                              return Container();
                          }
                        },
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(height: 60),
                // Rating Bar 1
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Speech',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      RatingBar.builder(
                        initialRating: reportProvider.getAverageRating(),
                        itemCount: 5,
                        ignoreGestures: true,
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return Icon(
                                Icons.sentiment_very_dissatisfied,
                                color: Colors.red,
                              );
                            case 1:
                              return Icon(
                                Icons.sentiment_dissatisfied,
                                color: Colors.redAccent,
                              );
                            case 2:
                              return Icon(
                                Icons.sentiment_neutral,
                                color: Colors.amber,
                              );
                            case 3:
                              return Icon(
                                Icons.sentiment_satisfied,
                                color: Colors.lightGreen,
                              );
                            case 4:
                              return Icon(
                                Icons.sentiment_very_satisfied,
                                color: Colors.green,
                              );
                            default:
                              return Container();
                          }
                        },
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(height: 60),

                // Rating Bar 2
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Body Language and Posture',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      RatingBar.builder(
                        initialRating: reportProvider.getPostureRating(),
                        itemCount: 5,
                        ignoreGestures: true,
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return Icon(
                                Icons.sentiment_very_dissatisfied,
                                color: Colors.red,
                              );
                            case 1:
                              return Icon(
                                Icons.sentiment_dissatisfied,
                                color: Colors.redAccent,
                              );
                            case 2:
                              return Icon(
                                Icons.sentiment_neutral,
                                color: Colors.amber,
                              );
                            case 3:
                              return Icon(
                                Icons.sentiment_satisfied,
                                color: Colors.lightGreen,
                              );
                            case 4:
                              return Icon(
                                Icons.sentiment_very_satisfied,
                                color: Colors.green,
                              );
                            default:
                              return Container();
                          }
                        },
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            vertical: CustomSizes.defaultVerticalOffset()*2,
            horizontal: CustomSizes.defaultHorizontalOffset())*2
        ,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(RouteType.DetailedFeedbackPage.path());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade50
          ),
          child: Text(
              'Continue',
              style: AppTextStyle.darkDefaultStyle(),
          ),
        ),
      ),
    );
  }
}
