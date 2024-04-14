import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_style.dart';
import '../utils/custom_sizes.dart';

class SelectButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const SelectButton(
      {super.key, required this.text, required this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          side: const BorderSide(
          color: AppColors.black,
      )
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: CustomSizes.defaultHorizontalOffset() * 4),
          child: Text(
            text,
            style: const AppTextStyle(
              fontSize: 15,
              color: AppColors.black,
            ),
          )
      ),
    );
  }
}
