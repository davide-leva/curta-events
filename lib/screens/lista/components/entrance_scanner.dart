import 'package:admin/constants.dart';
import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/screens/lista/components/person_card.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class EntranceScanner extends StatelessWidget {
  final GroupsController _groupsController = Get.put(GroupsController());

  @override
  Widget build(BuildContext context) {
    return TableButton(
      color: Colors.lightBlue,
      icon: Icons.barcode_reader,
      onPressed: () {
        PersonID? _person;
        return showDialog(
          context: context,
          builder: (context) => StatefulBuilder(builder: (context, setState) {
            return Scaffold(
              body: MobileScanner(
                overlay: Column(
                  children: [
                    SizedBox(
                      height: kDefaultPadding,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(kDefaultPadding),
                          decoration: BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius:
                                BorderRadius.circular(kDefaultPadding),
                          ),
                          child: Text(
                            "Modalità scanner",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    _person != null
                        ? Obx(() => PersonCard(
                            person: _groupsController
                                .groups[_person!.gid].people[_person!.pid],
                            id: _person!))
                        : Container(),
                    SizedBox(
                      height: kDefaultPadding,
                    )
                  ],
                ),
                onDetect: (capture) {
                  SearchEntry? entry = _groupsController.searchBarcode(capture);

                  if (entry != null) {
                    PersonID person =
                        PersonID(entry.groupIndex, entry.personIndex);

                    if (person != _person) {
                      setState(() => _person = person);
                      _groupsController.togglePersonEntrance(
                          person.gid, person.pid);
                      AudioPlayer player = new AudioPlayer();
                      player.play(AssetSource("sounds/scan.mp3"));
                    }
                  }
                },
              ),
            );
          }),
        );
      },
    );
  }
}
