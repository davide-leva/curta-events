import 'dart:math';

import 'package:admin/controllers/Config.dart';
import 'package:admin/controllers/TransactionController.dart';
import 'package:admin/models/Party.dart';
import 'package:admin/services/sync_service.dart';
import 'package:get/get.dart';

import '../services/data_service.dart';
import '../services/updater.dart';

class PartiesController extends GetxController {
  RxList<Party> _parties = <Party>[].obs;
  List<Party> get parties => _parties;

  double get totalIncome =>
      parties.fold(0.0, (sum, party) => sum + max(0, party.balance));

  Party get current => parties
      .firstWhere((element) => element.tag == Config.get('selectedParty'));

  @override
  void onReady() async {
    await _update();

    TransactionController _transactionController =
        Get.put(TransactionController());

    /*Updater.listen(Collection.parties, () {
      if (_transactionController.balance != current.balance)
        modify(
          current,
          Party(
            balance: _transactionController.balance,
            tag: current.tag,
            title: current.title,
            date: current.date,
            place: current.place,
            id: current.id,
          ),
        );
    });*/
    Updater.listen(Collection.parties, _update);

    super.onReady();
  }

  Future<void> _update() async {
    _parties.assignAll((await Updater.getData(Collection.parties))
        .map((data) => Party.fromJson(data))
        .toList());
    _parties.sort((a, b) => -a.date.compareTo(b.date));

    Updater.update(Collection.bank, cloud: false);
    return;
  }

  Future<void> add(Party party) async {
    await DataService.insert(Collection.parties, party);
    await Updater.update(Collection.parties);
    return;
  }

  Future<void> delete(Party party) async {
    await DataService.delete(Collection.parties, party.id);
    await Updater.update(Collection.parties);
    return;
  }

  Future<void> modify(Party old, Party newParty) async {
    await DataService.update(Collection.parties, old.id, newParty);
    await Updater.update(Collection.parties);
    return;
  }
}
