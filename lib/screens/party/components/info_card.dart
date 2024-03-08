import 'package:flutter/material.dart';

import '../../../constants.dart';

class InfoCard extends StatelessWidget {
  InfoCard(
      {Key? key,
      required this.color,
      required this.icon,
      required this.title,
      required this.child})
      : super(key: key);

  final Color color;
  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: color,
                  ),
                ),
              ),
              SizedBox(
                width: kDefaultPadding,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Spacer(),
              Icon(Icons.more_vert, color: Colors.grey)
            ],
          ),
          child
        ],
      ),
    );
  }
}
