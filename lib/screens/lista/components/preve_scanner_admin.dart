import 'package:admin/constants.dart';
import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/models/Group.dart';
import 'package:admin/models/Person.dart';
import 'package:admin/screens/components/action_button.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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

class AdminPreveScanner extends StatelessWidget {
  const AdminPreveScanner({
    Key? key,
    required this.groupsController,
    required this.namePersonController,
    required this.selectedGroup,
    required this.onGroup,
  }) : super(key: key);

  final GroupsController groupsController;
  final TextEditingController namePersonController;
  final int selectedGroup;
  final Function(int) onGroup;

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      overlay: Column(
        children: [
          SizedBox(
            height: kDefaultPadding * 2,
          ),
          Container(
            padding: EdgeInsets.all(kDefaultPadding),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(kDefaultPadding),
            ),
            child: Text(
              "Scansiona prevendita",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
      onDetect: (capture) {
        SearchEntry? search = groupsController.searchBarcode(capture);

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
                        Text(capture.barcodes[0].rawValue ?? ""),
                      ],
                    ),
                  )
                ],
              ),
              TextInput(textController: namePersonController, label: "Nome"),
              Container(
                width: 300,
                padding: EdgeInsets.only(left: kDefaultPadding),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownMenu<int>(
                  initialSelection: selectedGroup,
                  width: 240,
                  hintText: "Lista",
                  menuHeight: 300,
                  inputDecorationTheme: InputDecorationTheme(
                    border: InputBorder.none,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  dropdownMenuEntries: groupsController.groups.indexed
                      .map<DropdownMenuEntry<int>>(
                        (pair) => DropdownMenuEntry<int>(
                          value: pair.index,
                          label: pair.obj.title,
                        ),
                      )
                      .toList(),
                  onSelected: (value) => onGroup(value!),
                ),
              )
            ],
            () {
              groupsController.addPerson(
                selectedGroup,
                namePersonController.text,
                code: int.parse(
                  capture.barcodes[0].rawValue ?? "0",
                ),
                payed: true,
              );
            },
          );
        } else {
          ListaGroup group = groupsController.groups[search.groupIndex];
          Person person = group.people[search.personIndex];

          showPopUp(
            context,
            "Prevendita",
            [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    color: person.hasEntered ? Colors.purple : Colors.green,
                    size: 60,
                  ),
                  SizedBox(
                    height: kDefaultFontSize,
                  ),
                  SizedBox(
                    height: kDefaultFontSize,
                  ),
                  Text("${person.name} - ${group.title}"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.payment),
                        SizedBox(
                          width: kDefaultPadding,
                        ),
                        Text(capture.barcodes[0].rawValue ?? ""),
                      ],
                    ),
                  ),
                ],
              )
            ],
            () {
              if (!person.hasPaid)
                groupsController.togglePersonPaid(
                    search.groupIndex, search.personIndex);
              if (!person.hasEntered)
                groupsController.togglePersonEntrance(
                    search.groupIndex, search.personIndex);
            },
            successIcon: Icons.download,
            successColor: Colors.lightBlue,
          );
        }
      },
    );
  }
}
