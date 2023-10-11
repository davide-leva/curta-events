import 'package:admin/models/Product.dart';
import 'package:admin/models/Transaction.dart';
import 'package:get/get.dart';

import '../models/Entry.dart';
import '../models/Group.dart';
import '../models/Person.dart';
import '../services/data_service.dart';
import '../services/sync_service.dart';
import '../services/updater.dart';

class TransactionController extends GetxController {
  List<Transaction> _transactions = <Transaction>[].obs;
  List<Transaction> get transactions => _transactions;

  double get balance => _transactions.fold(0.0, (prev, transaction) {
        return prev + transaction.amount;
      });

  @override
  void onReady() {
    _update();
    Updater.listen(Collection.transactions, _update);
    super.onReady();
  }

  Future<void> _update() async {
    List<ListaGroup> groups = (await Updater.getData(Collection.groups))
        .map((e) => ListaGroup.fromJson(e))
        .toList();

    List<Entry> entries = (await Updater.getData(Collection.shop))
        .map((e) => Entry.fromJson(e))
        .toList();

    List<Product> products = (await Updater.getData(Collection.products))
        .map((e) => Product.fromJson(e))
        .toList();

    _transactions.assignAll((await Updater.getData(Collection.transactions))
        .map((data) => Transaction.fromJson(data))
        .toList());
    _transactions.addAll([
      Transaction(
          id: "do_not_delete",
          title: "Prevendite",
          amount: groups
                  .map((group) => group.people)
                  .fold<List<Person>>(<Person>[], (list, people) {
                    list.addAll(people);
                    return list;
                  })
                  .where((person) => person.hasPaid)
                  .length *
              15,
          description: ""),
      Transaction(
          id: "do_not_delete",
          title: "Spesa",
          amount: entries
              .where((entry) => entry.purchased)
              .map((entry) =>
                  products
                      .singleWhere((product) => product.id == entry.product)
                      .price *
                  entry.quantity)
              .fold(0, (sum, price) => sum - price),
          description: ""),
      Transaction(
        id: "do_not_delete",
        title: "Sconti",
        amount: groups
            .map((group) => group.people)
            .fold<List<Person>>(<Person>[], (list, people) {
              list.addAll(people);
              return list;
            })
            .map((person) => person.discount)
            .fold(0, (sum, discount) => sum - discount),
        description: "",
      )
    ]);

    Updater.update(Collection.parties, cloud: false);
    return;
  }

  Future<void> add(Transaction transaction) async {
    await DataService.insert(Collection.transactions, transaction);
    await Updater.update(Collection.shifts);
    return;
  }

  Future<void> delete(Transaction transaction) async {
    await DataService.delete(Collection.transactions, transaction.id);
    await Updater.update(Collection.shifts);
    return;
  }

  Future<void> modify(Transaction old, Transaction newTransaction) async {
    await DataService.update(Collection.transactions, old.id, newTransaction);
    await Updater.update(Collection.shifts);
    return;
  }
}
