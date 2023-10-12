import 'package:admin/controllers/PartiesController.dart';
import 'package:admin/services/updater.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../controllers/Config.dart';
import '../../components/button.dart';

class PartySelector extends StatefulWidget {
  @override
  State<PartySelector> createState() => _PartySelectorState();
}

class _PartySelectorState extends State<PartySelector> {
  PartiesController _partyController = Get.put(PartiesController());

  String _selectedTag = Config.get('selectedParty');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            defaultPadding,
          ),
          color: Theme.of(context).canvasColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Seleziona Festa",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              underline: Container(),
              value: _selectedTag,
              isExpanded: true,
              items: List.generate(
                  _partyController.parties.length,
                  (index) => DropdownMenuItem(
                        value: _partyController.parties[index].tag,
                        child: Text(_partyController.parties[index].title +
                            " (" +
                            DateFormat('MMMM yyyy', 'it')
                                .format(_partyController.parties[index].date) +
                            ")"),
                      )),
              onChanged: (party) {
                setState(() {
                  _selectedTag = party!;
                });
              },
            ),
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(),
              ActionButton(
                title: "Gestisci",
                onPressed: () async {
                  Config.set('selectedParty', _selectedTag);
                  await Updater.refresh();
                },
                icon: Icons.edit,
                color: Colors.green,
              )
            ],
          )
        ],
      ),
    );
  }
}
