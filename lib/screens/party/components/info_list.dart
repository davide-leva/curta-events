import 'package:admin/controllers/BankController.dart';
import 'package:admin/controllers/InventoryController.dart';
import 'package:admin/screens/party/components/balance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controllers/Config.dart';
import './info_card.dart';

class Info extends StatelessWidget {
  const Info({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BankController _bankController = Get.put(BankController());

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            children: [
              InfoCard(
                color: Colors.green,
                icon: Icons.euro_rounded,
                title: "Cassa",
                child: Center(
                  child: border(
                    Text(
                      '${_bankController.balance.toStringAsFixed(2)} €',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: kDefaultPadding,
              ),
              InfoCard(
                color: Colors.amber,
                icon: Icons.pallet,
                title: "Scorte",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    border(
                      Text(
                        "${(Get.put(InventoryController())).totalValue.round()} €",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    SizedBox(
                      width: kDefaultPadding,
                    ),
                    border(
                      Text(
                        "${(Get.put(InventoryController())).totalLitres.toStringAsFixed(1)} L",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: kDefaultPadding,
              ),
              InfoCard(
                color: Colors.pink,
                icon: Icons.camera_alt,
                title: 'Instagram',
                child: Center(
                  child: border(
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          Config.get('followers'),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.person,
                          size: 36,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
