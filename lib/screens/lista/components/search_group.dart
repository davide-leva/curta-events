import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as s;
import 'package:get/get.dart';
import 'package:collection/collection.dart';

import '../../../constants.dart';
import '../../../controllers/TransactionController.dart';
import '../../../models/Person.dart';
import '../../../responsive.dart';
import '../../components/badge.dart';

extension LogicalKeybordKeyComparison on s.LogicalKeyboardKey {
  bool same(s.LogicalKeyboardKey other) {
    return this.keyId == other.keyId;
  }
}

class PersonEntry {
  final Person person;
  final String groupName;
  final int groupIndex;
  final int personIndex;

  PersonEntry(this.person, this.groupName, this.groupIndex, this.personIndex);
}

List<T> flatten<T>(Iterable<Iterable<T>> list) =>
    [for (var sublist in list) ...sublist];

class SearchGroup extends StatefulWidget {
  SearchGroup({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final GroupsController controller;
  final List<PersonEntry> result = List.empty(growable: true);

  @override
  State<SearchGroup> createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  final TransactionController transactionController =
      Get.put(TransactionController());

  final TextEditingController _searchPersonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<PersonEntry> people = flatten(widget.controller.groups
        .mapIndexed((gid, group) => group.people.mapIndexed(
            (pid, person) => PersonEntry(person, group.title, gid, pid))));

    if (_searchPersonController.text.length >= 3 && widget.result.isEmpty) {
      widget.result.addAll(people.where((entry) => entry.person.name
          .toLowerCase()
          .contains(_searchPersonController.text.toLowerCase())));
    }

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (!(event is s.KeyDownEvent)) return;
        if (widget.result.length != 1) return;

        PersonEntry personFound = widget.result.first;

        if (event.logicalKey.same(s.LogicalKeyboardKey.f1)) {
          widget.controller.togglePersonPaid(
              personFound.groupIndex, personFound.personIndex);
        }

        if (event.logicalKey.same(s.LogicalKeyboardKey.f2)) {
          widget.controller.togglePersonEntrance(
              personFound.groupIndex, personFound.personIndex);
        }

        if (event.logicalKey.same(s.LogicalKeyboardKey.f5)) {
          widget.controller
              .removePerson(personFound.groupIndex, personFound.personIndex);
        }
      },
      child: Responsive(
        desktop: _desktopView(context, people),
        mobile: _mobileView(context, people),
      ),
    );
  }

  Container _desktopView(BuildContext context, List<PersonEntry> people) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Ricerca persone",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Spacer(),
              Text(
                "Cerca: ",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(
                width: defaultPadding,
              ),
              SizedBox(
                width: 200,
                height: 28,
                child: Center(
                    child: TextInput(
                        textController: _searchPersonController,
                        label: "",
                        textLength: 3,
                        onTextLength: () {
                          setState(() {
                            widget.result.clear();
                            widget.result.addAll(people.where((entry) =>
                                entry.person.name.toLowerCase().contains(
                                    _searchPersonController.text
                                        .toLowerCase()) ||
                                _searchPersonController.text
                                    .toLowerCase()
                                    .contains(
                                        entry.person.name.toLowerCase())));
                          });
                        },
                        orElse: () {
                          setState(() {
                            widget.result.clear();
                          });
                        })),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: widget.result.length > 0
                ? DataTable2(
                    columnSpacing: 0,
                    columns: [
                      DataColumn(
                        label: Text("Gruppo"),
                      ),
                      DataColumn(
                        label: Text("Nome"),
                      ),
                      DataColumn(
                        label: Text("Stato prenotazione"),
                      ),
                      DataColumn(
                        label: Text("Azioni"),
                      ),
                    ],
                    rows: List.generate(
                      widget.result.length,
                      (index) => _dataRow(widget.result[index], () {
                        widget.controller.removePerson(
                            widget.result[index].groupIndex,
                            widget.result[index].personIndex);
                      }, () {
                        widget.controller.togglePersonPaid(
                            widget.result[index].groupIndex,
                            widget.result[index].personIndex);
                      }, () {
                        widget.controller.togglePersonEntrance(
                            widget.result[index].groupIndex,
                            widget.result[index].personIndex);
                      }),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: defaultPadding * 3,
                      ),
                      Text(
                        "La ricerca non ha prodotto risultati",
                      ),
                      SizedBox(
                        height: defaultPadding * 3,
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Container _mobileView(BuildContext context, List<PersonEntry> people) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ricerca persone",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: defaultPadding,
              ),
              Row(
                children: [
                  Text(
                    "Cerca: ",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  SizedBox(
                    width: 200,
                    height: 32,
                    child: Center(
                        child: TextInput(
                            textController: _searchPersonController,
                            label: "",
                            textLength: 3,
                            onTextLength: () {
                              setState(() {
                                widget.result.clear();
                                widget.result.addAll(people.where((entry) =>
                                    entry.person.name.toLowerCase().contains(
                                        _searchPersonController.text
                                            .toLowerCase()) ||
                                    _searchPersonController.text
                                        .toLowerCase()
                                        .contains(
                                            entry.person.name.toLowerCase())));
                              });
                            },
                            orElse: () {
                              setState(() {
                                widget.result.clear();
                              });
                            })),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: widget.result.length > 0
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: defaultPadding,
                      columns: [
                        DataColumn(
                          label: Text("Gruppo"),
                        ),
                        DataColumn(
                          label: Text("Nome"),
                        ),
                        DataColumn(
                          label: Text("Stato prenotazione"),
                        ),
                        DataColumn(
                          label: Text("Azioni"),
                        ),
                      ],
                      rows: List.generate(
                        widget.result.length,
                        (index) => _dataRow(widget.result[index], () {
                          widget.controller.removePerson(
                              widget.result[index].groupIndex,
                              widget.result[index].personIndex);
                        }, () {
                          widget.controller.togglePersonPaid(
                              widget.result[index].groupIndex,
                              widget.result[index].personIndex);
                        }, () {
                          widget.controller.togglePersonEntrance(
                              widget.result[index].groupIndex,
                              widget.result[index].personIndex);
                        }),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: defaultPadding * 3,
                      ),
                      Text(
                        "La ricerca non ha prodotto risultati",
                      ),
                      SizedBox(
                        height: defaultPadding * 3,
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

DataRow _dataRow(PersonEntry entry, Function() onDelete, Function() onConfirm,
    Function() onEntrance) {
  Person person = entry.person;

  return DataRow(
    cells: [
      DataCell(Text("${entry.groupName}")),
      DataCell(Text("${person.name}")),
      DataCell(
        Row(
          children: [
            person.hasEntered
                ? TableButton(
                    color: Colors.purple,
                    icon: Icons.door_back_door,
                    onPressed: () {})
                : Container(),
            person.hasEntered
                ? SizedBox(
                    width: defaultPadding,
                  )
                : Container(),
            person.hasPaid
                ? InfoBadge(
                    color: Colors.green,
                    text: "Pagato",
                  )
                : InfoBadge(
                    color: Colors.red,
                    text: "Non pagato",
                  )
          ],
        ),
      ),
      DataCell(
        Row(
          children: [
            Container(
                child: TableButton(
              onPressed: onConfirm,
              icon: Icons.check,
              color: Colors.green,
            )),
            SizedBox(
              width: defaultPadding,
            ),
            TableButton(
              onPressed: onDelete,
              icon: Icons.close,
              color: Colors.red,
            ),
            SizedBox(
              width: defaultPadding,
            ),
            TableButton(
              onPressed: onEntrance,
              icon: Icons.door_back_door,
              color: Colors.purple,
            ),
          ],
        ),
      ),
    ],
  );
}