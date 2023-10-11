import 'package:admin/services/sync_service.dart';
import 'package:admin/services/updater.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../constants.dart';
import '../../../controllers/PartiesController.dart';
import '../../../models/Party.dart';
import '../../../services/cloud_service.dart';
import '../../components/button.dart';
import '../../components/text_input.dart';

class PartyAdder extends StatefulWidget {
  const PartyAdder({Key? key}) : super(key: key);

  @override
  State<PartyAdder> createState() => _PartyAdderState();
}

class _PartyAdderState extends State<PartyAdder> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();

  final PartiesController _partyController = Get.put(PartiesController());

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Aggiungi festa",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(
            height: defaultPadding,
          ),
          TextInput(
            textController: _nameController,
            label: "Nome festa",
          ),
          SizedBox(
            height: defaultPadding,
          ),
          TextInput(
            textController: _placeController,
            label: "Luogo",
          ),
          SizedBox(
            height: defaultPadding,
          ),
          TextInput(textController: _tagController, label: "Tag database"),
          SizedBox(
            height: defaultPadding,
          ),
          GestureDetector(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().year - 5),
                lastDate: DateTime(DateTime.now().year + 5),
              ).then(
                (value) => setState(() => {
                      _selectedDate = value!,
                      _dateController.text =
                          DateFormat('yyyy/MM/dd', 'it').format(_selectedDate)
                    }),
              );
            },
            child: TextInput(
              textController: _dateController,
              label: "Data",
              editable: false,
            ),
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ActionButton(
                title: "Aggiungi",
                onPressed: () async {
                  await _addParty(
                    _nameController.text,
                    _tagController.text,
                    _placeController.text,
                    _selectedDate,
                    _partyController,
                  );

                  Updater.update(Collection.parties);
                },
                icon: Icons.add,
                color: Colors.green,
              )
            ],
          ),
        ],
      ),
    );
  }
}

_addParty(String name, String tag, String place, DateTime date,
    PartiesController controller) async {
  Party party = Party(
    id: CloudService.uuid(),
    tag: tag,
    title: name,
    balance: 0,
    date: date,
    place: place,
  );

  await controller.add(party);
}
