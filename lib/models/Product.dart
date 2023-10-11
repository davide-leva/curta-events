import 'package:admin/models/Model.dart';


class Product implements Model {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.volume,
    required this.shop,
    required this.measure,
  });

  final String id;
  final String name;
  final String shop;
  final double price;
  final int volume;
  final String measure;

  @override
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "shop": shop,
      "name": name,
      "price": price,
      "volume": volume,
      "measure": measure,
    };
  }

  @override
  factory Product.fromJson(Map<String, dynamic> data) {
    return Product(
      id: data['_id'],
      shop: data['shop'],
      name: data['name'],
      price: (data['price'] as num).toDouble(),
      volume: data['volume'],
      measure: data['measure'] ?? 'cl',
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Product && id == other.id;
  }
}
