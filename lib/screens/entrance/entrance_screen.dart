import 'package:admin/constants.dart';
import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/screens/entrance/components/participant_list.dart';
import 'package:admin/screens/entrance/components/selected_participant_list.dart';
import 'package:admin/screens/components/header.dart';
import 'package:admin/screens/party/components/balance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntranceScreen extends StatelessWidget {
  const EntranceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _groupsController = Get.put(GroupsController());

    return SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Column(
              children: [
                Header(screenTitle: "Entrata"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => border(
                        Text(
                          "${_groupsController.totalEntered} ingressi",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: kDefaultPadding,
                    ),
                    Obx(
                      () => border(
                        Text(
                          "${_groupsController.totalPeople - _groupsController.totalEntered} rimasti",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: kDefaultPadding,
                ),
                SelectedParticipantList(),
                SizedBox(
                  height: kDefaultPadding,
                ),
                ParticipantList(),
              ],
            )));
  }
}
