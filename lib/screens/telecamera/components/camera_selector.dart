import 'dart:convert';

import 'package:admin/constants.dart';
import 'package:admin/screens/components/button.dart';
import 'package:flutter/material.dart';

import '../../../controllers/Config.dart';

class CameraSelector extends StatefulWidget {
  const CameraSelector({
    required this.onChange,
  });

  final void Function(int camera) onChange;

  @override
  State<CameraSelector> createState() => _CameraSelectorState();
}

class _CameraSelectorState extends State<CameraSelector> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(defaultPadding),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          jsonDecode(Config.get('cameras')).length + 1,
          (index) {
            if (index == 0) {
              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: defaultPadding,
                ),
                child: ActionButton(
                  title: "Multi cam",
                  onPressed: () => setState(() {
                    _index = index;
                    widget.onChange(index);
                  }),
                  icon: Icons.security,
                  color: index == _index
                      ? Colors.amber.shade600
                      : Colors.lightBlue,
                ),
              );
            } else {
              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: defaultPadding,
                ),
                child: ActionButton(
                  title: jsonDecode(Config.get('cameras'))[index - 1]['name'],
                  onPressed: () => setState(() {
                    _index = index;
                    widget.onChange(index);
                  }),
                  icon: Icons.videocam,
                  color: index == _index
                      ? Colors.amber.shade600
                      : Colors.lightBlue,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
