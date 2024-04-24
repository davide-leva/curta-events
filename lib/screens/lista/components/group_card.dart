import 'package:admin/constants.dart';
import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/models/Group.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/components/action_button.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:admin/screens/lista/components/person_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

class GroupCard extends StatefulWidget {
  const GroupCard({
    Key? key,
    required this.group,
    required this.gid,
  }) : super(key: key);

  final ListaGroup group;
  final int gid;

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    final GroupsController _groupsController = Get.put(GroupsController());

    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Gruppo ${widget.group.title}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Spacer(),
              SizedBox(
                width: kDefaultPadding,
              ),
              Responsive.isDesktop(context)
                  ? ActionButton(
                      title: "Aggiungi",
                      onPressed: () {
                        TextEditingController _nameController =
                            TextEditingController();

                        showPopUp(
                          context,
                          "Aggiungi persona",
                          [
                            TextInput(
                                textController: _nameController, label: "Nome")
                          ],
                          () => _groupsController.addPerson(
                              widget.gid, _nameController.text),
                        );
                      },
                      icon: Icons.person_add_alt_1,
                      color: Colors.lightBlue,
                    )
                  : TableButton(
                      color: Colors.lightBlue,
                      icon: Icons.add,
                      onPressed: () {
                        TextEditingController _nameController =
                            TextEditingController();

                        showPopUp(
                          context,
                          "Aggiungi persona",
                          [
                            TextInput(
                                textController: _nameController, label: "Nome")
                          ],
                          () => _groupsController.addPerson(
                              widget.gid, _nameController.text),
                        );
                      },
                    ),
              SizedBox(
                width: kDefaultPadding,
              ),
              Responsive.isDesktop(context)
                  ? ActionButton(
                      title: "Elimina",
                      onPressed: () => showPopUp(
                        context,
                        "Conferma",
                        [
                          Text("Sei sicuro di voler eliminare il gruppo?"),
                        ],
                        () => _groupsController.delete(widget.group),
                      ),
                      icon: Icons.close,
                      color: Colors.red,
                    )
                  : TableButton(
                      color: Colors.red,
                      icon: Icons.delete,
                      onPressed: () => showPopUp(
                        context,
                        "Conferma",
                        [
                          Text("Sei sicuro di voler eliminare il gruppo?"),
                        ],
                        () => _groupsController.delete(widget.group),
                      ),
                    ),
              SizedBox(
                width: 2 * kDefaultPadding,
              ),
              GestureDetector(
                onTap: () => setState(() {
                  _isOpen = !_isOpen;
                }),
                child: Icon(Icons.menu),
              )
            ],
          ),
          _isOpen
              ? SizedBox(
                  height: kDefaultPadding,
                )
              : Container(),
          _isOpen
              ? SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: kDefaultPadding,
                      runSpacing: kDefaultPadding,
                      children: widget.group.people.indexed
                          .map((pair) => PersonCard(
                              person: pair.obj,
                              id: PersonID(widget.gid, pair.index)))
                          .toList(),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
