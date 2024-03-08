import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../constants.dart';
import '../../controllers/Config.dart';
import '../../services/socket_service.dart';
import '../../services/sync_service.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Autenticazione",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              padding: EdgeInsets.all(kDefaultPadding),
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(kDefaultPadding),
              ),
              child: QrImageView(
                data: SyncService.socketChannel.value,
                eyeStyle: QrEyeStyle(
                    color: Colors.white, eyeShape: QrEyeShape.square),
                dataModuleStyle: QrDataModuleStyle(
                  color: Colors.white,
                  dataModuleShape: QrDataModuleShape.circle,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => MobileScanner(
                        onDetect: (capture) => SocketService.parseBarcode(
                                capture, onAdmin: (device, key) {
                              Config.set('operator', device.operator);
                              Config.set('place', device.place);
                              Config.set('key', key);
                              SyncService.answerRing();
                              Navigator.of(context).pop();
                            })));
              },
              child: Container(
                width: 300,
                padding: EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(kDefaultPadding),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Config.get('deviceID'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
