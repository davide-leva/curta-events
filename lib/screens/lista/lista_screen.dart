import 'dart:math';

import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/models/Group.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/components/button.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/lista/components/group_table.dart';
import 'package:admin/screens/lista/components/search_group.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../../controllers/Config.dart';
import '../components/header.dart';
import '../components/table_button.dart';
import '../party/components/balance.dart';

class ListaScreen extends StatefulWidget {
  @override
  State<ListaScreen> createState() => _ListaScreenState();

  final List<Widget> groups = List.empty(growable: true);
}

class _ListaScreenState extends State<ListaScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final GroupsController _groupController = Get.put(GroupsController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Responsive(
          mobile: _mobileView(context),
          desktop: _desktopView(context),
        ),
      ),
    );
  }

  Column _desktopView(BuildContext context) {
    return Column(
      children: [
        Header(
          screenTitle:
              Config.get('userLevel') == 'pr' ? 'Curta Events' : "Lista",
          buttons: Config.get('userLevel') == 'pr'
              ? []
              : [
                  ActionButton(
                    title: "Aggiungi gruppo",
                    onPressed: () => showPopUp(
                      context,
                      "Aggiungi gruppo",
                      [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: defaultPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(defaultPadding),
                            color: Theme.of(context).cardColor,
                          ),
                          child: TextField(
                            controller: _groupNameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              label: Text("Nome gruppo"),
                            ),
                          ),
                        )
                      ],
                      () => setState(() {
                        _addNewGroup(_groupController, _groupNameController);
                      }),
                    ),
                    icon: Icons.add,
                    color: Colors.lightBlue,
                  ),
                  TableButton(
                      color: Colors.lightBlue,
                      icon: Icons.print,
                      onPressed: () async {
                        Uri url = Uri.parse(
                            'https://docs.google.com/gview?embedded=true&url=${Config.get('dataEndpoint')}${Config.get('selectedParty')}/report/lista');

                        if (await canLaunchUrl(url)) {
                          await launchUrl(url,
                              mode: LaunchMode.platformDefault);
                        }
                      }),
                ],
        ),
        SizedBox(height: defaultPadding),
        Row(
          children: [
            Spacer(),
            Obx(
              () => border(
                Text(
                  "${_groupController.totalEntered} entrate",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: defaultPadding * 2,
            ),
            Obx(
              () => border(
                Text(
                  "${_groupController.totalPeople - _groupController.totalEntered} rimaste",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Config.get('userLevel') == 'pr'
            ? Obx(() {
                int i = 0;
                Widget w = border(Text(
                  "Chiedi allo staff di aggiungere una lista \"${Config.get('operator')}\"",
                  style: Theme.of(context).textTheme.titleLarge,
                ));
                _groupController.groups.forEach((group) {
                  if (group.title == Config.get('operator')) {
                    w = GroupTable(
                        group: group,
                        groupIndex: i,
                        controller: _groupController);
                  }
                  i++;
                });
                return w;
              })
            : _groupController.groups.isEmpty
                ? Container(
                    child: border(
                      Text(
                        "Lista vuota",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            SearchGroup(controller: _groupController),
                            SizedBox(
                              height: defaultPadding,
                            ),
                            ...List.generate(
                              max(0, 2 * _groupController.groups.length - 1),
                              (index) {
                                int groupIndex = index ~/ 2;

                                if (index % 2 == 0) {
                                  return Obx(() => GroupTable(
                                        group:
                                            _groupController.groups[groupIndex],
                                        groupIndex: groupIndex,
                                        controller: _groupController,
                                      ));
                                } else {
                                  return SizedBox(
                                    height: defaultPadding,
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
      ],
    );
  }

  Column _mobileView(BuildContext context) {
    return Column(
      children: [
        Header(
          screenTitle:
              Config.get('userLevel') == 'pr' ? "Curta Events" : "Lista",
          buttons: Config.get('userLevel') == 'pr'
              ? []
              : [
                  TableButton(
                    onPressed: () => showPopUp(
                      context,
                      "Aggiungi gruppo",
                      [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: defaultPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(defaultPadding),
                            color: Theme.of(context).cardColor,
                          ),
                          child: TextField(
                            controller: _groupNameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              label: Text("Nome gruppo"),
                            ),
                          ),
                        )
                      ],
                      () => setState(() {
                        _addNewGroup(_groupController, _groupNameController);
                      }),
                    ),
                    icon: Icons.add,
                    color: Colors.lightBlue,
                  ),
                  TableButton(
                      color: Colors.lightBlue,
                      icon: Icons.print,
                      onPressed: () async {
                        Uri url = Uri.parse(
                            'https://docs.google.com/gview?embedded=true&url=${Config.get('dataEndpoint')}${Config.get('selectedParty')}/report/lista');

                        if (await canLaunchUrl(url)) {
                          await launchUrl(url,
                              mode: LaunchMode.platformDefault);
                        }
                      }),
                ],
        ),
        SizedBox(height: defaultPadding),
        Row(
          children: [
            Spacer(),
            Obx(
              () => border(
                Text(
                  "${_groupController.totalEntered} entrate",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: defaultPadding,
            ),
            Obx(
              () => border(
                Text(
                  "${_groupController.totalPeople - _groupController.totalEntered} rimaste",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Config.get('userLevel') == 'pr'
            ? Obx(() {
                int i = 0;
                Widget w = border(Text(
                  "Chiedi allo staff di aggiungere una lista \"${Config.get('operator')}\"",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ));
                _groupController.groups.forEach((group) {
                  if (group.title == Config.get('operator')) {
                    w = GroupTable(
                        group: group,
                        groupIndex: i,
                        controller: _groupController);
                  }
                  i++;
                });
                return w;
              })
            : _groupController.groups.isEmpty
                ? Container(
                    child: border(
                      Text(
                        "Lista vuota",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            SearchGroup(controller: _groupController),
                            SizedBox(
                              height: defaultPadding,
                            ),
                            ...List.generate(
                              max(0, 2 * _groupController.groups.length - 1),
                              (index) {
                                int groupIndex = index ~/ 2;

                                if (index % 2 == 0) {
                                  return Obx(() => GroupTable(
                                        group:
                                            _groupController.groups[groupIndex],
                                        groupIndex: groupIndex,
                                        controller: _groupController,
                                      ));
                                } else {
                                  return SizedBox(
                                    height: defaultPadding,
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
      ],
    );
  }
}

_addNewGroup(
    GroupsController controller, TextEditingController textField) async {
  ListaGroup _newGroup = ListaGroup(
    id: CloudService.uuid(),
    title: textField.text,
    numberOfPeople: 0,
    people: [],
  );

  await controller.add(_newGroup);
  return;
}
