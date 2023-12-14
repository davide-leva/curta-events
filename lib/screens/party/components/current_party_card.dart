import 'package:admin/constants.dart';
import 'package:admin/controllers/PartiesController.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:admin/screens/party/components/balance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/Config.dart';
import '../../../models/Party.dart';

class CurrentPartyCard extends StatefulWidget {
  @override
  State<CurrentPartyCard> createState() => _CurrentPartyCardState();
}

class _CurrentPartyCardState extends State<CurrentPartyCard> {
  PartiesController _controller = Get.put(PartiesController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.parties.isEmpty) return Container();

      final TextEditingController _placeController =
          TextEditingController(text: _controller.current.place);
      final TextEditingController _dateController = TextEditingController(
          text: DateFormat('dd/MM/yyyy').format(_controller.current.date));
      final TextEditingController _titleController =
          TextEditingController(text: _controller.current.title);
      final TextEditingController _prevenditaController = TextEditingController(
          text: _controller.current.pricePrevendita.toString());
      final TextEditingController _entranceController = TextEditingController(
          text: _controller.current.priceEntrance.toString());
      DateTime _selectedDatetime = _controller.current.date;

      return Container(
        margin: EdgeInsets.only(bottom: defaultPadding),
        child: Responsive(
          mobile: _mobileView(
            context,
            _controller.current,
            _titleController,
            _placeController,
            _dateController,
            _selectedDatetime,
            _prevenditaController,
            _entranceController,
            _controller,
          ),
          desktop: _desktopView(
            context,
            _controller.current,
            _titleController,
            _placeController,
            _dateController,
            _selectedDatetime,
            _prevenditaController,
            _entranceController,
            _controller,
          ),
        ),
      );
    });
  }

  _desktopView(
    BuildContext context,
    Party current,
    TextEditingController _titleController,
    TextEditingController _placeController,
    TextEditingController _dateController,
    DateTime _selectedDatetime,
    TextEditingController _prevenditaController,
    TextEditingController _entranceController,
    PartiesController _controller,
  ) {
    return border(
      SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              current.title,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              width: defaultPadding * 4,
            ),
            Column(
              children: [
                Text(
                  current.place,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(current.date),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            Spacer(),
            TableButton(
              color: Colors.lightBlue,
              icon: Icons.edit,
              onPressed: () {
                showPopUp(
                  context,
                  "Modica informazioni festa",
                  [
                    TextInput(
                      textController: _titleController,
                      label: "Titolo",
                    ),
                    TextInput(
                      textController: _placeController,
                      label: "Luogo",
                    ),
                    GestureDetector(
                      child: TextInput(
                        textController: _dateController,
                        label: "Data",
                        editable: false,
                      ),
                      onTap: () => showDatePicker(
                        context: context,
                        initialDate: _selectedDatetime,
                        firstDate: DateTime(DateTime.now().year - 5),
                        lastDate: DateTime(DateTime.now().year + 5),
                      ).then(
                        (value) => setState(() {
                          _selectedDatetime = value!;
                          _dateController.text = DateFormat('dd/MM/yyyy')
                              .format(_selectedDatetime);
                        }),
                      ),
                    ),
                    TextInput(
                      textController: _prevenditaController,
                      label: "Prezzo prevendita",
                    ),
                    TextInput(
                      textController: _entranceController,
                      label: "Prezzo entrata",
                    ),
                  ],
                  () => _modifyParty(
                    _controller,
                    current,
                    _titleController.text,
                    _placeController.text,
                    _selectedDatetime,
                    int.parse(_prevenditaController.text),
                    int.parse(_entranceController.text),
                  ),
                  successTitle: "Modifica",
                  successIcon: Icons.edit,
                );
              },
            ),
            SizedBox(
              width: defaultPadding,
            ),
            TableButton(
                color: current.archived ? Colors.green : Colors.amber,
                icon: Icons.archive,
                onPressed: () => _controller.archive(current)),
            SizedBox(
              width: defaultPadding,
            ),
            TableButton(
                color: Colors.lightBlue,
                icon: Icons.print,
                onPressed: () async {
                  Uri url = Uri.parse(
                      'https://docs.google.com/gview?embedded=true&url=${Config.get('dataEndpoint')}${Config.get('selectedParty')}/report/full');

                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.platformDefault);
                  }
                })
          ],
        ),
      ),
    );
  }

  _mobileView(
    BuildContext context,
    Party current,
    TextEditingController _titleController,
    TextEditingController _placeController,
    TextEditingController _dateController,
    DateTime _selectedDatetime,
    TextEditingController _prevenditaController,
    TextEditingController _entranceController,
    PartiesController _controller,
  ) {
    return border(
      SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  current.title,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  width: defaultPadding,
                ),
                Text(
                  current.place,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(current.date),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            Spacer(),
            TableButton(
              color: Colors.lightBlue,
              icon: Icons.edit,
              onPressed: () {
                showPopUp(
                  context,
                  "Modica informazioni festa",
                  [
                    TextInput(
                      textController: _titleController,
                      label: "Titolo",
                    ),
                    TextInput(
                      textController: _placeController,
                      label: "Luogo",
                    ),
                    GestureDetector(
                      child: TextInput(
                        textController: _dateController,
                        label: "Data",
                        editable: false,
                      ),
                      onTap: () => showDatePicker(
                        context: context,
                        initialDate: _selectedDatetime,
                        firstDate: DateTime(DateTime.now().year - 5),
                        lastDate: DateTime(DateTime.now().year + 5),
                      ).then(
                        (value) => setState(() {
                          _selectedDatetime = value!;
                          _dateController.text = DateFormat('dd/MM/yyyy')
                              .format(_selectedDatetime);
                        }),
                      ),
                    ),
                    TextInput(
                      textController: _prevenditaController,
                      label: "Prezzo prevendita",
                    ),
                    TextInput(
                      textController: _entranceController,
                      label: "Prezzo entrata",
                    ),
                  ],
                  () => _modifyParty(
                    _controller,
                    current,
                    _titleController.text,
                    _placeController.text,
                    _selectedDatetime,
                    int.parse(_prevenditaController.text),
                    int.parse(_entranceController.text),
                  ),
                );
              },
            ),
            SizedBox(
              width: defaultPadding,
            ),
            TableButton(
                color: current.archived ? Colors.green : Colors.amber,
                icon: Icons.archive,
                onPressed: () => _controller.archive(current)),
            SizedBox(
              width: defaultPadding,
            ),
            TableButton(
                color: Colors.lightBlue,
                icon: Icons.print,
                onPressed: () async {
                  Uri url = Uri.parse(
                      'https://docs.google.com/gview?embedded=true&url=${Config.get('dataEndpoint')}${Config.get('selectedParty')}/report/full');

                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.platformDefault);
                  }
                })
          ],
        ),
      ),
    );
  }
}

_modifyParty(
  PartiesController controller,
  Party party,
  String title,
  String place,
  DateTime date,
  int pricePrevendita,
  int priceEntrance,
) {
  Party newParty = Party(
    id: party.id,
    tag: party.tag,
    title: title,
    balance: party.balance,
    date: date,
    place: place,
    priceEntrance: priceEntrance,
    pricePrevendita: pricePrevendita,
    archived: party.archived,
  );

  controller.modify(party, newParty);
}
