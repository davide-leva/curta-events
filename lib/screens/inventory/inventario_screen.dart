import 'package:admin/screens/inventory/components/inventario_table.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../components/header.dart';

class InventarioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            Header(screenTitle: "Inventario"),
            SizedBox(height: kDefaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [InventarioTable()],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
