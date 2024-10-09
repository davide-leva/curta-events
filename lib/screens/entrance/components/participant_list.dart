import 'package:admin/constants.dart';
import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/screens/entrance/components/person_entrance_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParticipantList extends StatelessWidget {
  const ParticipantList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GroupsController _groupsController = Get.put(GroupsController());

    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lista",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: kDefaultPadding,
          ),
          Obx(() => Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: kDefaultPadding,
                  runSpacing: kDefaultPadding,
                  children: _groupsController.getAllPerson
                      .map(
                          (e) => PersonEntranceCard(person: e.entity, id: e.id))
                      .toList(),
                ),
              ))
        ],
      ),
    );
  }
}
