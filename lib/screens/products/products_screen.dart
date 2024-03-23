import 'package:admin/controllers/ProductsController.dart';
import 'package:admin/screens/products/components/shop_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../components/header.dart';

class ProductsScreen extends StatelessWidget {
  ProductsScreen({Key? key}) : super(key: key);

  final ProductController _productController = Get.put(ProductController());

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
                    children: List.generate(
                      _productController.getShops().length * 2 - 1,
                      (index) => index % 2 == 0
                          ? ShopTable(
                              shopName: _productController
                                  .getShops()[(index / 2).floor()])
                          : SizedBox(
                              height: kDefaultPadding,
                            ),
                    ),
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
