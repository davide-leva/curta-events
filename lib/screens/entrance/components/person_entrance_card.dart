import 'package:admin/constants.dart';
import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/models/Person.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/components/badge.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/screens/lista/components/person_card.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/utils.dart';

class PersonEntranceCard extends StatefulWidget {
  PersonEntranceCard({
    Key? key,
    required this.person,
    required this.id,
    this.isSelected = false,
  }) : super(key: key);

  final Person person;
  final PersonID id;
  final bool isSelected;

  @override
  State<PersonEntranceCard> createState() => _PersonEntranceCardState();
}

extension Extreme<T> on List<T> {
  List<T> get extreme => [this.first, this.last];
}

class _PersonEntranceCardState extends State<PersonEntranceCard> {
  final _groupsController = Get.put(GroupsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        border: Border.all(
            color: !widget.isSelected &&
                    _groupsController.getSelectedPerson.length >= 3
                ? Colors.red
                : Colors.transparent),
        color: kCardColor,
        borderRadius: BorderRadius.circular(kDefaultPadding),
      ),
      width: 172,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    _groupsController.togglePersonSelected(
                        widget.id.gid, widget.id.pid);
                    AudioPlayer player = new AudioPlayer();
                    player.play(AssetSource("sounds/scan.mp3"));
                  },
                  child: Icon(
                    Icons.person,
                    color: _getColorState(widget.person),
                    size: Responsive.isDesktop(context) ? 50 : 40,
                  ),
                ),
              ),
              SizedBox(
                width: kDefaultPadding,
              ),
              Expanded(
                flex: 3,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: widget.person.name
                        .split(" ")
                        .extreme
                        .map((word) => Text(word))
                        .toList()),
              ),
            ],
          ),
          widget.isSelected
              ? SizedBox(
                  height: 8,
                )
              : Container(),
          widget.isSelected
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TableButton(
                      color: Colors.transparent,
                      icon: Icons.arrow_downward,
                      onPressed: () => _groupsController.togglePersonSelected(
                          widget.id.gid, widget.id.pid),
                    ),
                    InfoBadge(
                        color: Colors.amber,
                        text: "${widget.person.discount} €"),
                    TableButton(
                      color: Colors.transparent,
                      icon: Icons.euro,
                      onPressed: () {
                        _groupsController.togglePersonEntrance(
                            widget.id.gid, widget.id.pid);
                      },
                    ),
                  ],
                )
              : Container()
        ],
      ),
    );
  }
}

Color _getColorState(Person person) {
  return person.isSelected ? Colors.green : Colors.lightBlue;
}
