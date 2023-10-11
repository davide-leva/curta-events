import 'package:admin/models/Model.dart';

import 'Product.dart';

class Entry implements Model {
  const Entry({
    required this.id,
    required this.product,
    required this.quantity,
    required this.purchased,
  });

  final String id;
  final String product;
  final num quantity;
  final bool purchased;

  @override
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "product": product,
      "quantity": quantity,
      "purchased": purchased,
    };
  }

  bool isProduct(Product product) {
    return product.id == this.product;
  }

  factory Entry.fromJson(Map<String, dynamic> data, {bool db = false}) {
    if (db) {
      return Entry(
        id: data['_id'],
        product: data['product'],
        quantity: data['quantity'],
        purchased: data['purchased'] ?? false,
      );
    } else {
      return Entry(
        id: data['_id'],
        product: data['product'],
        quantity: data['quantity'],
        purchased: data['purchased'] ?? false,
      );
    }
  }
}
