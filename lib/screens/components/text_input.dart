import 'package:flutter/material.dart';

import '../../constants.dart';

void _voidFunction() {}

class TextInput extends StatefulWidget {
  const TextInput({
    Key? key,
    required this.textController,
    required this.label,
    this.editable = true,
    this.onTextLength = _voidFunction,
    this.orElse = _voidFunction,
    this.textLength = 3,
    this.obscure = false,
  }) : super(key: key);

  final TextEditingController textController;
  final String label;
  final bool editable;
  final Function() onTextLength;
  final Function() orElse;
  final int textLength;
  final bool obscure;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool hintText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).cardColor,
      ),
      child: TextField(
        obscureText: widget.obscure,
        onChanged: (value) {
          if (value.length > widget.textLength) {
            widget.onTextLength();
          }
          if (value.length <= widget.textLength) {
            widget.orElse();
          }
        },
        enabled: widget.editable,
        textCapitalization:
            widget.obscure ? TextCapitalization.none : TextCapitalization.words,
        controller: widget.textController,
        decoration: InputDecoration(
          border: InputBorder.none,
          label: Text(widget.label),
        ),
      ),
    );
  }
}
