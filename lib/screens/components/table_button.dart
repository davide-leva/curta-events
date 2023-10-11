import 'package:admin/constants.dart';
import 'package:flutter/material.dart';

class TableButton extends StatelessWidget {
  const TableButton({
    Key? key,
    required this.color,
    required this.icon,
    required this.onPressed,
    this.isDisabled = false,
    this.width = 1.0,
    this.height = 1.0,
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final double width;
  final double height;
  final Function() onPressed;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDisabled ? Colors.grey : color,
        borderRadius: BorderRadius.circular(4),
      ),
      height: defaultPadding * 1.8 * height,
      width: defaultPadding * 1.8 * width,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        onPressed: isDisabled ? () => null : onPressed,
        icon: Icon(
          icon,
          size: 20,
        ),
      ),
    );
  }
}
