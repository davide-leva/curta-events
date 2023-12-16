import 'package:admin/controllers/BankController.dart';
import 'package:admin/models/Model.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:admin/services/local_storage.dart';
import 'package:admin/services/sync_service.dart';
import 'package:admin/services/updater.dart';

import '../models/Party.dart';

class Config {
  static List<ConfigEntry> config = <ConfigEntry>[];

  static void init() async {
    Updater.listen(Collection.config, _update);
    List<Map<String, dynamic>> data = LocalStorage.get(Collection.config);

    if (data.isEmpty) {
      config.addAll(defaultConfig);
      _save();
    } else {
      config.addAll(data.map((data) => ConfigEntry.fromJson(data)));
    }

    set(
        'selectedParty',
        (await CloudService.get(Collection.parties)
                .then((data) => data.map((party) => Party.fromJson(party))))
            .toList()
            .sorted((a, b) => a.date.compareTo(b.date))
            .last
            .tag);
  }

  static void _update() async {
    (await Updater.getData(Collection.config))
        .forEach((entry) => set(entry['key'], entry['value']));
  }

  static String get(String key) {
    return config
        .singleWhere((entry) => entry.key == key,
            orElse: () =>
                defaultConfig.singleWhere((element) => element.key == key))
        .value;
  }

  static void set(String key, String value) {
    if (config.map((e) => e.key).contains(key)) {
      ConfigEntry entry = config.singleWhere((element) => element.key == key);
      config[config.indexOf(entry)] = ConfigEntry(
        key: key,
        name: entry.name,
        value: value,
      );
    } else {
      config.add(ConfigEntry(
        key: key,
        name: "",
        value: value,
      ));
    }

    _save();
  }

  static void share(String key, String value) {
    CloudService.update(
      Collection.config,
      key,
      ConfigEntry(
        key: key,
        name: '',
        value: value,
      ),
    );
  }

  static void _save() {
    LocalStorage.set(Collection.config, config.map((e) => e.toJson()).toList());
  }
}

class ConfigEntry implements Model {
  ConfigEntry({
    required this.key,
    required this.name,
    required this.value,
  });

  final String key;
  final String name;
  final String value;

  factory ConfigEntry.fromJson(Map<String, dynamic> data) {
    return ConfigEntry(
      key: data['key'],
      name: data['name'],
      value: data['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'value': value,
    };
  }
}

List<ConfigEntry> defaultConfig = [
  ConfigEntry(
    key: 'selectedParty',
    name: 'Festa selezionata',
    value: 'testparty',
  ),
  ConfigEntry(
    key: 'visibleParties',
    name: 'Numero di feste visibili',
    value: '6',
  ),
  ConfigEntry(
    key: 'deviceID',
    name: 'ID dispositivo',
    value: CloudService.deviceId(),
  ),
  ConfigEntry(
      key: 'key',
      name: 'Chiave API',
      value:
          'd82f725a9f936ec194861cb6b4c896d283f2a1f5ecc7cbd553c8506a5d9cf1ff'),
  ConfigEntry(
      key: 'dataEndpoint',
      name: 'Server dati',
      value: 'https://api.curta-events.it/'),
  ConfigEntry(
      key: 'socketEndpoint',
      name: 'Server socket',
      value: 'wss://api.curta-events.it/'),
  ConfigEntry(
    key: 'operator',
    name: 'Operatore',
    value: 'no_auth',
  ),
  ConfigEntry(
    key: 'place',
    name: 'Postazione',
    value: 'no_auth',
  ),
  ConfigEntry(
    key: 'icon',
    name: 'Icona',
    value: 'no_auth',
  ),
  ConfigEntry(
    key: 'userLevel',
    name: 'Autorizzazione',
    value: 'no_auth',
  ),
  ConfigEntry(
    key: 'colors',
    name: 'Colori feste',
    value:
        '#f77750, #f44915, #c33409, #ffc847, #ffb400, #e09d00, #47c8ff, #0ab6ff, #009de0, #8fe34f, #6dd021, #539f19, #e75f76, #df2a48, #c31d39',
  ),
  ConfigEntry(
    key: 'followers',
    name: 'Followers',
    value: '0',
  ),
  ConfigEntry(
    key: 'cameras',
    name: 'Telecamere',
    value: '[]',
  ),
];
