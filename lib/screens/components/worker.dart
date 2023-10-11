import 'package:flutter/material.dart';

import '../../controllers/Config.dart';
import '../../responsive.dart';

class Worker extends StatelessWidget {
  const Worker({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Icon(
              Icons.person,
              size: 60,
              color: Config.get('operator') == name
                  ? Colors.amber.shade600
                  : Colors.lightBlue,
            ),
            Text(name)
          ],
        ),
      ),
      mobile: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Icon(
              Icons.person,
              size: 40,
              color: Config.get('operator') == name
                  ? Colors.amber.shade600
                  : Colors.lightBlue,
            ),
            Text(name)
          ],
        ),
      ),
    );
  }
}
