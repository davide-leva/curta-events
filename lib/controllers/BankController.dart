import 'package:admin/controllers/PartiesController.dart';
import 'package:admin/models/BankTransaction.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:admin/services/sync_service.dart';
import 'package:get/get.dart';

import '../services/updater.dart';

extension SortList<T> on List<T> {
  List<T> sorted([int Function(T, T)? compare]) {
    this.sort(compare);
    return this;
  }

  static int asc(int a, int b) {
    return b - a;
  }
}

class BankController extends GetxController {
  PartiesController _partiesController = Get.put(PartiesController());

  List<BankTransaction> _transactions = <BankTransaction>[].obs;
  List<BankTransaction> get transactions => _transactions;

  double get balance => _transactions
      .map((transaction) => transaction.amount)
      .fold<double>(0.0, (prev, sum) => prev + sum);

  List<int> get years => _transactions
      .map((transaction) => transaction.date.year)
      .toSet()
      .toList()
      .sorted(SortList.asc);

  double getCreditYear(int year) => _transactions
      .where((transaction) =>
          transaction.date.year == year && transaction.amount > 0)
      .fold<double>(0, (sum, transaction) => sum + transaction.amount);

  double getDebitYear(int year) => _transactions
      .where((transaction) =>
          transaction.date.year == year && transaction.amount < 0)
      .fold<double>(0, (sum, transaction) => sum + transaction.amount);

  @override
  void onReady() {
    _update();
    Updater.listen(Collection.bank, _update);
    super.onReady();
  }

  Future<void> _update() async {
    _transactions.assignAll((await Updater.getData(Collection.bank))
        .map((data) => BankTransaction.fromJson(data))
        .toList());

    _transactions.addAll(_partiesController.parties.map((party) =>
        BankTransaction(
            id: party.id,
            amount: party.balance,
            date: party.date,
            title: party.title,
            description: "Festa")));

    _transactions.sort((a, b) => -a.date.compareTo(b.date));
    return;
  }

  Future<void> add(BankTransaction transaction) async {
    await CloudService.insert(Collection.bank, transaction);
    await Updater.update(Collection.bank);
    return;
  }

  Future<void> delete(BankTransaction transaction) async {
    await CloudService.delete(Collection.bank, transaction.id);
    await Updater.update(Collection.bank);
    return;
  }

  Future<void> modify(
      BankTransaction old, BankTransaction newTransaction) async {
    await CloudService.update(Collection.bank, old.id, newTransaction);
    await Updater.update(Collection.bank);
    return;
  }
}
