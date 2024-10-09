import 'package:admin/models/Model.dart';

class Person implements Model {
  Person({
    required this.name,
    required this.hasEntered,
    required this.hasPaid,
    this.isSelected = false,
    this.discount = 0.00,
    this.code = 0,
  });

  String name;
  bool hasEntered;
  bool hasPaid;
  bool isSelected;
  double discount;
  int code;

  @override
  Map<String, dynamic> toJson({bool db = false}) {
    return {
      "name": name,
      "hasEntered": hasEntered,
      "hasPaid": hasPaid,
      "discount": discount,
      "code": code,
      "isSelected": isSelected,
    };
  }

  @override
  factory Person.fromJson(dynamic data, {bool db = false}) {
    return Person(
      name: data['name'],
      hasEntered: data['hasEntered'],
      hasPaid: data['hasPaid'],
      discount: data['discount'].toDouble() ?? 0.00,
      code: data['code'] ?? 0,
      isSelected: data['isSelected'] ?? false,
    );
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
