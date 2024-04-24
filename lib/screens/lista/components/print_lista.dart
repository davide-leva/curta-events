import 'package:admin/screens/components/table_button.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrintLista extends StatelessWidget {
  const PrintLista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableButton(
        color: Colors.lightBlue,
        icon: Icons.print,
        onPressed: () async {
          Uri url = CloudService.reportUri('lista');

          await launchUrl(url, mode: LaunchMode.platformDefault);
        });
  }
}
