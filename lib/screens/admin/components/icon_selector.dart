import 'package:flutter/material.dart';

class IconSelector extends StatefulWidget {
  IconSelector({
    Key? key,
    required this.onChange,
    this.initialSelection,
  }) : super(key: key);

  final void Function(IconData icon) onChange;
  final IconData? initialSelection;

  @override
  State<IconSelector> createState() => _IconSelectorState();
}

class _IconSelectorState extends State<IconSelector> {
  IconData? _icon;

  @override
  Widget build(BuildContext context) {
    if (_icon == null) _icon = widget.initialSelection ?? Icons.phone_android;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => setState(() {
            _icon = Icons.phone_android;
            widget.onChange(Icons.phone_android);
          }),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: _icon == Icons.phone_android
                  ? Colors.lightBlue
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.phone_android),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() {
            _icon = Icons.laptop;
            widget.onChange(Icons.laptop);
          }),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: _icon == Icons.laptop
                  ? Colors.lightBlue
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.laptop),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() {
            _icon = Icons.desktop_windows;
            widget.onChange(Icons.desktop_windows);
          }),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: _icon == Icons.desktop_windows
                  ? Colors.lightBlue
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.desktop_windows),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() {
            _icon = Icons.tablet;
            widget.onChange(Icons.tablet);
          }),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: _icon == Icons.tablet
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
