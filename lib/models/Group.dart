import 'dart:convert';

import 'package:admin/models/Model.dart';
import 'Person.dart';

class ListaGroup implements Model {
  ListaGroup({
    required this.id,
    required this.title,
    required this.numberOfPeople,
    required this.people,
  });

  String id;
  String title;
  int numberOfPeople;
  List<Person> people;

  int get totalIncome => numberOfPeople * 15;
  int get actualIncome => people.fold(0, (sum, person) {
        if (person.hasPaid) {
          sum += 15;
        }

        return sum;
      });

  factory ListaGroup.fromJson(dynamic data) {
    return ListaGroup(
      id: data['_id'],
      title: data['title'],
      numberOfPeople: data['numberOfPeople'],
      people: (data['people'] as List)
          .map((person) => Person.fromJson(jsonDecode(person)))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "numberOfPeople": numberOfPeople,
      "people": List.of(people.map((person) => jsonEncode(person.toJson()))),
    };
  }

  @override
  bool operator ==(Object other) {
    return other is ListaGroup && id == other.id;
  }
}
