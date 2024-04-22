import 'package:admin/constants.dart';
import 'package:admin/controllers/Config.dart';
import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:flutter/material.dart';
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

class PreveScanner extends StatelessWidget {
  const PreveScanner({
    Key? key,
    required GroupsController groupController,
    required TextEditingController namePersonController,
  })  : _groupController = groupController,
        _namePersonController = namePersonController,
        super(key: key);

  final GroupsController _groupController;
  final TextEditingController _namePersonController;

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
        SearchEntry? search = _groupController.searchBarcode(capture);

        Navigator.pop(context);

        if (search == null) {
          if (Config.get('userLevel') == 'pr') {
            showPopUp(
              context,
              "Aggiungi persona",
              [
                Text(capture.barcodes[0].rawValue ?? ""),
                TextInput(textController: _namePersonController, label: "Nome"),
              ],
              () {
                _groupController.addPerson(
                  _groupController.groups.indexed
                      .firstWhere(
                          (pair) => pair.obj.title == Config.get('operator'))
                      .index,
                  _namePersonController.text,
                  code: int.parse(
                    capture.barcodes[0].rawValue ?? "0",
                  ),
                  payed: true,
                );
              },
            );
          }
        }
      },
    );
  }
}
