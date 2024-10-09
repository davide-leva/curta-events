import 'dart:math';

import 'package:admin/constants.dart';
import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/models/Group.dart';
import 'package:admin/screens/components/header.dart';
import 'package:admin/screens/components/level_builder.dart';
import 'package:admin/screens/lista/components/add_lista.dart';
import 'package:admin/screens/lista/components/entrance_scanner.dart';
import 'package:admin/screens/lista/components/member_preve_scanner.dart';
import 'package:admin/screens/lista/components/group_card.dart';
import 'package:admin/screens/lista/components/preve_scanner.dart';
import 'package:admin/screens/lista/components/print_lista.dart';
import 'package:admin/screens/lista/components/search_card.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListaScreen extends StatelessWidget {
  const ListaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GroupsController _groupsController = Get.put(GroupsController());

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            Header(
              screenTitle: "Lista",
              buttons: [
                LevelBuilder(
                  pr: PreveScanner(),
                  member: MemberPreveScanner(),
                  admin: MemberPreveScanner(),
                ),
                LevelBuilder(
                  member: EntranceScanner(),
                  admin: EntranceScanner(),
                ),
                LevelBuilder(
                  member: AddLista(
                    onGroup: (name) => _addNewGroup(_groupsController, name),
                  ),
                  admin: AddLista(
                    onGroup: (name) => _addNewGroup(_groupsController, name),
                  ),
                ),
                LevelBuilder(
                  member: PrintLista(),
                  admin: PrintLista(),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Obx(() => Column(
                        children: [
                          SizedBox(
                            height: kDefaultPadding,
                          ),
                          SearchCard(),
                          SizedBox(
                            height: kDefaultPadding,
                          ),
                          ...List.generate(
                            max(0, 2 * _groupsController.groups.length - 1),
                            (index) {
                              int groupIndex = index ~/ 2;

                              if (index % 2 == 0) {
                                return Obx(
                                  () => GroupCard(
                                    group: _groupsController.groups[groupIndex],
                                    gid: groupIndex,
                                  ),
                                );
                              } else {
                                return SizedBox(
                                  height: kDefaultPadding,
                                );
                              }
                            },
                          )
                        ],
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

_addNewGroup(GroupsController controller, String groupName) async {
  ListaGroup _newGroup = ListaGroup(
    id: CloudService.uuid(),
    title: groupName,
    numberOfPeople: 0,
    people: [],
  );

  await controller.add(_newGroup);
  return;
}
