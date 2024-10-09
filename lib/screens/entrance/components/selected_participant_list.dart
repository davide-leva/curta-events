import 'package:admin/constants.dart';
import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/screens/entrance/components/person_entrance_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedParticipantList extends StatelessWidget {
  const SelectedParticipantList({Key? key}) : super(key: key);

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
            "In cassa",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: kDefaultPadding,
          ),
          SizedBox(
            height: 120,
            child: Obx(() => Center(
                child: _groupsController.getSelectedPerson.length != 0
                    ? Wrap(
                        alignment: WrapAlignment.center,
                        spacing: kDefaultPadding,
                        runSpacing: kDefaultPadding,
                        children: _groupsController.getSelectedPerson
                            .map(
                              (e) => PersonEntranceCard(
                                person: e.entity,
                                id: e.id,
                                isSelected: true,
                              ),
                            )
                            .toList(),
                      )
                    : Container(
                        padding: EdgeInsets.all(kDefaultPadding),
                        decoration: BoxDecoration(
                          color: kCardColor,
                          borderRadius: BorderRadius.circular(kDefaultPadding),
                        ),
                        child: Wrap(
                          children: [
                            Icon(
                              Icons.door_back_door,
                              size: 32,
                            ),
                            SizedBox(
                              width: kDefaultPadding,
                            ),
                            Text(
                              "Cassa libera",
                              style: Theme.of(context).textTheme.titleMedium,
                            )
                          ],
                        ),
                      ))),
          )
        ],
      ),
    );
  }
}
