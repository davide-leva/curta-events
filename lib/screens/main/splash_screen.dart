import 'package:admin/constants.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            scale: 5,
          ),
          SizedBox(
            height: kDefaultPadding * 2,
          ),
          LoadingAnimationWidget.horizontalRotatingDots(
              color: Colors.white, size: 16)
        ],
      ),
    );
  }
}
