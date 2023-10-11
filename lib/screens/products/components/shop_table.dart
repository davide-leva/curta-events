import 'package:admin/controllers/ProductsController.dart';
import 'package:admin/models/Product.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/components/button.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';

class ShopTable extends StatefulWidget {
  ShopTable({
    Key? key,
    required this.shopName,
  }) : super(key: key);

  final String shopName;

  @override
  State<ShopTable> createState() => _ShopTableState();
}

class _ShopTableState extends State<ShopTable> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String _selectedMeasure = "cl";

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.put(ProductController());

    return Responsive(
      mobile: _mobileView(context, controller),
      desktop: _desktopView(context, controller),
    );
  }

  Obx _desktopView(BuildContext context, ProductController controller) {
    return Obx(() => Container(
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
                    widget.shopName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Spacer(),
                  ActionButton(
                    title: "Aggiungi",
                    icon: Icons.shopping_bag,
                    color: Colors.lightBlue,
                    onPressed: () {
                      _nameController.text = "";
                      _volumeController.text = "";
                      _priceController.text = "";

                      showPopUp(context, "Aggiungi prodotto", [
                        TextInput(
                          textController: _nameController,
                          label: "Prodotto",
                        ),
                        TextInput(
                          textController: _priceController,
                          label: "Prezzo",
                        ),
                        TextInput(
                          textController: _volumeController,
                          label: "Volume",
                        ),
                        Container(
                          width: 300,
                          padding: EdgeInsets.only(left: defaultPadding),
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
                            onSelected: (measure) => setState(() {
                              _selectedMeasure = measure!;
                            }),
                          ),
                        ),
                      ], () {
                        _addNewProduct(
                            widget.shopName,
                            _nameController.text,
                            _volumeController.text,
                            _priceController.text,
                            _selectedMeasure,
                            controller);
                      });
                    },
                  )
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: DataTable2(
                  columnSpacing: defaultPadding,
                  minWidth: 600,
                  columns: [
                    DataColumn(
                      label: Text("Prodotto"),
                    ),
                    DataColumn(
                      label: Text("Volume"),
                    ),
                    DataColumn(
                      label: Text("Prezzo"),
                    ),
                    DataColumn(
                      label: Text("Azioni"),
                    ),
                  ],
                  rows: List.generate(
                    controller.getShop(widget.shopName).length,
                    (index) => _dataRow(
                      controller.getShop(widget.shopName)[index],
                      context,
                      controller,
                      _nameController,
                      _volumeController,
                      _priceController,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Obx _mobileView(BuildContext context, ProductController controller) {
    return Obx(() => Container(
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
                    widget.shopName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Spacer(),
                  ActionButton(
                    title: "Aggiungi",
                    icon: Icons.shopping_bag,
                    color: Colors.lightBlue,
                    onPressed: () {
                      _nameController.text = "";
                      _volumeController.text = "";
                      _priceController.text = "";

                      showPopUp(context, "Aggiungi prodotto", [
                        TextInput(
                          textController: _nameController,
                          label: "Prodotto",
                        ),
                        TextInput(
                          textController: _priceController,
                          label: "Prezzo",
                        ),
                        TextInput(
                          textController: _volumeController,
                          label: "Volume",
                        ),
                        Container(
                          width: 300,
                          padding: EdgeInsets.only(left: defaultPadding),
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
                            onSelected: (measure) => setState(() {
                              _selectedMeasure = measure!;
                            }),
                          ),
                        ),
                      ], () {
                        _addNewProduct(
                            widget.shopName,
                            _nameController.text,
                            _volumeController.text,
                            _priceController.text,
                            _selectedMeasure,
                            controller);
                      });
                    },
                  )
                ],
              ),
              SizedBox(
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
                        label: Text("Volume"),
                      ),
                      DataColumn(
                        label: Text("Prezzo"),
                      ),
                      DataColumn(
                        label: Text("Azioni"),
                      ),
                    ],
                    rows: List.generate(
                      controller.getShop(widget.shopName).length,
                      (index) => _dataRow(
                        controller.getShop(widget.shopName)[index],
                        context,
                        controller,
                        _nameController,
                        _volumeController,
                        _priceController,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

DataRow _dataRow(
  Product product,
  BuildContext context,
  ProductController controller,
  TextEditingController _nameController,
  TextEditingController _volumeController,
  TextEditingController _priceController,
) {
  return DataRow(
    cells: [
      DataCell(Text(product.name)),
      DataCell(Text("${product.volume} ${product.measure}")),
      DataCell(Text("${product.price.toStringAsFixed(2)}€")),
      DataCell(Row(
        children: [
          TableButton(
            onPressed: () {
              _nameController.text = product.name;
              _volumeController.text = "${product.volume}";
              _priceController.text = "${product.price}";
              String _selectedMeasure = "cl";

              showPopUp(
                context,
                "Modifica ${product.name}",
                [
                  TextInput(
                    textController: _nameController,
                    label: "Prodotto",
                  ),
                  TextInput(
                    textController: _volumeController,
                    label: "Volume",
                  ),
                  TextInput(
                    textController: _priceController,
                    label: "Prezzo",
                  ),
                  Container(
                    width: 300,
                    padding: EdgeInsets.only(left: defaultPadding),
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
                      onSelected: (value) => _selectedMeasure = value!,
                    ),
                  )
                ],
                () => _modifyProduct(
                    product,
                    _nameController.text,
                    _volumeController.text,
                    _priceController.text,
                    _selectedMeasure,
                    controller),
                successTitle: "Modifica",
                successIcon: Icons.edit,
              );
            },
            icon: Icons.edit,
            color: Colors.lightBlue,
          ),
          SizedBox(
            width: defaultPadding,
          ),
          TableButton(
            onPressed: () {
              controller.delete(product);
            },
            icon: Icons.delete,
            color: Colors.red,
          )
        ],
      ))
    ],
  );
}

_modifyProduct(Product product, String name, String volume, String price,
    String measure, ProductController controller) {
  Product _product = Product(
    id: product.id,
    name: name,
    price: double.parse(price),
    volume: int.parse(volume),
    shop: product.shop,
    measure: measure,
  );

  controller.modify(product, _product);
}

_addNewProduct(String shop, String name, String volume, String price,
    String measure, ProductController controller) {
  Product product = Product(
    id: CloudService.uuid(),
    shop: shop,
    name: name,
    volume: int.parse(volume),
    price: double.parse(price),
    measure: measure,
  );

  controller.add(product);
}
