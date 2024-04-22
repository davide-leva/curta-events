import 'dart:math';

import 'package:admin/constants.dart';
import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/screens/components/header.dart';
import 'package:admin/screens/new_lista/components/group_card.dart';
import 'package:admin/screens/new_lista/components/search_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewListaScreen extends StatelessWidget {
  const NewListaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GroupsController _groupsController = Get.put(GroupsController());

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            Header(screenTitle: "Lista"),
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
