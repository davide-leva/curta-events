import 'package:admin/models/Model.dart';

class Person implements Model {
  Person({
    required this.name,
    required this.hasEntered,
    required this.hasPaid,
    this.discount = 0.00,
  });

  String name;
  bool hasEntered;
  bool hasPaid;
  double discount;

  @override
  Map<String, dynamic> toJson({bool db = false}) {
    return {
      "name": name,
      "hasEntered": hasEntered,
      "hasPaid": hasPaid,
      "discount": discount,
    };
  }

  @override
  factory Person.fromJson(dynamic data, {bool db = false}) {
    return Person(
        name: data['name'],
        hasEntered: data['hasEntered'],
        hasPaid: data['hasPaid'],
        discount: data['discount'] ?? 0.00);
  }

  @override
  bool operator ==(Object other) {
    return other is Person && name == other.name;
  }
}

class PersonEntry {
  final Person person;
  final String groupName;
  final int groupIndex;
  final int personIndex;

  PersonEntry(this.person, this.groupName, this.groupIndex, this.personIndex);
}
