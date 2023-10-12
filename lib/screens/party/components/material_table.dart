import 'package:admin/controllers/Config.dart';
import 'package:admin/controllers/ProductsController.dart';
import 'package:admin/controllers/TransactionController.dart';
import 'package:admin/models/Product.dart';
import 'package:admin/screens/components/button.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';
import '../../../controllers/ShopController.dart';
import '../../../models/Entry.dart';

class MaterialTable extends StatefulWidget {
  MaterialTable({
    Key? key,
  }) : super(key: key);

  @override
  State<MaterialTable> createState() => _MaterialTableState();
}

class _MaterialTableState extends State<MaterialTable> {
  final ShopController shopController = Get.put(ShopController());
  final TransactionController transactionController =
      Get.put(TransactionController());
  final ProductController productController = Get.put(ProductController());

  TextEditingController _quantityController = TextEditingController();

  String _selectedProduct = "";
  String _selectedShop = "Carlino";

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
          Row(
            children: [
              Text(
                "Spesa",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Spacer(),
              ActionButton(
                title: "Aggingi",
                onPressed: () {
                  showPopUp(context, "Aggiungi alla spesa", [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: 300,
                            padding: EdgeInsets.only(left: defaultPadding),
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
                              dropdownMenuEntries: productController
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
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: defaultPadding),
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
                                    productController
                                        .getShop(_selectedShop)
                                        .length, (index) {
                                  return DropdownMenuEntry(
                                    value: productController
                                        .getShop(_selectedShop)[index]
                                        .id,
                                    label: productController
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
                    TextInput(
                      textController: _quantityController,
                      label: "Quantità",
                    )
                  ], () {
                    _addNewEntry(_selectedProduct, _quantityController.text,
                        shopController);
                  });
                },
                icon: Icons.shopping_bag,
                color: Colors.lightBlue,
              ),
              SizedBox(
                width: defaultPadding,
              ),
              ActionButton(
                title: "Stampa",
                onPressed: () async {
                  Uri url = Uri.parse(
                      'https://docs.google.com/gview?embedded=true&url=${Config.get('dataEndpoint')}${Config.get('selectedParty')}/report/shop');

                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.platformDefault);
                  }
                },
                icon: Icons.print,
                color: Colors.lightBlue,
              ),
            ],
          ),
          Obx(
            () => shopController.entries.length == 0 ||
                    productController.products.length == 0
                ? Container()
                : SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Text("Prodotto e quantità"),
                        ),
                        DataColumn(
                          label: Text(
                            "Prezzo",
                            overflow: TextOverflow.ellipsis,
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            "Totale",
                            overflow: TextOverflow.ellipsis,
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text("Azioni"),
                        ),
                      ],
                      rows: List.generate(
                        shopController.entries.length,
                        (index) => _dataRow(
                          shopController.entries[index],
                          shopController,
                          productController,
                          transactionController,
                          () {
                            _selectedProduct =
                                shopController.entries[index].product;
                            _quantityController.text =
                                "${shopController.entries[index].quantity}";

                            showPopUp(
                              context,
                              "Modifica spesa",
                              [
                                TextInput(
                                  textController: _quantityController,
                                  label: "Quantità",
                                )
                              ],
                              () {
                                _modifyEntry(
                                  shopController.entries[index],
                                  _selectedProduct,
                                  _quantityController.text,
                                  shopController,
                                );
                              },
                              successTitle: "Modifica",
                              successIcon: Icons.edit,
                            );
                          },
                          () {
                            _purchaseEntry(
                              shopController.entries[index],
                              shopController,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}

DataRow _dataRow(
  Entry entry,
  ShopController shopController,
  ProductController productController,
  TransactionController transactionController,
  Function() onModify,
  Function() onPurchase,
) {
  Product product = productController.products
      .firstWhere((_product) => entry.isProduct(_product));

  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Container(
              width: 40,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: entry.purchased ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("${entry.quantity}")],
              ),
            ),
            SizedBox(
              width: defaultPadding,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: entry.purchased ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(product.name),
            ),
          ],
        ),
      ),
      DataCell(Text("${product.price.toStringAsFixed(2)}€")),
      DataCell(Text("${(entry.quantity * product.price).toStringAsFixed(2)}€")),
      DataCell(
        Row(
          children: [
            TableButton(
              color: Colors.lightBlue,
              icon: Icons.edit,
              onPressed: () {
                onModify();
              },
            ),
            SizedBox(
              width: defaultPadding,
            ),
            TableButton(
              color: Colors.green,
              icon: Icons.done,
              onPressed: () {
                onPurchase();
              },
            ),
            SizedBox(
              width: defaultPadding,
            ),
            TableButton(
              color: Colors.red,
              icon: Icons.close,
              onPressed: () {
                shopController.delete(entry);
              },
            )
          ],
        ),
      )
    ],
  );
}

_modifyEntry(Entry oldEntry, String product, String amount,
    ShopController shopController) {
  Entry entry = Entry(
    id: oldEntry.id,
    product: product,
    quantity: int.parse(amount),
    purchased: oldEntry.purchased,
  );

  shopController.modify(oldEntry, entry);
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

_purchaseEntry(Entry entry, ShopController shopController) {
  Entry modify = Entry(
    id: entry.id,
    product: entry.product,
    quantity: entry.quantity,
    purchased: !entry.purchased,
  );

  shopController.modify(entry, modify);
}
