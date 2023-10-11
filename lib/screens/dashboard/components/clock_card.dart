import 'dart:async';

import 'package:admin/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../party/components/balance.dart';

class ClockCard extends StatefulWidget {
  const ClockCard({Key? key}) : super(key: key);

  @override
  State<ClockCard> createState() => _ClockCardState();
}

class _ClockCardState extends State<ClockCard> {
  late Timer timer;
  late int hour = DateTime.now().hour;
  late int minute = DateTime.now().minute;
  late int second = DateTime.now().second;

  @override
  void initState() {
    timer = Timer.periodic(1.seconds, (timer) {
      DateTime now = DateTime.now();

      setState(() {
        hour = now.hour;
        minute = now.minute;
        second = now.second;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    return super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        defaultPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          defaultPadding,
        ),
        color: Theme.of(context).canvasColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('dd MMMM yyyy', 'it').format(DateTime.now()),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              border(Text(
                "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.white, fontFamily: "RobotoMono"),
              ))
            ],
          ),
        ],
      ),
    );
  }
}
