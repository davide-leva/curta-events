import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/models/Group.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';

class GuestsList extends StatelessWidget {
  GuestsList({
    Key? key,
  }) : super(key: key);

  final groupController = Get.put(GroupsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Invitati",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => DataTable2(
                columnSpacing: kDefaultPadding,
                minWidth: 600,
                columns: [
                  DataColumn(
                    label: Text("Gruppo"),
                  ),
                  DataColumn(
                    label: Text("Prevendite"),
                  ),
                  DataColumn(
                    label: Text("Saldati"),
                  ),
                  DataColumn(label: Text("Incasso"))
                ],
                rows: List.generate(
                  groupController.groups.length,
                  (index) => _dataRow(groupController.groups[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow _dataRow(ListaGroup group) {
  return DataRow(
    cells: [
      DataCell(Text(group.title)),
      DataCell(Text("${group.numberOfPeople}")),
      DataCell(Text("${group.actualIncome}€")),
      DataCell(Text("${group.totalIncome}€"))
    ],
  );
}
