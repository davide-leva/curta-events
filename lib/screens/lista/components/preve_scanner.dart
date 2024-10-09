import 'package:admin/constants.dart';
import 'package:admin/controllers/Config.dart';
import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:admin/utils.dart';

class PreveScanner extends StatelessWidget {
  const PreveScanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GroupsController _groupsController = Get.put(GroupsController());
    final TextEditingController _namePersonController = TextEditingController();

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
              if (Config.get('userLevel') == 'pr') {
                showPopUp(
                  context,
                  "Aggiungi persona",
                  [
                    Text(capture.barcodes[0].rawValue ?? ""),
                    TextInput(
                        textController: _namePersonController, label: "Nome"),
                  ],
                  () {
                    _groupsController.addPerson(
                      _groupsController.groups.indexed
                          .firstWhere((pair) =>
                              pair.obj.title == Config.get('operator'))
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
    );
  }
}
