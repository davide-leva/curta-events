import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/models/Group.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controllers/TransactionController.dart';
import '../../../models/Person.dart';
import '../../../models/Transaction.dart';
import '../../components/badge.dart';
import '../../components/action_button.dart';

class GroupTable extends StatefulWidget {
  GroupTable({
    Key? key,
    required this.group,
    required this.groupIndex,
    required this.controller,
  }) : super(key: key);

  final ListaGroup group;
  final int groupIndex;
  final GroupsController controller;

  @override
  State<GroupTable> createState() => _GroupTableState();
}

class _GroupTableState extends State<GroupTable> {
  final TransactionController transactionController =
      Get.put(TransactionController());

  final TextEditingController _namePersonController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _mobileView(context),
      desktop: _desktopView(context),
    );
  }

  Container _desktopView(BuildContext context) {
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
              ActionButton(
                title: "Aggiungi",
                onPressed: () {
                  showPopUp(
                    context,
                    "Aggiungi persona",
                    [
                      TextInput(
                          textController: _namePersonController, label: "Nome")
                    ],
                    () async {
                      await widget.controller.addPerson(
                          widget.groupIndex, _namePersonController.text);
                      _updateTransaction(
                          widget.controller, transactionController);
                    },
                  );
                },
                icon: Icons.person_add_alt_1,
                color: Colors.lightBlue,
              ),
              SizedBox(
                width: kDefaultPadding,
              ),
              ActionButton(
                title: "Elimina",
                onPressed: () {
                  widget.controller.delete(widget.group);
                },
                icon: Icons.close,
                color: Colors.red,
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable2(
              columnSpacing: 0,
              columns: [
                DataColumn(
                  label: Text("Nome"),
                ),
                DataColumn(
                  label: Text("Stato prenotazione"),
                ),
                DataColumn(
                  label: Text("Azioni"),
                ),
              ],
              rows: List.generate(
                widget.group.numberOfPeople,
                (index) => _dataRow(context, widget.group.people[index], () {
                  setState(() {
                    widget.controller.removePerson(widget.groupIndex, index);
                  });
                }, () {
                  setState(() {
                    widget.controller
                        .togglePersonPaid(widget.groupIndex, index);
                  });
                }, () {
                  setState(() {
                    widget.controller
                        .togglePersonEntrance(widget.groupIndex, index);
                  });
                }, () {
                  _discountController.text =
                      "${widget.group.people[index].discount}";
                  showPopUp(context,
                      "Sconto per ${widget.group.people[index].name}", [
                    TextInput(
                      textController: _discountController,
                      label: "Sconto",
                    )
                  ], () {
                    widget.controller.modifyPersonDiscount(
                        widget.groupIndex,
                        index,
                        double.parse(_discountController.text.isEmpty
                            ? "0.00"
                            : _discountController.text));
                  });
                }, (code) {
                  widget.controller
                      .modifyPersonCode(widget.groupIndex, index, code);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _mobileView(BuildContext context) {
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
              TableButton(
                onPressed: () {
                  showPopUp(
                    context,
                    "Aggiungi persona",
                    [
                      TextInput(
                          textController: _namePersonController, label: "Nome")
                    ],
                    () async {
                      await widget.controller.addPerson(
                          widget.groupIndex, _namePersonController.text);
                      _updateTransaction(
                          widget.controller, transactionController);
                    },
                  );
                },
                icon: Icons.person_add_alt_1,
                color: Colors.lightBlue,
              ),
              SizedBox(
                width: kDefaultPadding,
              ),
              TableButton(
                onPressed: () {
                  widget.controller.delete(widget.group);
                },
                icon: Icons.close,
                color: Colors.red,
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: kDefaultPadding,
              columns: [
                DataColumn(
                  label: Text("Nome"),
                ),
                DataColumn(
                  label: Text("Stato prenotazione"),
                ),
                DataColumn(
                  label: Text("Azioni"),
                ),
              ],
              rows: List.generate(
                widget.group.numberOfPeople,
                (index) => _dataRow(context, widget.group.people[index], () {
                  setState(() {
                    widget.controller.removePerson(widget.groupIndex, index);
                  });
                }, () {
                  setState(() {
                    widget.controller
                        .togglePersonPaid(widget.groupIndex, index);
                  });
                }, () {
                  setState(() {
                    widget.controller
                        .togglePersonEntrance(widget.groupIndex, index);
                  });
                }, () {
                  _discountController.text =
                      "${widget.group.people[index].discount}";
                  showPopUp(context,
                      "Sconto per ${widget.group.people[index].name}", [
                    TextInput(
                      textController: _discountController,
                      label: "Sconto",
                    )
                  ], () {
                    widget.controller.modifyPersonDiscount(
                        widget.groupIndex,
                        index,
                        double.parse(_discountController.text.isEmpty
                            ? "0.00"
                            : _discountController.text));
                  });
                }, (code) {
                  widget.controller
                      .modifyPersonCode(widget.groupIndex, index, code);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow _dataRow(
    BuildContext context,
    Person person,
    Function() onDelete,
    Function() onConfirm,
    Function() onEntrance,
    Function() onDiscount,
    Function(int code) onCode) {
  return DataRow(
    cells: [
      DataCell(
        GestureDetector(
          onTap: () {
            TextEditingController _codeController = TextEditingController();
            if (person.code == 0) {
              showPopUp(
                context,
                "Associa prevendita",
                [
                  TextInput(textController: _codeController, label: "Codice"),
                ],
                () => onCode(int.parse(_codeController.text)),
              );
            }
          },
          child: InfoBadge(
            text: person.name,
            color: person.hasPaid
                ? Colors.green
                : person.code == 0
                    ? Colors.grey
                    : Colors.lightBlue,
          ),
        ),
      ),
      DataCell(
        Row(
          children: [
            person.hasEntered
                ? TableButton(
                    color: Colors.purple,
                    icon: Icons.door_back_door,
                    onPressed: () {})
                : Container(),
            person.hasEntered
                ? SizedBox(
                    width: kDefaultPadding,
                  )
                : Container(),
            person.discount != 0.00
                ? InfoBadge(
                    color: Colors.amber.shade800,
                    text: "- ${person.discount.toInt()} €",
                  )
                : Container(),
            person.discount != 0.00
                ? SizedBox(
                    width: kDefaultPadding,
                  )
                : Container(),
            person.hasPaid
                ? InfoBadge(
                    color: Colors.green,
                    text: "Pagato",
                  )
                : InfoBadge(
                    color: Colors.red,
                    text: "Non pagato",
                  )
          ],
        ),
      ),
      DataCell(
        Row(
          children: [
            Container(
                child: TableButton(
              onPressed: onConfirm,
              icon: Icons.euro,
              color: Colors.green,
            )),
            SizedBox(
              width: kDefaultPadding,
            ),
            TableButton(
              onPressed: onEntrance,
              icon: Icons.door_back_door,
              color: Colors.purple,
            ),
            SizedBox(
              width: kDefaultPadding,
            ),
            TableButton(
              color: Colors.amber.shade800,
              icon: Icons.discount,
              onPressed: onDiscount,
            ),
            SizedBox(
              width: kDefaultPadding,
            ),
            TableButton(
              onPressed: onDelete,
              icon: Icons.close,
              color: Colors.red,
            ),
          ],
        ),
      ),
    ],
  );
}

_updateTransaction(GroupsController groupController,
    TransactionController transactionController) {
  Transaction transaction = transactionController.transactions.singleWhere(
    (transaction) => transaction.title == "Prevendite",
    orElse: () => Transaction(
      id: CloudService.uuid(),
      title: "Prevendite",
      amount: 0.0,
      description: "",
    ),
  );

  double prevendite = 0;
  for (var group in groupController.groups) {
    double count = 0;

    for (var person in group.people) {
      if (person.hasPaid) count++;
    }

    prevendite += count;
  }

  Transaction newTransaction = Transaction(
    id: transaction.id,
    title: "Prevendite",
    amount: prevendite * 15.0,
    description: "",
  );
  transactionController.modify(transaction, newTransaction);
}
