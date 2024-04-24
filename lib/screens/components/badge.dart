import 'package:admin/constants.dart';
import 'package:flutter/material.dart';

class InfoBadge extends StatelessWidget {
  InfoBadge({
    Key? key,
    required this.color,
    required this.text,
    this.size,
  }) : super(key: key);

  final Color color;
  final String text;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: kDefaultPadding * 1.8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.5,
        vertical: kDefaultPadding * 0.25,
      ),
      child: Center(
        child: Text(text),
      ),
    );
  }
}
