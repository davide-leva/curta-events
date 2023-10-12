import 'dart:math';

import 'package:admin/controllers/Config.dart';
import 'package:admin/controllers/PartiesController.dart';
import 'package:admin/controllers/TransactionController.dart';
import 'package:admin/models/Party.dart';
import 'package:admin/screens/party/components/balance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controllers/GroupsController.dart';

class Preview extends StatelessWidget {
  Preview({
    Key? key,
  }) : super(key: key);

  final GroupsController groupsController = Get.put(GroupsController());
  final TransactionController transactionController =
      Get.put(TransactionController());
  final PartiesController partiesController = Get.put(PartiesController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultPadding),
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
                "Previsione",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: defaultPadding),
          Row(children: [
            Expanded(
              child: Obx(
                () => border(
                  Text(
                    _totalPeople(groupsController).toString() + " persone",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
            ),
          ]),
          Row(children: [
            Expanded(
              child: Obx(
                () => border(
                  Column(
                    children: [
                      Text("Fatturato"),
                      Text(
                        (_totalIncome(transactionController) +
                                    _totalPeople(groupsController) *
                                        _totalPrice(partiesController))
                                .toStringAsFixed(2) +
                            " €",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 32,
                          color: Colors.green,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ]),
          Row(children: [
            Expanded(
              child: Obx(
                () => border(
                  Column(
                    children: [
                      Text("Guadagno"),
                      Text(
                        (_totalIncome(transactionController) +
                                    _totalPeople(groupsController) *
                                        _totalPrice(partiesController) +
                                    _totalOutcome(transactionController))
                                .toStringAsFixed(2) +
                            " €",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 32,
                          color: _totalIncome(transactionController) +
                                      _totalPeople(groupsController) * 15 +
                                      _totalOutcome(transactionController) >
                                  0
                              ? Colors.green
                              : Colors.red,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

_totalPrice(PartiesController partiesController) {
  Party party = partiesController.parties
      .singleWhere((element) => element.tag == Config.get('selectedParty'));

  return party.priceEntrance + party.pricePrevendita;
}

_totalPeople(GroupsController groupController) {
  int total = groupController.groups.fold(0, (sum, groups) {
    return sum + groups.numberOfPeople;
  });

  return total;
}

_totalIncome(TransactionController transactionController) {
  double total = transactionController.transactions.fold(0, (sum, transaction) {
    if (transaction.title == "Prevendite" || transaction.title == "Ingressi")
      return sum;

    return sum + max(0, transaction.amount);
  });

  return total;
}

_totalOutcome(TransactionController transactionController) {
  double total = transactionController.transactions.fold(0, (sum, transaction) {
    return sum + min(0, transaction.amount);
  });

  return total;
}
