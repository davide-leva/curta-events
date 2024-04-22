import 'package:admin/constants.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/screens/party/components/balance.dart';
import 'package:flutter/material.dart';

import '../../../models/Shift.dart';
import '../../components/worker.dart';

class ShiftCard extends StatelessWidget {
  ShiftCard({
    Key? key,
    required this.shift,
    required this.onDelete,
    required this.onModify,
  }) : super(key: key);

  final Shift shift;
  final Function() onDelete;
  final Function() onModify;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 420,
      margin: EdgeInsets.only(
        bottom: defaultPadding,
      ),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: [
        Row(
          children: [
            shift.type == "Festa"
                ? Text(
                    "Turno ${shift.timeStart.format(context)} - ${shift.timeFinish.format(context)}",
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                : Text(
                    shift.type,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
            Spacer(),
            TableButton(
              width: 1.25,
              height: 1.25,
              onPressed: onModify,
              icon: Icons.edit,
              color: Colors.lightBlue,
            ),
            SizedBox(
              width: defaultPadding,
            ),
            TableButton(
              width: 1.25,
              height: 1.25,
              onPressed: onDelete,
              icon: Icons.delete,
              color: Colors.red,
            )
          ],
        ),
        Column(
          children: List.generate(shift.jobs.length, (index) {
            Job job = shift.jobs[index];
            return Container(
              child: border(
                Container(
                  child: Column(
                    children: [
                      Text(
                        job.title,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          job.workers.length,
                          (index) => Worker(
                            name: job.workers[index],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        )
      ]),
    );
  }
}
