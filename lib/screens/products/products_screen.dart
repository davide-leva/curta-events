import 'package:admin/controllers/ProductsController.dart';
import 'package:admin/models/Product.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:admin/screens/products/components/shop_table.dart';
import 'package:admin/services/cloud_service.dart';
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
            Header(
              screenTitle: "Prodotti",
              buttons: [
                TableButton(
                  color: Colors.lightBlue,
                  icon: Icons.add,
                  onPressed: () => _addNewProduct(context, _productController),
                )
              ],
            ),
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

_addNewProduct(BuildContext context, ProductController controller) {
  TextEditingController _shopController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _volumeController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  ProductController _productController = Get.put(ProductController());
  String _selectedMeasure = "cl";

  showPopUp(
    context,
    "Aggiungi prodotto",
    [
      TextInput(
        textController: _shopController,
        label: "Negozio",
      ),
      TextInput(
        textController: _nameController,
        label: "Nome prodotto",
      ),
      TextInput(textController: _volumeController, label: "Volume"),
      TextInput(
        textController: _priceController,
        label: "Prezzo",
      ),
      Container(
        width: 300,
        padding: EdgeInsets.only(left: kDefaultPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownMenu<String>(
          width: 280,
          hintText: "Unità di misura",
          menuHeight: 300,
          inputDecorationTheme: InputDecorationTheme(
            border: InputBorder.none,
            fillColor: Theme.of(context).cardColor,
          ),
          dropdownMenuEntries: ['cl', 'kg', 'pz', 'm']
              .map((measure) => DropdownMenuEntry(
                    value: measure,
                    label: measure,
                  ))
              .toList(),
          onSelected: (measure) => _selectedMeasure = measure!,
        ),
      ),
    ],
    () => _productController.add(
      Product(
        id: CloudService.uuid(),
        name: _nameController.text,
        price: double.parse(_priceController.text),
        volume: int.parse(_volumeController.text),
        shop: _shopController.text,
        measure: _selectedMeasure,
      ),
    ),
  );
}
