import 'package:admin/controllers/BankController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../party/components/balance.dart';

class BankSummary extends StatelessWidget {
  final BankController _bankController = Get.put(BankController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: EdgeInsets.all(kDefaultPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(kDefaultPadding),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Riepiloghi annuali",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ...List.generate(
                _bankController.years.length,
                (index) => border(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Anno ${_bankController.years[index]}"),
                      Text(
                        "+ ${_bankController.getCreditYear(_bankController.years[index]).abs().toStringAsFixed(2)} €",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.green)
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "- ${_bankController.getDebitYear(_bankController.years[index]).abs().toStringAsFixed(2)} €",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.red)
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
