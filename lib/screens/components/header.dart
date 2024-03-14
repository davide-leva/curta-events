import 'package:admin/controllers/MenuController.dart' as controller;
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.screenTitle,
    this.buttons = const <Widget>[],
  }) : super(key: key);

  final String screenTitle;
  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttonSpace = <Widget>[];

    buttons.forEach((button) {
      buttonSpace.add(button);
      buttonSpace.add(SizedBox(width: kDefaultPadding));
    });

    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: context.read<controller.MenuController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          Text(
            screenTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        Spacer(),
        ...buttonSpace,
      ],
    );
  }
}
