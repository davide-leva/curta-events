import 'dart:convert';

import 'package:admin/controllers/Config.dart';
import 'package:admin/models/Backup.dart';
import 'package:admin/models/Model.dart';
import 'package:admin/services/sync_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CloudService {
  static Future<List<Map<String, dynamic>>> get(Collection collection) async {
    Map<String, String> headers = <String, String>{
      'device': Config.get('deviceID'),
      'key': Config.get('key'),
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(
        Uri.parse('${Config.get('dataEndpoint')}${SyncService.id(collection)}'),
        headers: headers);

    return (jsonDecode(response.body) as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  static Future<int> insert(Collection collection, Model model,
      {int? version}) async {
    Map<String, String> headers = <String, String>{
      'device': Config.get('deviceID'),
      'key': Config.get('key'),
      'Content-Type': 'application/json',
    };

    if (version != null) {
      headers['version'] = version.toString();
    }

    http.Response response = await http.post(
      Uri.parse('${Config.get('dataEndpoint')}${SyncService.id(collection)}'),
      headers: headers,
      body: jsonEncode(model.toJson()),
    );

    return jsonDecode(response.body)['version'];
  }

  static Future<int> update(Collection collection, String id, Model model,
      {int? version}) async {
    Map<String, String> headers = <String, String>{
      'device': Config.get('deviceID'),
      'key': Config.get('key'),
      'Content-Type': 'application/json',
    };

    if (version != null) {
      headers['version'] = version.toString();
    }

    http.Response response = await http.patch(
      Uri.parse(
          '${Config.get('dataEndpoint')}${SyncService.id(collection)}/$id'),
      headers: headers,
      body: jsonEncode(model.toJson()),
    );
    return jsonDecode(response.body)['version'];
  }

  static Future<void> delete(Collection collection, String id,
      {int? version}) async {
    Map<String, String> headers = <String, String>{
      'device': Config.get('deviceID'),
      'key': Config.get('key'),
      'Content-Type': 'application/json',
    };

    await http.delete(
        Uri.parse(
            '${Config.get('dataEndpoint')}${SyncService.id(collection)}/$id'),
        headers: headers);

    return;
  }

  static String uuid({bool device = false}) {
    List<String> chars =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
            .split('');

    List<String> id = <String>[];

    for (int i = 0; i < 16; i++) {
      chars.shuffle();
      id.add(chars[0]);
    }

    return id.join("");
  }

  static String deviceId() {
    List<String> chars = "0123456789abcdef".split('');

    List<String> id = <String>[];

    for (int i = 0; i < 6; i++) {
      chars.shuffle();
      id.add(chars[0]);
    }

    if (kIsWeb) {
      return "web-" + id.join("");
    } else {
      return "dev-" + id.join("");
    }
  }

  static Future<int> getInstagramFollowers() async {
    try {
      http.Response response = await http.get(
          Uri.parse(
              'https://i.instagram.com/api/v1/users/web_profile_info/?username=curta_events'),
          headers: {
            'User-Agent':
                'Instagram 76.0.0.15.395 Android (24/7.0; 640dpi; 1440x2560; samsung; SM-G930F; herolte; samsungexynos8890; en_US; 138226743)',
          });

      return jsonDecode(response.body)['data']['user']['edge_followed_by']
          ['count'];
    } on FormatException {
      return int.parse(Config.get('followers'));
    }
  }

  static Uri reportUri(String type) {
    String uri = Config.get('dataEndpoint');

    uri += Config.get('selectedParty');
    uri += '/report/${type}';
    uri += '?device=${Config.get('deviceID')}&key=${Config.get('key')}';

    return Uri.parse(uri);
  }

  static Uri backupUri(Backup backup) {
    String uri = Config.get('dataEndpoint');

    uri += '/backup/${backup.id}';
    uri += '?device=${Config.get('deviceID')}&key=${Config.get('key')}';

    return Uri.parse(uri);
  }
}
