import 'package:flutter/material.dart';

class IconSelector extends StatefulWidget {
  const IconSelector({
    Key? key,
    this.onChange,
    this.initialSelection,
  }) : super(key: key);

  final void Function(IconData icon)? onChange;
  final IconData? initialSelection;

  @override
  State<IconSelector> createState() => _IconSelectorState();
}

class _IconSelectorState extends State<IconSelector> {
  @override
  Widget build(BuildContext context) {
    IconData _icon = widget.initialSelection ?? Icons.phone_android;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => setState(() {
            _icon = Icons.phone_android;
            widget.onChange?.call(_icon);
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
            widget.onChange?.call(_icon);
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
            widget.onChange?.call(_icon);
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
            _icon = Icons.watch;
            widget.onChange?.call(_icon);
          }),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: _icon == Icons.watch
                  ? Colors.lightBlue
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.watch),
          ),
        )
      ],
    );
  }
}
