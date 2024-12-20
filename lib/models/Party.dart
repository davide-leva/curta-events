import 'package:admin/models/Model.dart';

class Party implements Model {
  Party({
    required this.id,
    required this.tag,
    required this.title,
    required this.balance,
    required this.date,
    required this.place,
    required this.pricePrevendita,
    required this.priceEntrance,
    required this.archived,
  });

  final String id;
  final String tag;
  final String title;
  final double balance;
  final DateTime date;
  final String place;
  final int priceEntrance;
  final int pricePrevendita;
  final bool archived;

  @override
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "tag": tag,
      "title": title,
      "balance": balance,
      "date": date.toIso8601String(),
      "place": place,
      "pricePrevendita": pricePrevendita,
      "priceEntrance": priceEntrance,
      "archived": archived,
    };
  }

  @override
  factory Party.fromJson(Map<String, dynamic> data) {
    return Party(
      id: data['_id'],
      tag: data['tag'],
      title: data['title'],
      balance: (data['balance'] as num).toDouble(),
      date: DateTime.parse(data['date']),
      place: data['place'],
      pricePrevendita: data['pricePrevendita'],
      priceEntrance: data['priceEntrance'],
      archived: data['archived'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Party && id == other.id;
  }

  Party withBalance(double newBalance) {
    return Party(
        id: this.id,
        tag: this.tag,
        title: this.title,
        balance: newBalance,
        date: this.date,
        place: this.place,
        pricePrevendita: this.pricePrevendita,
        priceEntrance: this.priceEntrance,
        archived: this.archived);
  }
}
