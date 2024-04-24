import 'dart:math';

import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/controllers/TransactionController.dart';
import 'package:admin/models/Group.dart';
import 'package:admin/models/Person.dart';
import 'package:admin/models/Transaction.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/components/action_button.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:admin/screens/lista_old/components/group_table.dart';
import 'package:admin/screens/lista_old/components/search_group.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../../controllers/Config.dart';
import '../components/header.dart';
import '../components/table_button.dart';
import '../party/components/balance.dart';

class Pair<T> {
  Pair({
    required this.obj,
    required this.index,
  });

  final T obj;
  final int index;
}

extension IndexList<T> on Iterable<T> {
  Iterable<Pair<T>> get indexed {
    int i = 0;
    return this.map((e) => Pair(obj: e, index: i++));
  }
}

class ListaScreen extends StatefulWidget {
  @override
  State<ListaScreen> createState() => _ListaScreenState();

  final List<Widget> groups = List.empty(growable: true);
}

class _ListaScreenState extends State<ListaScreen> {
  final TextEditingController _namePersonController = TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();
  final GroupsController _groupController = Get.put(GroupsController());
  int _selectedGroup = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(kDefaultPadding),
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
              ? [
                  TableButton(
                    color: Colors.lightBlue,
                    icon: Icons.qr_code,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => MobileScanner(
                        overlay: Column(
                          children: [
                            SizedBox(
                              height: kDefaultPadding * 2,
                            ),
                            Container(
                              padding: EdgeInsets.all(kDefaultPadding),
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius:
                                    BorderRadius.circular(kDefaultPadding),
                              ),
                              child: Text(
                                "Scansiona prevendita",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                        onDetect: (capture) {
                          SearchEntry? search =
                              _groupController.searchBarcode(capture);

                          Navigator.pop(context);

                          if (search == null) {
                            if (Config.get('userLevel') == 'pr') {
                              showPopUp(
                                context,
                                "Aggiungi persona",
                                [
                                  Text(capture.barcodes[0].rawValue ?? ""),
                                  TextInput(
                                      textController: _namePersonController,
                                      label: "Nome"),
                                ],
                                () {
                                  _groupController.addPerson(
                                    _groupController.groups.indexed
                                        .firstWhere((pair) =>
                                            pair.obj.title ==
                                            Config.get('operator'))
                                        .index,
                                    _namePersonController.text,
                                    code: int.parse(
                                      capture.barcodes[0].rawValue ?? "0",
                                    ),
                                  );
                                },
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ]
              : [
                  TableButton(
                    color: Colors.lightBlue,
                    icon: Icons.qr_code,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => MobileScanner(
                        overlay: Column(
                          children: [
                            SizedBox(
                              height: kDefaultPadding * 2,
                            ),
                            Container(
                              padding: EdgeInsets.all(kDefaultPadding),
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius:
                                    BorderRadius.circular(kDefaultPadding),
                              ),
                              child: Text(
                                "Scansiona prevendita",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                        onDetect: (capture) {
                          SearchEntry? search =
                              _groupController.searchBarcode(capture);

                          Navigator.pop(context);

                          if (search == null) {
                            showPopUp(
                              context,
                              "Aggiungi persona",
                              [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.lightBlue,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.payment),
                                          SizedBox(
                                            width: kDefaultPadding,
                                          ),
                                          Text(capture.barcodes[0].rawValue ??
                                              ""),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                TextInput(
                                    textController: _namePersonController,
                                    label: "Nome"),
                                Container(
                                  width: 300,
                                  padding:
                                      EdgeInsets.only(left: kDefaultPadding),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownMenu<int>(
                                    initialSelection: _selectedGroup,
                                    width: 240,
                                    hintText: "Lista",
                                    menuHeight: 300,
                                    inputDecorationTheme: InputDecorationTheme(
                                      border: InputBorder.none,
                                      fillColor: Theme.of(context).cardColor,
                                    ),
                                    dropdownMenuEntries:
                                        _groupController.groups.indexed
                                            .map<DropdownMenuEntry<int>>(
                                              (pair) => DropdownMenuEntry<int>(
                                                value: pair.index,
                                                label: pair.obj.title,
                                              ),
                                            )
                                            .toList(),
                                    onSelected: (value) {
                                      setState(() {
                                        _selectedGroup = value as int;
                                      });
                                    },
                                  ),
                                )
                              ],
                              () {
                                _groupController.addPerson(
                                  _selectedGroup,
                                  _namePersonController.text,
                                  code: int.parse(
                                    capture.barcodes[0].rawValue ?? "0",
                                  ),
                                );
                              },
                            );
                          } else {
                            Person person = _groupController
                                .groups[search.groupIndex]
                                .people[search.personIndex];

                            showPopUp(
                                context,
                                "Prevendita",
                                [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: person.hasEntered
                                            ? Colors.purple
                                            : person.hasPaid
                                                ? Colors.green
                                                : Colors.red,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        width: kDefaultFontSize,
                                      ),
                                      Text(person.name),
                                    ],
                                  ),
                                  ActionButton(
                                    title: "Ritira",
                                    onPressed: () async {
                                      if (!person.hasPaid)
                                        await _groupController.togglePersonPaid(
                                            search.groupIndex,
                                            search.personIndex);
                                      if (!person.hasEntered)
                                        await _groupController
                                            .togglePersonEntrance(
                                                search.groupIndex,
                                                search.personIndex);

                                      Navigator.pop(context);
                                    },
                                    icon: Icons.download,
                                    color: Colors.lightBlue,
                                  )
                                ],
                                () => null);
                          }
                        },
                      ),
                    ),
                  ),
                  ActionButton(
                    title: "Aggiungi gruppo",
                    onPressed: () => showPopUp(
                      context,
                      "Aggiungi gruppo",
                      [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: kDefaultPadding),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(kDefaultPadding),
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
                        Uri url = CloudService.reportUri('lista');
                        await launchUrl(url, mode: LaunchMode.platformDefault);
                      }),
                ],
        ),
        SizedBox(height: kDefaultPadding),
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
              width: kDefaultPadding * 2,
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
          height: kDefaultPadding,
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
            : Obx(
                () => _groupController.groups.isEmpty
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
                                  height: kDefaultPadding,
                                ),
                                ...List.generate(
                                  max(0,
                                      2 * _groupController.groups.length - 1),
                                  (index) {
                                    int groupIndex = index ~/ 2;

                                    if (index % 2 == 0) {
                                      return Obx(() => GroupTable(
                                            group: _groupController
                                                .groups[groupIndex],
                                            groupIndex: groupIndex,
                                            controller: _groupController,
                                          ));
                                    } else {
                                      return SizedBox(
                                        height: kDefaultPadding,
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
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
              ? [
                  TableButton(
                    color: Colors.lightBlue,
                    icon: Icons.qr_code,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => MobileScanner(
                        overlay: Column(
                          children: [
                            SizedBox(
                              height: kDefaultPadding * 2,
                            ),
                            Container(
                              padding: EdgeInsets.all(kDefaultPadding),
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius:
                                    BorderRadius.circular(kDefaultPadding),
                              ),
                              child: Text(
                                "Scansiona prevendita",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                        onDetect: (capture) {
                          SearchEntry? search =
                              _groupController.searchBarcode(capture);

                          Navigator.pop(context);

                          if (search == null) {
                            if (Config.get('userLevel') == 'pr') {
                              showPopUp(
                                context,
                                "Aggiungi persona",
                                [
                                  Text(capture.barcodes[0].rawValue ?? ""),
                                  TextInput(
                                      textController: _namePersonController,
                                      label: "Nome"),
                                ],
                                () {
                                  _groupController.addPerson(
                                    _groupController.groups.indexed
                                        .firstWhere((pair) =>
                                            pair.obj.title ==
                                            Config.get('operator'))
                                        .index,
                                    _namePersonController.text,
                                    code: int.parse(
                                      capture.barcodes[0].rawValue ?? "0",
                                    ),
                                  );
                                },
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ]
              : [
                  TableButton(
                    color: Colors.lightBlue,
                    icon: Icons.qr_code,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => MobileScanner(
                        overlay: Column(
                          children: [
                            SizedBox(
                              height: kDefaultPadding * 2,
                            ),
                            Container(
                              padding: EdgeInsets.all(kDefaultPadding),
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius:
                                    BorderRadius.circular(kDefaultPadding),
                              ),
                              child: Text(
                                "Scansiona prevendita",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                        onDetect: (capture) {
                          SearchEntry? search =
                              _groupController.searchBarcode(capture);

                          Navigator.pop(context);

                          if (search == null) {
                            showPopUp(
                              context,
                              "Aggiungi persona",
                              [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.lightBlue,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.payment),
                                          SizedBox(
                                            width: kDefaultPadding,
                                          ),
                                          Text(capture.barcodes[0].rawValue ??
                                              ""),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                TextInput(
                                    textController: _namePersonController,
                                    label: "Nome"),
                                Container(
                                  width: 300,
                                  padding:
                                      EdgeInsets.only(left: kDefaultPadding),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownMenu<int>(
                                    initialSelection: _selectedGroup,
                                    width: 240,
                                    hintText: "Lista",
                                    menuHeight: 300,
                                    inputDecorationTheme: InputDecorationTheme(
                                      border: InputBorder.none,
                                      fillColor: Theme.of(context).cardColor,
                                    ),
                                    dropdownMenuEntries:
                                        _groupController.groups.indexed
                                            .map<DropdownMenuEntry<int>>(
                                              (pair) => DropdownMenuEntry<int>(
                                                value: pair.index,
                                                label: pair.obj.title,
                                              ),
                                            )
                                            .toList(),
                                    onSelected: (value) {
                                      setState(() {
                                        _selectedGroup = value as int;
                                      });
                                    },
                                  ),
                                )
                              ],
                              () {
                                _groupController.addPerson(
                                  _selectedGroup,
                                  _namePersonController.text,
                                  code: int.parse(
                                    capture.barcodes[0].rawValue ?? "0",
                                  ),
                                );
                              },
                            );
                          } else {
                            Person person = _groupController
                                .groups[search.groupIndex]
                                .people[search.personIndex];

                            showPopUp(
                                context,
                                "Prevendita",
                                [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: person.hasEntered
                                            ? Colors.purple
                                            : person.hasPaid
                                                ? Colors.green
                                                : Colors.red,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        width: kDefaultFontSize,
                                      ),
                                      Text(person.name),
                                    ],
                                  ),
                                  ActionButton(
                                    title: "Ritira",
                                    onPressed: () async {
                                      if (!person.hasPaid)
                                        await _groupController.togglePersonPaid(
                                            search.groupIndex,
                                            search.personIndex);
                                      if (!person.hasEntered)
                                        await _groupController
                                            .togglePersonEntrance(
                                                search.groupIndex,
                                                search.personIndex);

                                      Navigator.pop(context);
                                    },
                                    icon: Icons.download,
                                    color: Colors.lightBlue,
                                  )
                                ],
                                () => null);
                          }
                        },
                      ),
                    ),
                  ),
                  TableButton(
                    onPressed: () => showPopUp(
                      context,
                      "Aggiungi gruppo",
                      [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: kDefaultPadding),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(kDefaultPadding),
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
                        Uri url = CloudService.reportUri('lista');

                        await launchUrl(url, mode: LaunchMode.platformDefault);
                      }),
                ],
        ),
        SizedBox(height: kDefaultPadding),
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
              width: kDefaultPadding,
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
          height: kDefaultPadding,
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
            : Obx(
                () => _groupController.groups.isEmpty
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
                                  height: kDefaultPadding,
                                ),
                                ...List.generate(
                                  max(0,
                                      2 * _groupController.groups.length - 1),
                                  (index) {
                                    int groupIndex = index ~/ 2;

                                    if (index % 2 == 0) {
                                      return Obx(() => GroupTable(
                                            group: _groupController
                                                .groups[groupIndex],
                                            groupIndex: groupIndex,
                                            controller: _groupController,
                                          ));
                                    } else {
                                      return SizedBox(
                                        height: kDefaultPadding,
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
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

_updateTransaction(GroupsController groupController,
    TransactionController transactionController) {
  Transaction transaction = transactionController.transactions.singleWhere(
    (transaction) => transaction.title == "Prevendite",
    orElse: () => Transaction(
      id: CloudService.uuid(),
      title: "Prevendite",
      amount: 0.0,
      description: "",
    ),
  );

  double prevendite = 0;
  for (var group in groupController.groups) {
    double count = 0;

    for (var person in group.people) {
      if (person.hasPaid) count++;
    }

    prevendite += count;
  }

  Transaction newTransaction = Transaction(
    id: transaction.id,
    title: "Prevendite",
    amount: prevendite * 15.0,
    description: "",
  );
  transactionController.modify(transaction, newTransaction);
}
