import 'package:admin/constants.dart';
import 'package:admin/controllers/ProductsController.dart';
import 'package:admin/controllers/ShopController.dart';
import 'package:admin/models/Entry.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/components/action_button.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductPopUp extends StatefulWidget {
  const AddProductPopUp({
    Key? key,
  }) : super(key: key);

  @override
  State<AddProductPopUp> createState() => _AddProductPopUpState();
}

class _AddProductPopUpState extends State<AddProductPopUp> {
  ProductController _productController = Get.put(ProductController());
  ShopController _shopController = Get.put(ShopController());
  TextEditingController _quantityController = TextEditingController();
  String _selectedShop = "Carlino";
  String _selectedProduct = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SingleChildScrollView(
        child: Container(
          height: 400,
          width: 300,
          color: Theme.of(context).canvasColor,
          child: Column(children: [
            Text(
              "Aggiungi alla spesa",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: kDefaultPadding * 2,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: 300,
                    padding: EdgeInsets.only(left: kDefaultPadding),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownMenu<String>(
                      initialSelection: _selectedShop,
                      width: 280,
                      hintText: "Negozio",
                      menuHeight: 300,
                      inputDecorationTheme: InputDecorationTheme(
                        border: InputBorder.none,
                        fillColor: Theme.of(context).cardColor,
                      ),
                      dropdownMenuEntries: _productController
                          .getShops()
                          .map<DropdownMenuEntry<String>>(
                            (shop) => DropdownMenuEntry<String>(
                              value: shop,
                              label: shop,
                            ),
                          )
                          .toList(),
                      onSelected: (value) {
                        setState(() {
                          _selectedShop = value as String;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: kDefaultPadding,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: kDefaultPadding),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(() => DropdownMenu(
                        hintText: "Prodotto",
                        enableFilter: true,
                        width: 280,
                        menuHeight: 300,
                        inputDecorationTheme: InputDecorationTheme(
                            border: InputBorder.none,
                            fillColor: Theme.of(context).cardColor),
                        dropdownMenuEntries: List.generate(
                            _productController.getShop(_selectedShop).length,
                            (index) {
                          return DropdownMenuEntry(
                            value: _productController
                                .getShop(_selectedShop)[index]
                                .id,
                            label: _productController
                                .getShop(_selectedShop)[index]
                                .name,
                          );
                        }),
                        onSelected: (productId) {
                          setState(() {
                            _selectedProduct = productId as String;
                          });
                        })),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: kDefaultPadding,
            ),
            TextInput(
              textController: _quantityController,
              label: "Quantità",
            ),
            Spacer(),
            Responsive(
              mobile: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TableButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _addNewEntry(
                        _selectedProduct,
                        _quantityController.text,
                        _shopController,
                      );
                    },
                    icon: Icons.check,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: kDefaultPadding,
                  ),
                  TableButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icons.cancel,
                    color: Colors.red,
                  ),
                ],
              ),
              desktop: Row(
                children: [
                  ActionButton(
                    title: "Aggiungi",
                    onPressed: () {
                      Navigator.of(context).pop();
                      _addNewEntry(
                        _selectedProduct,
                        _quantityController.text,
                        _shopController,
                      );
                    },
                    icon: Icons.check,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: kDefaultPadding,
                  ),
                  ActionButton(
                    title: "Annulla",
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icons.cancel,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

_addNewEntry(String productId, String quantity, ShopController controller) {
  Entry entry = Entry(
    id: CloudService.uuid(),
    product: productId,
    quantity: int.parse(quantity),
    purchased: false,
  );
  controller.add(entry);
}
