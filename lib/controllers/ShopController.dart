import 'package:admin/services/sync_service.dart';
import 'package:get/get.dart';

import '../models/Entry.dart';
import '../services/data_service.dart';
import '../services/updater.dart';

class ShopController extends GetxController {
  List<Entry> _entries = <Entry>[].obs;
  List<Entry> get entries => _entries;

  @override
  void onReady() {
    _update();
    Updater.listen(Collection.shop, _update);
    super.onReady();
  }

  Future<void> _update() async {
    _entries.assignAll((await Updater.getData(Collection.shop))
        .map((data) => Entry.fromJson(data))
        .toList());

    Updater.update(Collection.transactions, cloud: false);
    return;
  }

  Future<void> add(Entry entry) async {
    await DataService.insert(Collection.shop, entry);
    await Updater.update(Collection.shop);
    return;
  }

  Future<void> delete(Entry entry) async {
    await DataService.delete(Collection.shop, entry.id);
    await Updater.update(Collection.shop);
    return;
  }

  Future<void> modify(Entry old, Entry newEntry) async {
    await DataService.update(Collection.shop, old.id, newEntry);
    await Updater.update(Collection.shop);
    return;
  }
}
