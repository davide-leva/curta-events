import 'package:admin/models/Model.dart';

class Backup implements Model {
  const Backup({
    required this.id,
    required this.filename,
    required this.size,
    required this.date,
  });

  final String id;
  final String filename;
  final int size;
  final DateTime date;

  @override
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "filename": filename,
      "size": size,
      "date": date,
    };
  }

  @override
  factory Backup.fromJson(Map<String, dynamic> data) {
    return Backup(
      id: data['_id'],
      filename: data['filename'],
      size: data['size'] as int,
      date: DateTime.parse(data['date']),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Backup && id == other.id;
  }
}
