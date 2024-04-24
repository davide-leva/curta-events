import 'package:admin/controllers/Config.dart';
import 'package:flutter/material.dart';

class LevelBuilder extends StatelessWidget {
  const LevelBuilder({
    Key? key,
    this.admin,
    this.pr,
    this.member,
  }) : super(key: key);

  final Widget? pr;
  final Widget? admin;
  final Widget? member;

  @override
  Widget build(BuildContext context) {
    if (Config.get('userLevel') == 'pr') {
      return pr ?? Container();
    } else if (Config.get('userLevel') == 'admin') {
      return admin ?? Container();
    } else if (Config.get('userLevel') == 'member') {
      return member ?? Container();
    } else
      return Container();
  }
}
