import 'package:admin/screens/products/components/shop_table.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../components/header.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(screenTitle: "Prodotti"),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      ShopTable(
                        shopName: "Carlino",
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      ShopTable(
                        shopName: "Esselunga",
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      ShopTable(
                        shopName: "Haumai",
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      ShopTable(
                        shopName: "Altro",
                      )
                    ],
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
