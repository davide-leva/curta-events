import 'dart:convert';

import 'package:admin/services/sync_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Model.dart';

class LocalStorage {
  static SharedPreferences? _storage;

  static init() async {
    _storage = await SharedPreferences.getInstance();
  }

  static List<Map<String, dynamic>> get(Collection collection) {
    return (jsonDecode(
            _storage!.getString("data.${SyncService.id(collection)}") ??
                "[]") as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  static void insert(Collection collection, Model model) {
    List<Map<String, dynamic>> data = get(collection);
    data.add(model.toJson());
    set(collection, data);
  }

  static dynamic set(Collection collection, List<Map<String, dynamic>> data,
      {int? version}) {
    _storage!.setString("data.${SyncService.id(collection)}", jsonEncode(data));
    setVersion(collection, version: version ?? -1);
  }

  static void insertPlain(Collection collection, Map<String, dynamic> model) {
    List<Map<String, dynamic>> data = get(collection);
    data.add(model);
    set(collection, data);
  }

  static void delete(Collection collection, String id) {
    List<Map<String, dynamic>> data = get(collection);
    data.removeWhere((element) => element['_id'].toString().compareTo(id) == 0);
    set(collection, data);
  }

  static void update(
      Collection collection, String id, Map<String, dynamic> changes) {
    List<Map<String, dynamic>> data = LocalStorage.get(collection);
    int index = data
        .indexWhere((element) => element['_id'].toString().compareTo(id) == 0);

    if (index != -1) {
      for (MapEntry<String, dynamic> e in changes.entries) {
        data[index][e.key] = e.value;
      }
      set(collection, data);
    }
  }

  static int getVersion(Collection collection) {
    if (_storage!.containsKey("versions.${SyncService.id(collection)}")) {
      return _storage!.getInt("versions.${SyncService.id(collection)}")!;
    } else {
      return 0;
    }
  }

  static void setVersion(Collection collection, {int version = -1}) {
    if (version == -1) {
      _storage!.setInt(
          "versions.${SyncService.id(collection)}", getVersion(collection) + 1);
    } else {
      _storage!.setInt("versions.${SyncService.id(collection)}", version);
    }
  }

  static void reset() {
    _storage!.clear();
  }
}
