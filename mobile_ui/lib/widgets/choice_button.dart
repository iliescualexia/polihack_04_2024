import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_text_style.dart';

class ChoiceButton extends StatelessWidget{
  final VoidCallback onPressed;
  final Color color;
  final String text;
  const ChoiceButton({super.key, required this.color, required this.text,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150,
        height: 150,
        child: Material(
            color: color,
            borderRadius: BorderRadius.circular(75),
            child: InkWell(
              borderRadius: BorderRadius.circular(75),
              onTap: onPressed,
              child: Center(
                child: Text(
                  text,
                  style: AppTextStyle.darkDefaultStyle()
                ),
              ),
            )
        ));

  }


}