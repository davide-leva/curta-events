import 'package:admin/controllers/ProductsController.dart';
import 'package:admin/controllers/ShopController.dart';
import 'package:admin/controllers/TransactionController.dart';
import 'package:admin/models/Transaction.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/screens/party/components/price_card.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../components/text_input.dart';

class Balance extends StatelessWidget {
  Balance({
    Key? key,
  }) : super(key: key);

  final ShopController shopController = Get.put(ShopController());
  final ProductController productController = Get.put(ProductController());
  final TransactionController transactionController =
      Get.put(TransactionController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descController = TextEditingController();

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
          Row(
            children: [
              Text(
                "Bilancio della festa",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              TableButton(
                  color: Colors.lightBlue,
                  icon: Icons.add,
                  onPressed: () {
                    showPopUp(context, "Aggiungi transazione", [
                      TextInput(
                        label: "Transazione",
                        textController: nameController,
                      ),
                      TextInput(
                        label: "Prezzo",
                        textController: amountController,
                      ),
                      TextInput(
                        label: "Descrizione",
                        textController: descController,
                      )
                    ], () {
                      _addNewTransaction(
                          nameController.text,
                          amountController.text,
                          descController.text,
                          transactionController);
                    });
                  })
            ],
          ),
          SizedBox(height: defaultPadding),
          Row(children: [
            Expanded(
              child: Obx(
                () => border(
                  Text(
                    transactionController.balance.toStringAsFixed(2) + " €",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 32,
                      color: transactionController.balance > 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ]),
          Obx(
            () => Column(
              children: List.generate(
                  transactionController.transactions
                      .where((transaction) => transaction.amount != 0)
                      .length, (index) {
                List<Transaction> transactions = transactionController
                    .transactions
                    .where((transaction) => transaction.amount != 0)
                    .toList();
                transactions
                    .sort((a, b) => _floorAbs(b.amount) - _floorAbs(a.amount));
                transactions.sort(
                    (a, b) => (a.amount > 0 ? 0 : 1) - (b.amount > 0 ? 0 : 1));
                return PriceCard(
                  title: transactions[index].title,
                  amount: transactions[index].amount,
                  description: transactions[index].description,
                  onDelete: () =>
                      transactionController.delete(transactions[index]),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}

int _floorAbs(num x) {
  if (x > 0)
    return x.toInt();
  else
    return -x.toInt();
}

_addNewTransaction(
    String name, String amount, String desc, TransactionController controller) {
  Transaction transaction = Transaction(
      id: CloudService.uuid(),
      title: name,
      description: desc,
      amount: double.parse(amount));

  controller.add(transaction);
}

border(Widget child) {
  return Container(
      margin: EdgeInsets.only(top: defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: kPrimaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: child);
}
