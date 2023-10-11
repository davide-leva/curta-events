
import 'Model.dart';

class Transaction implements Model {
  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.description,
  });

  final String id;
  final String title;
  final double amount;
  final String description;

  @override
  Map<String, dynamic> toJson({bool db = false}) {
    return {
      '_id': id,
      'title': title,
      'amount': amount,
      'description': description
    };
  }

  @override
  factory Transaction.fromJson(Map<String, dynamic> data) {
    return Transaction(
      id: data['_id'],
      title: data['title'],
      amount: (data['amount'] as num).toDouble(),
      description: data['description'],
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Transaction && id == other.id;
  }
}
