import 'package:admin/controllers/BankController.dart';
import 'package:admin/controllers/PartiesController.dart';
import 'package:admin/models/BankTransaction.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/components/badge.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../controllers/Config.dart';
import '../../../models/Party.dart';
import '../../../services/updater.dart';

class TransactionTable extends StatefulWidget {
  @override
  State<TransactionTable> createState() => _TransactionTableState();
}

class _TransactionTableState extends State<TransactionTable> {
  final BankController _controller = Get.put(BankController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  int _yearIndex = 0;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _mobileView(context),
      desktop: _desktopView(context),
    );
  }

  Obx _desktopView(BuildContext context) {
    return Obx(() => Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(defaultPadding),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 150,
                    child: Text(
                      "Movimenti",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  TableButton(
                    isDisabled: _yearIndex == _controller.years.length - 1,
                    color: Colors.lightBlue,
                    icon: Icons.arrow_left,
                    onPressed: () => setState(() => _yearIndex++),
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  InfoBadge(
                    color: Colors.lightBlue,
                    text: "${_controller.years[_yearIndex]}",
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  TableButton(
                    isDisabled: _yearIndex == 0,
                    color: Colors.lightBlue,
                    icon: Icons.arrow_right,
                    onPressed: () => setState(() => _yearIndex--),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 120,
                  ),
                  SizedBox(
                    width: 30,
                    child: TableButton(
                      onPressed: () {
                        showPopUp(
                          context,
                          "Aggiungi movimento",
                          [
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
                                            DateFormat('dd/MM/yy', 'it')
                                                .format(_selectedDate)
                                      }),
                                );
                              },
                              child: TextInput(
                                textController: _dateController,
                                label: "Data",
                                editable: false,
                              ),
                            ),
                            TextInput(
                              textController: _titleController,
                              label: "Titolo",
                            ),
                            TextInput(
                              textController: _descriptionController,
                              label: "Descrizione",
                            ),
                            TextInput(
                              textController: _amountController,
                              label: "Importo",
                            ),
                          ],
                          () => _addBankTransaction(
                            _controller,
                            double.parse(_amountController.text),
                            _selectedDate,
                            _titleController.text,
                            _descriptionController.text,
                          ),
                        );
                      },
                      icon: Icons.add,
                      color: Colors.lightBlue,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: defaultPadding,
              ),
              Container(
                constraints: BoxConstraints(
                  minWidth: double.infinity,
                ),
                child: DataTable(
                  dataRowMinHeight: 80,
                  dataRowMaxHeight: 80,
                  columnSpacing: defaultPadding,
                  columns: [
                    DataColumn(label: Text("Data")),
                    DataColumn(label: Text("Descrizione")),
                    DataColumn(label: Text("Importo"), numeric: true),
                    DataColumn(label: Text("Azioni"), numeric: true),
                  ],
                  rows: List.generate(
                    _controller.transactions
                        .where((element) =>
                            element.date.year == _controller.years[_yearIndex])
                        .length,
                    (index) => _dataRow(
                      context,
                      _controller.transactions
                          .where((element) =>
                              element.date.year ==
                              _controller.years[_yearIndex])
                          .toList()[index],
                      (transaction) {
                        _dateController.text =
                            DateFormat('dd/MM/yyyy').format(transaction.date);
                        _selectedDate = transaction.date;
                        _titleController.text = transaction.title;
                        _descriptionController.text = transaction.description;
                        _amountController.text =
                            transaction.amount.toStringAsFixed(2);

                        showPopUp(
                          context,
                          "Modifica movimento",
                          [
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
                                            DateFormat('dd/MM/yy', 'it')
                                                .format(_selectedDate)
                                      }),
                                );
                              },
                              child: TextInput(
                                textController: _dateController,
                                label: "Data",
                                editable: false,
                              ),
                            ),
                            TextInput(
                              textController: _titleController,
                              label: "Titolo",
                            ),
                            TextInput(
                              textController: _descriptionController,
                              label: "Descrizione",
                            ),
                            TextInput(
                              textController: _amountController,
                              label: "Importo",
                            ),
                          ],
                          () => _modifyBankTransaction(
                            _controller,
                            transaction,
                            double.parse(_amountController.text),
                            _selectedDate,
                            _titleController.text,
                            _descriptionController.text,
                          ),
                        );
                      },
                      (transaction) => _deleteBankTransaction(
                        _controller,
                        transaction,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Obx _mobileView(BuildContext context) {
    return Obx(() => Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(defaultPadding),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 150,
                    child: Text(
                      "Movimenti",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 30,
                    child: TableButton(
                      onPressed: () {
                        showPopUp(
                          context,
                          "Aggiungi movimento",
                          [
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
                                            DateFormat('dd/MM/yy', 'it')
                                                .format(_selectedDate)
                                      }),
                                );
                              },
                              child: TextInput(
                                textController: _dateController,
                                label: "Data",
                                editable: false,
                              ),
                            ),
                            TextInput(
                              textController: _titleController,
                              label: "Titolo",
                            ),
                            TextInput(
                              textController: _descriptionController,
                              label: "Descrizione",
                            ),
                            TextInput(
                              textController: _amountController,
                              label: "Importo",
                            ),
                          ],
                          () => _addBankTransaction(
                            _controller,
                            double.parse(_amountController.text),
                            _selectedDate,
                            _titleController.text,
                            _descriptionController.text,
                          ),
                        );
                      },
                      icon: Icons.add,
                      color: Colors.lightBlue,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: defaultPadding,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TableButton(
                    isDisabled: _yearIndex == _controller.years.length - 1,
                    color: Colors.lightBlue,
                    icon: Icons.arrow_left,
                    onPressed: () => setState(() => _yearIndex++),
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  InfoBadge(
                    color: Colors.lightBlue,
                    text: "${_controller.years[_yearIndex]}",
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  TableButton(
                    isDisabled: _yearIndex == 0,
                    color: Colors.lightBlue,
                    icon: Icons.arrow_right,
                    onPressed: () => setState(() => _yearIndex--),
                  )
                ],
              ),
              SizedBox(
                height: defaultPadding,
              ),
              Container(
                constraints: BoxConstraints(
                  minWidth: double.infinity,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dataRowMinHeight: 80,
                    dataRowMaxHeight: 80,
                    columnSpacing: defaultPadding,
                    columns: [
                      DataColumn(label: Text("Data")),
                      DataColumn(label: Text("Descrizione")),
                      DataColumn(label: Text("Importo"), numeric: true),
                      DataColumn(label: Text("Azioni"), numeric: true),
                    ],
                    rows: List.generate(
                      _controller.transactions
                          .where((element) =>
                              element.date.year ==
                              _controller.years[_yearIndex])
                          .length,
                      (index) => _dataRow(
                        context,
                        _controller.transactions
                            .where((element) =>
                                element.date.year ==
                                _controller.years[_yearIndex])
                            .toList()[index],
                        (transaction) {
                          _dateController.text =
                              DateFormat('dd/MM/yyyy').format(transaction.date);
                          _selectedDate = transaction.date;
                          _titleController.text = transaction.title;
                          _descriptionController.text = transaction.description;
                          _amountController.text =
                              transaction.amount.toStringAsFixed(2);

                          showPopUp(
                            context,
                            "Modifica movimento",
                            [
                              GestureDetector(
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate:
                                        DateTime(DateTime.now().year - 5),
                                    lastDate: DateTime(DateTime.now().year + 5),
                                  ).then(
                                    (value) => setState(() => {
                                          _selectedDate = value!,
                                          _dateController.text =
                                              DateFormat('dd/MM/yy', 'it')
                                                  .format(_selectedDate)
                                        }),
                                  );
                                },
                                child: TextInput(
                                  textController: _dateController,
                                  label: "Data",
                                  editable: false,
                                ),
                              ),
                              TextInput(
                                textController: _titleController,
                                label: "Titolo",
                              ),
                              TextInput(
                                textController: _descriptionController,
                                label: "Descrizione",
                              ),
                              TextInput(
                                textController: _amountController,
                                label: "Importo",
                              ),
                            ],
                            () => _modifyBankTransaction(
                              _controller,
                              transaction,
                              double.parse(_amountController.text),
                              _selectedDate,
                              _titleController.text,
                              _descriptionController.text,
                            ),
                          );
                        },
                        (transaction) => _deleteBankTransaction(
                          _controller,
                          transaction,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

_dataRow(
  BuildContext context,
  BankTransaction transaction,
  void Function(BankTransaction bankTransaction) onModify,
  void Function(BankTransaction bankTransaction) onDelete,
) {
  return DataRow(cells: [
    DataCell(Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: (transaction.amount > 0 ? Colors.green : Colors.red)
                .withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Container(
            child: Icon(
              transaction.amount > 0
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color: transaction.amount > 0 ? Colors.green : Colors.red,
            ),
          ),
        ),
        SizedBox(
          width: defaultPadding,
        ),
        Text(DateFormat('dd/MM/yyyy', 'it').format(transaction.date)),
      ],
    )),
    DataCell(Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction.title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          transaction.description == ""
              ? Container()
              : Container(
                  child: Text(
                    transaction.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
        ],
      ),
    )),
    DataCell(
      Container(
        width: 100,
        child: Text(
          "${transaction.amount > 0 ? "+" : "-"} ${transaction.amount.abs().toStringAsFixed(2)} €",
          textAlign: TextAlign.end,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(
                  color: transaction.amount > 0 ? Colors.green : Colors.red)
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    ),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: transaction.description == "Festa"
          ? [
              TableButton(
                color: Colors.teal,
                icon: Icons.edit_note,
                onPressed: () {
                  PartiesController controller = Get.put(PartiesController());
                  Party party = controller.parties
                      .singleWhere((element) => element.id == transaction.id);

                  Config.set('selectedParty', party.tag);
                },
              )
            ]
          : [
              TableButton(
                color: Colors.lightBlue,
                icon: Icons.edit,
                onPressed: () => onModify(transaction),
              ),
              SizedBox(
                width: defaultPadding,
              ),
              TableButton(
                color: Colors.red,
                icon: Icons.delete,
                onPressed: () => onDelete(transaction),
              )
            ],
    )),
  ]);
}

_addBankTransaction(BankController controller, double amount, DateTime date,
    String title, String description) {
  BankTransaction transaction = BankTransaction(
    id: CloudService.uuid(),
    amount: amount,
    date: date,
    title: title,
    description: description,
  );

  controller.add(transaction);
}

_modifyBankTransaction(BankController controller, BankTransaction transaction,
    double amount, DateTime date, String title, String description) {
  BankTransaction newTransaction = BankTransaction(
    id: transaction.id,
    amount: amount,
    date: date,
    title: title,
    description: description,
  );

  controller.modify(transaction, newTransaction);
}

_deleteBankTransaction(BankController controller, BankTransaction transaction) {
  controller.delete(transaction);
}
