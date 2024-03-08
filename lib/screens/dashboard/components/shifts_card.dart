import 'dart:async';

import 'package:admin/models/Shift.dart';
import 'package:admin/screens/components/worker.dart' as w;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controllers/ShiftsController.dart';
import '../../party/components/balance.dart';

extension CompareTime on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }
}

class ShiftsCard extends StatefulWidget {
  ShiftsCard({Key? key}) : super(key: key);

  @override
  State<ShiftsCard> createState() => _ShiftsCardState();
}

class _ShiftsCardState extends State<ShiftsCard> {
  Shift _shift = _selectShift(TimeOfDay.now());
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(1.seconds, (_) {
      Shift shift = _selectShift(TimeOfDay.now());

      if (shift.id != _shift.id) {
        setState(() {
          _shift = shift;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Turno corrente",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Center(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: _shift.jobs
                  .map<Widget>(
                    (job) => Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: border(
                        Container(
                          constraints: BoxConstraints(minWidth: 120),
                          child: Column(
                            children: [
                              Text(
                                job.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              SizedBox(
                                height: kDefaultPadding,
                              ),
                              Wrap(
                                children: job.workers
                                    .map((worker) => w.Worker(name: worker))
                                    .toList(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

Shift _selectShift(TimeOfDay time) {
  ShiftController _controller = Get.put(ShiftController());
  return _controller.shifts.firstWhereOrNull((shift) =>
          shift.timeStart.compareTo(time) < 1 &&
          shift.timeFinish.compareTo(time) == 1) ??
      Shift(
          id: 'notFound',
          timeStart: TimeOfDay.now(),
          timeFinish: TimeOfDay.now(),
          jobs: []);
}
