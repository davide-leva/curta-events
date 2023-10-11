import 'Model.dart';

class BankTransaction implements Model {
  BankTransaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.title,
    required this.description,
  });

  final String id;
  final double amount;
  final DateTime date;
  final String title;
  final String description;

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'title': title,
      'description': description
    };
  }

  @override
  factory BankTransaction.fromJson(Map<String, dynamic> json) {
    return BankTransaction(
      id: json['_id'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      title: json['title'],
      description: json['description'] ?? "",
    );
  }
}
