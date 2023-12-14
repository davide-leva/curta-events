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
    Updater.listen(Collection.parties, _update);
    super.onReady();
  }

  Future<void> _update() async {
    _parties.assignAll((await Updater.getData(Collection.parties))
        .map((data) => Party.fromJson(data))
        .map((party) => party.tag == Config.get('selectedParty')
            ? party
                .withBalance(max(Get.put(TransactionController()).balance, 0))
            : party)
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

    if (old.priceEntrance != newParty.priceEntrance ||
        old.pricePrevendita != newParty.pricePrevendita) {
      await Updater.update(Collection.transactions);
    }
    return;
  }

  Future<void> archive(Party party) async {
    await modify(
      party,
      Party(
          id: party.id,
          tag: party.tag,
          title: party.title,
          balance: Get.put(TransactionController()).balance,
          date: party.date,
          place: party.place,
          pricePrevendita: party.pricePrevendita,
          priceEntrance: party.priceEntrance,
          archived: true),
    );

    return;
  }
}
