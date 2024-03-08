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
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            Header(screenTitle: "Prodotti"),
            SizedBox(height: kDefaultPadding),
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
                        height: kDefaultPadding,
                      ),
                      ShopTable(
                        shopName: "Esselunga",
                      ),
                      SizedBox(
                        height: kDefaultPadding,
                      ),
                      ShopTable(
                        shopName: "Haumai",
                      ),
                      SizedBox(
                        height: kDefaultPadding,
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
