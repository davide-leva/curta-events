import 'package:admin/services/sync_service.dart';
import 'package:admin/services/updater.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../constants.dart';
import '../../../controllers/PartiesController.dart';
import '../../../models/Party.dart';
import '../../../services/cloud_service.dart';
import '../../components/action_button.dart';
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
  final TextEditingController _prevenditaController = TextEditingController();
  final TextEditingController _entranceController = TextEditingController();

  final PartiesController _partyController = Get.put(PartiesController());

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
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
            height: kDefaultPadding,
          ),
          TextInput(
            textController: _nameController,
            label: "Nome festa",
          ),
          SizedBox(
            height: kDefaultPadding,
          ),
          TextInput(
            textController: _placeController,
            label: "Luogo",
          ),
          SizedBox(
            height: kDefaultPadding,
          ),
          TextInput(
            textController: _prevenditaController,
            label: "Prezzo prevendita",
          ),
          SizedBox(
            height: kDefaultPadding,
          ),
          TextInput(
            textController: _prevenditaController,
            label: "Prezzo entrata",
          ),
          SizedBox(
            height: kDefaultPadding,
          ),
          TextInput(
            textController: _tagController,
            label: "Tag database",
          ),
          SizedBox(
            height: kDefaultPadding,
          ),
          GestureDetector(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().year - 5),
                lastDate: DateTime(DateTime.now().year + 5),
              ).then(
                (value) => setState(() {
                      _selectedDate = value!;
                      _dateController.text =
                          DateFormat('yyyy/MM/dd', 'it').format(_selectedDate);
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
            height: kDefaultPadding,
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
                    int.parse(_prevenditaController.text),
                    int.parse(_entranceController.text),
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

_addParty(
  String name,
  String tag,
  String place,
  DateTime date,
  PartiesController controller,
  int pricePrevendita,
  int priceEntrance,
) async {
  Party party = Party(
    id: CloudService.uuid(),
    tag: tag,
    title: name,
    balance: 0,
    date: date,
    place: place,
    priceEntrance: priceEntrance,
    pricePrevendita: pricePrevendita,
    archived: false,
  );

  await controller.add(party);
}
