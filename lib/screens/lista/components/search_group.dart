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

  void _updateResult() {
    final List<PersonEntry> people = flatten(
      widget.controller.groups.mapIndexed(
        (gid, group) => group.people.mapIndexed(
          (pid, person) => PersonEntry(person, group.title, gid, pid),
        ),
      ),
    );

    widget.result.assignAll(people.where((entry) {
      List<String> words =
          _searchPersonController.text.toLowerCase().split(' ');

      bool flag = true;
      words.forEach((word) {
        flag = flag && entry.person.name.toLowerCase().contains(word) ||
            word.contains(
              entry.person.name.toLowerCase(),
            );
      });

      return flag;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) async {
        if (!(event is s.KeyDownEvent)) return;
        if (widget.result.length != 1) return;

        PersonEntry personFound = widget.result.first;

        if (event.logicalKey.same(PAY_KEY)) {
          await widget.controller.togglePersonPaid(
              personFound.groupIndex, personFound.personIndex);
          setState(_updateResult);
        }

        if (event.logicalKey.same(ENTRANCE_KEY)) {
          await widget.controller.togglePersonEntrance(
              personFound.groupIndex, personFound.personIndex);
          setState(_updateResult);
        }

        if (event.logicalKey.same(DELETE_KEY)) {
          await widget.controller
              .removePerson(personFound.groupIndex, personFound.personIndex);
          setState(_updateResult);
        }
      },
      child: Responsive(
        desktop: _desktopView(context),
        mobile: _mobileView(context),
      ),
    );
  }

  Container _desktopView(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
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
                width: kDefaultPadding,
              ),
              SizedBox(
                width: 200,
                height: 28,
                child: Center(
                  child: TextInput(
                    textController: _searchPersonController,
                    label: "",
                    textLength: 2,
                    onTextLength: () {
                      setState(_updateResult);
                    },
                    orElse: () {
                      setState(() {
                        widget.result.clear();
                      });
                    },
                  ),
                ),
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
                        setState(_updateResult);
                      }, () {
                        widget.controller.togglePersonPaid(
                            widget.result[index].groupIndex,
                            widget.result[index].personIndex);
                        setState(_updateResult);
                      }, () {
                        widget.controller.togglePersonEntrance(
                            widget.result[index].groupIndex,
                            widget.result[index].personIndex);
                        setState(_updateResult);
                      }),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: kDefaultPadding * 3,
                      ),
                      Text(
                        "La ricerca non ha prodotto risultati",
                      ),
                      SizedBox(
                        height: kDefaultPadding * 3,
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Container _mobileView(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
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
                height: kDefaultPadding,
              ),
              Row(
                children: [
                  Text(
                    "Cerca: ",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
                    width: kDefaultPadding,
                  ),
                  SizedBox(
                    width: 200,
                    height: 32,
                    child: Center(
                      child: TextInput(
                        textController: _searchPersonController,
                        label: "",
                        textLength: 2,
                        onTextLength: () {
                          setState(_updateResult);
                        },
                        orElse: () {
                          setState(() {
                            widget.result.clear();
                          });
                        },
                      ),
                    ),
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
                      columnSpacing: kDefaultPadding,
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
                          setState(_updateResult);
                        }, () {
                          widget.controller.togglePersonPaid(
                              widget.result[index].groupIndex,
                              widget.result[index].personIndex);
                          setState(_updateResult);
                        }, () {
                          widget.controller.togglePersonEntrance(
                              widget.result[index].groupIndex,
                              widget.result[index].personIndex);
                          setState(_updateResult);
                        }),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: kDefaultPadding * 3,
                      ),
                      Text(
                        "La ricerca non ha prodotto risultati",
                      ),
                      SizedBox(
                        height: kDefaultPadding * 3,
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
                    width: kDefaultPadding,
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
              width: kDefaultPadding,
            ),
            TableButton(
              onPressed: onEntrance,
              icon: Icons.door_back_door,
              color: Colors.purple,
            ),
            SizedBox(
              width: kDefaultPadding,
            ),
            TableButton(
              onPressed: onDelete,
              icon: Icons.close,
              color: Colors.red,
            ),
          ],
        ),
      ),
    ],
  );
}
