import 'package:admin/constants.dart';
import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/models/Person.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/components/badge.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonID {
  PersonID(
    this.gid,
    this.pid,
  );

  final int gid;
  final int pid;

  @override
  bool operator ==(Object other) {
    if (other is PersonID) {
      return gid == other.gid && pid == other.pid;
    } else {
      return false;
    }
  }
}

class PersonCard extends StatefulWidget {
  PersonCard({
    Key? key,
    required this.person,
    required this.id,
    this.color = kCardColor,
    this.showAction = false,
    this.enableAction = true,
  }) : super(key: key);

  final Person person;
  final PersonID id;
  final Color color;
  bool showAction;
  bool enableAction;

  @override
  State<PersonCard> createState() => _PersonCardState();
}

class _PersonCardState extends State<PersonCard> {
  final GroupsController _groupsController = Get.put(GroupsController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enableAction
          ? () => setState(() {
                widget.showAction = !widget.showAction;
              })
          : null,
      child: Container(
        padding: EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(kDefaultPadding),
        ),
        width: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.person,
                    color: _getColorState(widget.person),
                    size: Responsive.isDesktop(context) ? 56 : 40,
                  ),
                ),
                SizedBox(
                  width: kDefaultPadding,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.person.name),
                      widget.person.discount + widget.person.code > 0
                          ? SizedBox(
                              height: 8,
                            )
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.person.discount != 0
                              ? InfoBadge(
                                  color: Colors.orange,
                                  text: "${-widget.person.discount} €")
                              : Container(),
                          widget.person.discount != 0 && widget.person.code != 0
                              ? SizedBox(
                                  width: kDefaultPadding,
                                )
                              : Container(),
                          widget.person.code != 0
                              ? InfoBadge(
                                  color: Colors.lightBlue,
                                  text: "${widget.person.code}")
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            widget.showAction
                ? SizedBox(
                    height: kDefaultPadding,
                  )
                : Container(),
            widget.showAction
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TableButton(
                        color: Colors.transparent,
                        icon: Icons.euro,
                        onPressed: () => _groupsController.togglePersonPaid(
                          widget.id.gid,
                          widget.id.pid,
                        ),
                      ),
                      TableButton(
                        color: Colors.transparent,
                        icon: Icons.door_back_door,
                        onPressed: () => _groupsController.togglePersonEntrance(
                          widget.id.gid,
                          widget.id.pid,
                        ),
                      ),
                      TableButton(
                        color: Colors.transparent,
                        icon: Icons.discount,
                        onPressed: () {
                          TextEditingController _discountController =
                              TextEditingController(
                            text: "${widget.person.discount}",
                          );

                          showPopUp(
                            context,
                            "Modifica sconto",
                            [
                              TextInput(
                                  textController: _discountController,
                                  label: "Sconto")
                            ],
                            () => _groupsController.modifyPersonDiscount(
                              widget.id.gid,
                              widget.id.pid,
                              double.parse(_discountController.text),
                            ),
                          );
                        },
                      ),
                      TableButton(
                        color: Colors.transparent,
                        icon: Icons.delete,
                        onPressed: () => _groupsController.removePerson(
                          widget.id.gid,
                          widget.id.pid,
                        ),
                      ),
                      TableButton(
                        color: Colors.transparent,
                        icon: Icons.edit,
                        onPressed: () {
                          TextEditingController _nameController =
                              TextEditingController(text: widget.person.name);

                          showPopUp(
                            context,
                            "Modifica persona",
                            [
                              TextInput(
                                textController: _nameController,
                                label: "Nome",
                              ),
                            ],
                            () => _groupsController.modifyPersonName(
                              widget.id.gid,
                              widget.id.pid,
                              _nameController.text,
                            ),
                          );
                        },
                      )
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

Color _getColorState(Person person) {
  return person.hasEntered
      ? Colors.lightBlue
      : person.hasPaid
          ? Colors.green
          : Colors.red;
}
