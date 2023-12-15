import 'package:flutter/material.dart';

class IconSelector extends StatefulWidget {
  IconSelector({
    Key? key,
    required this.onChange,
    this.initialSelection,
  }) : super(key: key);

  final void Function(IconData icon) onChange;
  final IconData? initialSelection;

  IconData? _icon;

  @override
  State<IconSelector> createState() => _IconSelectorState();
}

class _IconSelectorState extends State<IconSelector> {
  @override
  Widget build(BuildContext context) {
    if (widget._icon == null)
      widget._icon = widget.initialSelection ?? Icons.phone_android;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => setState(() {
            widget._icon = Icons.phone_android;
            widget.onChange(Icons.phone_android);
          }),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: widget._icon == Icons.phone_android
                  ? Colors.lightBlue
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.phone_android),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() {
            widget._icon = Icons.laptop;
            widget.onChange(Icons.laptop);
          }),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: widget._icon == Icons.laptop
                  ? Colors.lightBlue
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.laptop),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() {
            widget._icon = Icons.desktop_windows;
            widget.onChange(Icons.desktop_windows);
          }),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: widget._icon == Icons.desktop_windows
                  ? Colors.lightBlue
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.desktop_windows),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() {
            widget._icon = Icons.tablet;
            widget.onChange(Icons.tablet);
          }),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: widget._icon == Icons.tablet
                  ? Colors.lightBlue
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.tablet),
          ),
        )
      ],
    );
  }
}
