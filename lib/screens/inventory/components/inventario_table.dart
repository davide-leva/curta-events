import 'dart:math';

import 'package:admin/controllers/InventoryController.dart';
import 'package:admin/controllers/ProductsController.dart';
import 'package:admin/models/Entry.dart';
import 'package:admin/models/Product.dart';
import 'package:admin/screens/components/button.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../responsive.dart';
import '../../components/table_button.dart';
import '../../components/text_input.dart';

extension CheckInt on num {
  bool get isInt => this is int || this == this.roundToDouble();
  num get significand => this - this.round();
}

class InventarioTable extends StatefulWidget {
  InventarioTable({
    Key? key,
  }) : super(key: key);

  @override
  State<InventarioTable> createState() => _InventarioTableState();
}

class _InventarioTableState extends State<InventarioTable> {
  InventoryController inventoryController = Get.put(InventoryController());
  ProductController productController = Get.put(ProductController());

  TextEditingController _quantityController = TextEditingController();
  TextEditingController _fractionController = TextEditingController();
  late String _selectedProduct;

  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: _desktopView(context),
      mobile: _mobileView(context),
    );
  }

  Container _desktopView(BuildContext context) {
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
                "Inventario",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Spacer(),
              ActionButton(
                title: "Aggiungi",
                onPressed: () {
                  showPopUp(context, "Aggiungi prodotto", [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: defaultPadding),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownMenu(
                                hintText: "Prodotto",
                                menuHeight: 300,
                                inputDecorationTheme: InputDecorationTheme(
                                    border: InputBorder.none,
                                    fillColor: Theme.of(context).cardColor),
                                dropdownMenuEntries: List.generate(
                                    productController.products.length,
                                    (index) => DropdownMenuEntry(
                                        value: productController
                                            .products[index].id,
                                        label: productController
                                            .products[index].name)),
                                onSelected: (productId) {
                                  setState(() {
                                    _selectedProduct = (productId as String);
                                  });
                                }),
                          ),
                        ),
                      ],
                    ),
                    TextInput(
                      textController: _quantityController,
                      label: "Quantità",
                    )
                  ], () {
                    inventoryController.add(Entry(
                      id: CloudService.uuid(),
                      product: _selectedProduct,
                      quantity: int.parse(_quantityController.text),
                      purchased: false,
                    ));
                  });
                },
                icon: Icons.add_business,
                color: Colors.lightBlue,
              )
            ],
          ),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: DataTable2(
                columns: [
                  DataColumn(
                    label: Text("Prodotto"),
                  ),
                  DataColumn(
                    label: Text("Quantità"),
                  ),
                  DataColumn(
                    label: Text("Modifica"),
                  ),
                  DataColumn(label: Text("Elimina"))
                ],
                rows: List.generate(
                  inventoryController.entries.length,
                  (index) => _dataRow(
                    inventoryController.entries[index],
                    inventoryController,
                    productController,
                    context,
                    () {
                      Product _product = productController.products.singleWhere(
                          (product) =>
                              product.id ==
                              inventoryController.entries[index].product);

                      _quantityController.text =
                          "${inventoryController.entries[index].quantity.floor()}";

                      int remaining = (inventoryController
                                  .entries[index].quantity.significand *
                              _product.volume)
                          .round();
                      _fractionController.text = "$remaining";

                      showPopUp(
                        context,
                        "Modifica quantità",
                        [
                          TextInput(
                            textController: _quantityController,
                            label: "Prodotti interi",
                          ),
                          TextInput(
                              textController: _fractionController,
                              label:
                                  "Quantità rimanente in ${_product.measure}")
                        ],
                        () {
                          inventoryController.modify(
                              inventoryController.entries[index],
                              Entry(
                                id: inventoryController.entries[index].id,
                                product:
                                    inventoryController.entries[index].product,
                                quantity:
                                    double.parse(_quantityController.text) +
                                        double.parse(_fractionController.text) /
                                            _product.volume,
                                purchased: false,
                              ));
                        },
                        successTitle: "Modifica",
                        successIcon: Icons.edit,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _mobileView(BuildContext context) {
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
                "Inventario",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Spacer(),
              TableButton(
                onPressed: () {
                  showPopUp(context, "Aggiungi prodotto", [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: defaultPadding),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownMenu(
                                hintText: "Prodotto",
                                menuHeight: 300,
                                inputDecorationTheme: InputDecorationTheme(
                                    border: InputBorder.none,
                                    fillColor: Theme.of(context).cardColor),
                                dropdownMenuEntries: List.generate(
                                    productController.products.length,
                                    (index) => DropdownMenuEntry(
                                        value: productController
                                            .products[index].id,
                                        label: productController
                                            .products[index].name)),
                                onSelected: (productId) {
                                  setState(() {
                                    _selectedProduct = (productId as String);
                                  });
                                }),
                          ),
                        ),
                      ],
                    ),
                    TextInput(
                      textController: _quantityController,
                      label: "Quantità",
                    )
                  ], () {
                    inventoryController.add(Entry(
                      id: CloudService.uuid(),
                      product: _selectedProduct,
                      quantity: int.parse(_quantityController.text),
                      purchased: false,
                    ));
                  });
                },
                icon: Icons.add_business,
                color: Colors.lightBlue,
              )
            ],
          ),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: defaultPadding,
                  columns: [
                    DataColumn(
                      label: Text("Prodotto"),
                    ),
                    DataColumn(
                      label: Text("Quantità"),
                    ),
                    DataColumn(
                      label: Text("Modifica"),
                    ),
                    DataColumn(label: Text("Elimina"))
                  ],
                  rows: List.generate(
                    inventoryController.entries.length,
                    (index) => _dataRow(
                      inventoryController.entries[index],
                      inventoryController,
                      productController,
                      context,
                      () {
                        Product _product = productController.products
                            .singleWhere((product) =>
                                product.id ==
                                inventoryController.entries[index].product);

                        _quantityController.text =
                            "${inventoryController.entries[index].quantity.floor()}";

                        int remaining = (inventoryController
                                    .entries[index].quantity.significand *
                                _product.volume)
                            .round();
                        _fractionController.text = "$remaining";

                        showPopUp(
                          context,
                          "Modifica quantità",
                          [
                            TextInput(
                              textController: _quantityController,
                              label: "Prodotti interi",
                            ),
                            TextInput(
                                textController: _fractionController,
                                label:
                                    "Quantità rimanente in ${_product.measure}")
                          ],
                          () {
                            inventoryController.modify(
                                inventoryController.entries[index],
                                Entry(
                                  id: inventoryController.entries[index].id,
                                  product: inventoryController
                                      .entries[index].product,
                                  quantity: double.parse(
                                          _quantityController.text) +
                                      double.parse(_fractionController.text) /
                                          _product.volume,
                                  purchased: false,
                                ));
                          },
                          successTitle: "Modifica",
                          successIcon: Icons.edit,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow _dataRow(
    Entry entry,
    InventoryController inventoryController,
    ProductController productController,
    BuildContext context,
    Function() onModify) {
  Product product = productController.products
      .singleWhere((product) => entry.isProduct(product));

  return DataRow(
    cells: [
      DataCell(Row(
        children: [
          Container(
            width: 50,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                entry.quantity.isInt
                    ? Text("${entry.quantity.round()}")
                    : Text(entry.quantity.toStringAsFixed(2))
              ],
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(product.name),
          ),
        ],
      )),
      DataCell(Text(
          "${(entry.quantity * product.volume).round()} ${product.measure}")),
      DataCell(Row(
        children: [
          TableButton(
            color: Colors.lightBlue,
            icon: Icons.arrow_upward,
            onPressed: () {
              inventoryController.modify(
                entry,
                Entry(
                  id: entry.id,
                  product: entry.product,
                  quantity: max(0, entry.quantity + 1),
                  purchased: entry.purchased,
                ),
              );
            },
          ),
          SizedBox(
            width: defaultPadding,
          ),
          TableButton(
            onPressed: onModify,
            icon: Icons.mode,
            color: Colors.lightBlue,
          ),
          SizedBox(
            width: defaultPadding,
          ),
          TableButton(
            color: Colors.lightBlue,
            icon: Icons.arrow_downward,
            onPressed: () {
              inventoryController.modify(
                entry,
                Entry(
                  id: entry.id,
                  product: entry.product,
                  quantity: max(0, entry.quantity - 1),
                  purchased: entry.purchased,
                ),
              );
            },
          ),
        ],
      )),
      DataCell(ActionButton(
        title: "Elimina",
        onPressed: () {
          inventoryController.delete(entry);
        },
        icon: Icons.mode,
        color: Colors.red,
      ))
    ],
  );
}
