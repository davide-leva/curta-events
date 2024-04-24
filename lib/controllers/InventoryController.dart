import 'package:admin/controllers/ProductsController.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:get/get.dart';

import '../models/Entry.dart';
import '../models/Product.dart';
import '../services/sync_service.dart';
import '../services/updater.dart';

class InventoryController extends GetxController {
  ProductController _productController = Get.put(ProductController());

  final Product _emptyProduct = Product(
      id: "generated", name: "", price: 0, volume: 0, shop: "", measure: "");

  List<Entry> _entries = <Entry>[].obs;
  List<Entry> get entries => _entries;

  double get totalValue => _entries
      .map((entry) =>
          _productController.products
              .singleWhere((product) => product.id == entry.product,
                  orElse: () => _emptyProduct)
              .price *
          entry.quantity)
      .fold<double>(0, (sum, amount) => sum + amount);

  double get totalLitres =>
      _entries
          .map<List<num>>((entry) {
            Product product = _productController.products.singleWhere(
                (product) => product.id == entry.product,
                orElse: () => _emptyProduct);

            if (product.measure == 'cl') {
              return [product.price, product.volume * entry.quantity];
            } else {
              return [0, 0];
            }
          })
          .where((element) => element[0] > 5)
          .fold<double>(0, (sum, element) => sum + element[1]) /
      100;

  @override
  void onReady() {
    _update();
    Updater.listen(Collection.inventory, _update);
    super.onReady();
  }

  Future<void> _update() async {
    _entries.assignAll((await Updater.getData(Collection.inventory))
        .map((data) => Entry.fromJson(data))
        .toList());
    return;
  }

  Future<void> add(Entry entry) async {
    await CloudService.insert(Collection.inventory, entry);
    await Updater.update(Collection.inventory);
    return;
  }

  Future<void> delete(Entry entry) async {
    await CloudService.delete(Collection.inventory, entry.id);
    await Updater.update(Collection.inventory);
    return;
  }

  Future<void> modify(Entry old, Entry newEntry) async {
    await CloudService.update(Collection.inventory, old.id, newEntry);
    await Updater.update(Collection.inventory);
    return;
  }
}
