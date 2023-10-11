import 'dart:math';

import 'package:admin/controllers/Config.dart';
import 'package:admin/controllers/PartiesController.dart';
import 'package:admin/screens/config/components/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'party_card.dart';

class PartyDetails extends StatelessWidget {
  PartyDetails({
    Key? key,
  }) : super(key: key);

  final PartiesController partyController = Get.put(PartiesController());
  final Config config = Get.put(Config());

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
          Text(
            "Elenco feste",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          Obx(
            () => Column(
              children: List.generate(
                min(min(int.parse(Config.get('visibleParties')), 9),
                    partyController.parties.length),
                (index) => PartyCard(
                  tag: partyController.parties[index].tag,
                  title: partyController.parties[index].title,
                  date: partyController.parties[index].date,
                  income: partyController.parties[index].balance,
                  color: Config.get('colors')
                      .split(', ')
                      .map((hex) => HexColor.fromHex(hex))
                      .toList()[(index * 3 + 3) % 14],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
