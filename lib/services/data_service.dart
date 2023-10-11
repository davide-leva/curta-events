import 'package:admin/services/cloud_service.dart';
import 'package:admin/services/socket_service.dart';
import 'package:admin/services/sync_service.dart';

import '../models/Model.dart';

class DataService {
  static Future<List<Map<String, dynamic>>> get(Collection collection) async {
    //return LocalStorage.get(collection);
    return await CloudService.get(collection);
  }

  static Future<void> insert(Collection collection, Model model) async {
    //LocalStorage.insert(collection, model);
    await CloudService.insert(collection, model.toJson());
    SocketService.update(collection);
    return;
  }

  static Future<void> update(
      Collection collection, String id, Model model) async {
    //LocalStorage.update(collection, id, model.toJson());
    await CloudService.update(collection, id, model.toJson());
    if (collection != Collection.parties) SocketService.update(collection);
    return;
  }

  static Future<void> delete(Collection collection, String id) async {
    //LocalStorage.delete(collection, id);
    await CloudService.delete(collection, id);
    SocketService.update(collection);
    return;
  }
}
