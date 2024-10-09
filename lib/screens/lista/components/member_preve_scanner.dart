import 'package:admin/constants.dart';
import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/models/Person.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:admin/screens/lista/components/person_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:admin/utils.dart';

class MemberPreveScanner extends StatefulWidget {
  const MemberPreveScanner({Key? key}) : super(key: key);

  @override
  State<MemberPreveScanner> createState() => _MemberPreveScannerState();
}

class _MemberPreveScannerState extends State<MemberPreveScanner> {
  @override
  Widget build(BuildContext context) {
    GroupsController _groupsController = Get.put(GroupsController());
    TextEditingController _namePersonController = TextEditingController();
    int _selectedGroup = 0;

    return TableButton(
      color: Colors.lightBlue,
      icon: Icons.qr_code,
      onPressed: () => showDialog(
        context: context,
        builder: (context) => MobileScanner(
          overlayBuilder: (context, size) => Column(
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
            SearchEntry? search = _groupsController.searchBarcode(capture);

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
                  TextInput(
                      textController: _namePersonController, label: "Nome"),
                  Container(
                    width: 300,
                    padding: EdgeInsets.only(left: kDefaultPadding),
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
                      dropdownMenuEntries: _groupsController.groups.indexed
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
                  _groupsController.addPerson(
                    _selectedGroup,
                    _namePersonController.text,
                    code: int.parse(
                      capture.barcodes[0].rawValue ?? "0",
                    ),
                  );
                },
              );
            } else {
              Person person = _groupsController
                  .groups[search.groupIndex].people[search.personIndex];

              showPopUp(
                context,
                "Prevendita",
                [
                  PersonCard(
                    person: person,
                    id: PersonID(
                      search.groupIndex,
                      search.personIndex,
                    ),
                  ),
                ],
                () async {
                  if (!person.hasPaid)
                    await _groupsController.togglePersonPaid(
                        search.groupIndex, search.personIndex);
                  if (!person.hasEntered)
                    await _groupsController.togglePersonEntrance(
                        search.groupIndex, search.personIndex);
                },
                successColor: Colors.lightBlue,
                successIcon: Icons.download,
              );
            }
          },
        ),
      ),
    );
  }
}
