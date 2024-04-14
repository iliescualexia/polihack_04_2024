import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_ui/utils/app_colors.dart';
import 'package:mobile_ui/utils/app_text_style.dart';
import 'package:mobile_ui/utils/custom_sizes.dart';
import 'package:mobile_ui/widgets/choice_button.dart';
import 'package:mobile_ui/widgets/select_button.dart';

class OptionPanel extends StatelessWidget{
  final double width;
  final double height;
  final String optionType;
  final Color color;
  final VoidCallback onPressed;
  final List<String> features = ["Speech Analysis","Body Language Recognition","Video Recording and Playback", "Crowd simulation", "Disruptive Audience Behavior Simulation"];
  final List<String> featuresBeginner = ["Speech Analysis","Body Language Recognition","Video Recording and Playback"];
  final List<String> featuresIntermediate = ["Speech Analysis","Body Language Recognition", "Video Recording and Playback", "Crowd simulation"];
  final List<String> featuresAdvanced = ["Speech Analysis","Body Language Recognition", "Video Recording and Playback", "Crowd simulation", "Disruptive Audience Behavior Simulation"];

  OptionPanel({super.key, required this.width, required this.height, required this.optionType, required this.color, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    List<String> featuresToDisplay = [];
    List<bool> checkList = [];
    if (optionType == 'Beginner') {
      featuresToDisplay = featuresBeginner;
    } else if(optionType == 'Intermediate'){
      featuresToDisplay = featuresIntermediate;
    }
    else if(optionType == 'Advanced'){
      featuresToDisplay = featuresAdvanced;
    }
    featuresToDisplay.forEach((feature) {
      checkList.add(features.contains(feature));
    });
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: color.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Card(
        elevation: 3,
        color: Colors.transparent,
        child: SizedBox(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: CustomSizes.defaultHorizontalOffset(),
              vertical: CustomSizes.defaultVerticalOffset() * 3
            ),
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.center,
              children: [
                Text(
                  optionType,
                  style: AppTextStyle.header(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: CustomSizes.defaultVerticalOffset() * 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(featuresToDisplay.length, (index) {
                      return Row(
                        children: [
                          Icon(
                            checkList[index] ? Icons.check : Icons.close,
                            color: AppColors.black,
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              featuresToDisplay[index],
                              style: TextStyle(
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: CustomSizes.defaultVerticalOffset() * 1,
                      ),
                      child: SelectButton(
                        onPressed: onPressed,
                        color: color,
                        text: "Select"
                      ),
                    ),
                  ),

                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}