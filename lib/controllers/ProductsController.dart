import 'package:admin/services/sync_service.dart';
import 'package:get/get.dart';

import '../models/Product.dart';
import '../services/data_service.dart';
import '../services/updater.dart';

class ProductController extends GetxController {
  List<Product> _products = <Product>[].obs;
  List<Product> get products => _products;

  @override
  void onReady() {
    _update();
    Updater.listen(Collection.products, _update);
    super.onReady();
  }

  Future<void> _update() async {
    _products.assignAll((await Updater.getData(Collection.products))
        .map((data) => Product.fromJson(data))
        .toList());

    Updater.update(Collection.shop, cloud: false);
    return;
  }

  Future<void> add(Product product) async {
    await DataService.insert(Collection.products, product);
    await Updater.update(Collection.products);
    return;
  }

  Future<void> delete(Product product) async {
    await DataService.delete(Collection.products, product.id);
    await Updater.update(Collection.products);
    return;
  }

  List<String> getShops() {
    return _products.map((product) => product.shop).toSet().toList();
  }

  List<Product> getShop(String shopName) {
    return _products.where((product) => product.shop == shopName).toList();
  }

  Future<void> modify(Product old, Product newProduct) async {
    await DataService.update(Collection.products, old.id, newProduct);
    await Updater.update(Collection.products);
    return;
  }
}
