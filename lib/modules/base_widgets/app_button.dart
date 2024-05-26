import 'package:Google_maps/extensions/mediaQuery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'myText.dart';

class AppButton extends StatelessWidget {

  void Function()? onPressed;
  String text;
  Color? buttonColor;
  Color? buttonTextColor;
  double width;

  AppButton({super.key,
    required this.onPressed,
    required this.text,
    this.buttonColor,
    this.buttonTextColor,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor?? Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
        ),
      ),
      child: SizedBox(
        height: 40.h,
        width: context.setWidth(width),
        child: Center(
          child: MyText(
            text: text,
            color: buttonTextColor?? Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
