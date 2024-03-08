import 'dart:math';

import 'package:admin/controllers/Config.dart';
import 'package:admin/controllers/PartiesController.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../config/components/color_picker.dart';

class Chart extends StatelessWidget {
  Chart({
    Key? key,
  }) : super(key: key);

  final PartiesController partyController = Get.put(PartiesController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Obx(
            () => PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 70,
                startDegreeOffset: -90,
                sections: List.generate(
                  min(min(int.parse(Config.get('visibleParties')), 9),
                      partyController.parties.length),
                  (index) => PieChartSectionData(
                      color: Config.get('colors')
                          .split(', ')
                          .map((hex) => HexColor.fromHex(hex))
                          .toList()[(index * 3 + 3) % 14],
                      value: max(
                          partyController.parties[index].balance /
                              partyController.totalIncome,
                          0),
                      showTitle: false,
                      radius:
                          35 - (15 / partyController.parties.length) * index),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: kDefaultPadding),
                Obx(
                  () => Text(
                    partyController.totalIncome.toStringAsFixed(0) + " €",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
